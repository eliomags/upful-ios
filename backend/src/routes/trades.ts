import { Hono } from 'hono';
import type { Env, TradeRequest, PositionRow, PortfolioRow, TradeRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { tradeRateLimiter } from '../middleware/rate-limit';
import { generateId, now, round } from '../utils/helpers';

const tradeRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
tradeRoutes.use('/*', authMiddleware);

// POST / - Execute a trade
tradeRoutes.post('/', tradeRateLimiter, async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<TradeRequest>();

  // Validate request
  if (!body.ticker || body.ticker.trim() === '') {
    return c.json({ success: false, error: 'Ticker is required' }, 400);
  }
  if (!body.quantity || body.quantity <= 0) {
    return c.json({ success: false, error: 'Quantity must be greater than 0' }, 400);
  }
  if (!['buy', 'sell'].includes(body.side)) {
    return c.json({ success: false, error: 'Invalid side. Must be buy or sell' }, 400);
  }
  if (!['stock', 'crypto', 'etf'].includes(body.asset_type)) {
    return c.json({ success: false, error: 'Invalid asset_type. Must be stock, crypto, or etf' }, 400);
  }

  // Validate ticker format
  const tickerRegex = /^[A-Za-z]{1,5}$/;
  if (!tickerRegex.test(body.ticker.trim())) {
    return c.json({ success: false, error: 'Invalid ticker format' }, 400);
  }

  // Get user's active portfolio
  const portfolio = await c.env.DB.prepare(
    'SELECT * FROM portfolios WHERE user_id = ? AND is_active = 1'
  )
    .bind(userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'No active portfolio found' }, 404);
  }

  // Get current price from KV cache (stored as JSON quote object)
  const priceStr = await c.env.CACHE.get(`quote:${body.ticker.toUpperCase()}`);
  if (!priceStr) {
    return c.json({ success: false, error: 'Price not available. Please try again.' }, 400);
  }

  let price: number;
  try {
    const quoteData = JSON.parse(priceStr);
    // KV stores full quote objects — extract the price field
    price = parseFloat(quoteData.price ?? quoteData.c ?? quoteData.currentPrice ?? priceStr);
  } catch {
    // Fallback: try direct parse if stored as plain number string
    price = parseFloat(priceStr);
  }

  if (isNaN(price) || price <= 0) {
    return c.json({ success: false, error: 'Invalid price data. Please try again.' }, 400);
  }

  const ticker = body.ticker.toUpperCase();
  const timestamp = now();
  const tradeId = generateId();

  if (body.side === 'buy') {
    // BUY LOGIC
    const total_cost = round(body.quantity * price);

    if (portfolio.cash_balance < total_cost) {
      return c.json({ success: false, error: 'Insufficient funds' }, 400);
    }

    // Check if position exists
    const existingPosition = await c.env.DB.prepare(
      'SELECT * FROM positions WHERE portfolio_id = ? AND ticker = ?'
    )
      .bind(portfolio.id, ticker)
      .first<PositionRow>();

    // Deduct cash and update total equity
    const newCashBalance = round(portfolio.cash_balance - total_cost);
    const newTotalEquity = portfolio.total_equity; // Equity stays same (cash -> holdings)

    // Build batch of statements for atomic execution
    const statements = [];

    if (existingPosition) {
      // Update existing position with weighted average cost
      const newQuantity = existingPosition.quantity + body.quantity;
      const newAverageCost = round(
        (existingPosition.average_cost * existingPosition.quantity + price * body.quantity) / newQuantity
      );
      const newMarketValue = round(newQuantity * price);
      const unrealizedPnl = round(newMarketValue - newAverageCost * newQuantity);

      statements.push(
        c.env.DB.prepare(
          'UPDATE positions SET quantity = ?, average_cost = ?, market_value = ?, unrealized_pnl = ?, updated_at = ? WHERE id = ?'
        ).bind(newQuantity, newAverageCost, newMarketValue, unrealizedPnl, timestamp, existingPosition.id)
      );
    } else {
      // Create new position
      const positionId = generateId();
      const market_value = round(body.quantity * price);
      const unrealized_pnl = 0;

      statements.push(
        c.env.DB.prepare(
          'INSERT INTO positions (id, portfolio_id, ticker, asset_type, quantity, average_cost, market_value, unrealized_pnl, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        ).bind(positionId, portfolio.id, ticker, body.asset_type, body.quantity, price, market_value, unrealized_pnl, timestamp, timestamp)
      );
    }

    // Update portfolio cash balance
    statements.push(
      c.env.DB.prepare(
        'UPDATE portfolios SET cash_balance = ?, total_equity = ?, updated_at = ? WHERE id = ?'
      ).bind(newCashBalance, newTotalEquity, timestamp, portfolio.id)
    );

    // Insert trade record
    statements.push(
      c.env.DB.prepare(
        'INSERT INTO trades (id, portfolio_id, ticker, asset_type, side, quantity, price, total_value, executed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).bind(tradeId, portfolio.id, ticker, body.asset_type, body.side, body.quantity, price, total_cost, timestamp)
    );

    // Execute all statements as a batch (atomic)
    await c.env.DB.batch(statements);

    const trade = await c.env.DB.prepare('SELECT * FROM trades WHERE id = ?')
      .bind(tradeId)
      .first<TradeRow>();

    return c.json({
      success: true,
      data: {
        trade,
        portfolio_summary: {
          cash_balance: newCashBalance,
          total_equity: newTotalEquity,
        },
      },
    }, 201);
  } else {
    // SELL LOGIC
    const position = await c.env.DB.prepare(
      'SELECT * FROM positions WHERE portfolio_id = ? AND ticker = ?'
    )
      .bind(portfolio.id, ticker)
      .first<PositionRow>();

    if (!position) {
      return c.json({ success: false, error: 'Position not found' }, 404);
    }

    if (position.quantity < body.quantity) {
      return c.json({ success: false, error: 'Insufficient shares' }, 400);
    }

    const total_value = round(body.quantity * price);
    const newQuantity = position.quantity - body.quantity;

    // Add to cash and update total equity
    const newCashBalance = round(portfolio.cash_balance + total_value);
    const newTotalEquity = portfolio.total_equity; // Equity stays same (holdings -> cash)

    // Build batch of statements for atomic execution
    const statements = [];

    if (newQuantity === 0) {
      // Delete position if quantity becomes 0
      statements.push(
        c.env.DB.prepare('DELETE FROM positions WHERE id = ?')
          .bind(position.id)
      );
    } else {
      // Update position
      const newMarketValue = round(newQuantity * price);
      const unrealizedPnl = round(newMarketValue - position.average_cost * newQuantity);

      statements.push(
        c.env.DB.prepare(
          'UPDATE positions SET quantity = ?, market_value = ?, unrealized_pnl = ?, updated_at = ? WHERE id = ?'
        ).bind(newQuantity, newMarketValue, unrealizedPnl, timestamp, position.id)
      );
    }

    // Update portfolio cash balance
    statements.push(
      c.env.DB.prepare(
        'UPDATE portfolios SET cash_balance = ?, total_equity = ?, updated_at = ? WHERE id = ?'
      ).bind(newCashBalance, newTotalEquity, timestamp, portfolio.id)
    );

    // Insert trade record
    statements.push(
      c.env.DB.prepare(
        'INSERT INTO trades (id, portfolio_id, ticker, asset_type, side, quantity, price, total_value, executed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).bind(tradeId, portfolio.id, ticker, body.asset_type, body.side, body.quantity, price, total_value, timestamp)
    );

    // Execute all statements as a batch (atomic)
    await c.env.DB.batch(statements);

    const trade = await c.env.DB.prepare('SELECT * FROM trades WHERE id = ?')
      .bind(tradeId)
      .first<TradeRow>();

    return c.json({
      success: true,
      data: {
        trade,
        portfolio_summary: {
          cash_balance: newCashBalance,
          total_equity: newTotalEquity,
        },
      },
    }, 201);
  }
});

export { tradeRoutes };
