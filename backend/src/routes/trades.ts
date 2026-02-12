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
    return c.json({ error: 'Ticker is required' }, 400);
  }
  if (!body.quantity || body.quantity <= 0) {
    return c.json({ error: 'Quantity must be greater than 0' }, 400);
  }
  if (!['buy', 'sell'].includes(body.side)) {
    return c.json({ error: 'Invalid side. Must be buy or sell' }, 400);
  }
  if (!['stock', 'crypto', 'etf'].includes(body.asset_type)) {
    return c.json({ error: 'Invalid asset_type. Must be stock, crypto, or etf' }, 400);
  }

  // Get user's active portfolio
  const portfolio = await c.env.DB.prepare(
    'SELECT * FROM portfolios WHERE user_id = ? AND is_active = 1'
  )
    .bind(userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ error: 'No active portfolio found' }, 404);
  }

  // Get current price from KV cache
  const priceStr = await c.env.CACHE.get(`quote:${body.ticker}`);
  if (!priceStr) {
    return c.json({ error: 'Price not available. Please try again.' }, 400);
  }

  const price = parseFloat(priceStr);
  const ticker = body.ticker.toUpperCase();
  const timestamp = now();
  const tradeId = generateId();

  if (body.side === 'buy') {
    // BUY LOGIC
    const total_cost = round(body.quantity * price);

    if (portfolio.cash_balance < total_cost) {
      return c.json({ error: 'Insufficient funds' }, 400);
    }

    // Check if position exists
    const existingPosition = await c.env.DB.prepare(
      'SELECT * FROM positions WHERE portfolio_id = ? AND ticker = ?'
    )
      .bind(portfolio.id, ticker)
      .first<PositionRow>();

    if (existingPosition) {
      // Update existing position with weighted average cost
      const newQuantity = existingPosition.quantity + body.quantity;
      const newAverageCost = round(
        (existingPosition.average_cost * existingPosition.quantity + price * body.quantity) / newQuantity
      );
      const newMarketValue = round(newQuantity * price);
      const unrealizedPnl = round(newMarketValue - newAverageCost * newQuantity);

      await c.env.DB.prepare(
        'UPDATE positions SET quantity = ?, average_cost = ?, market_value = ?, unrealized_pnl = ?, updated_at = ? WHERE id = ?'
      )
        .bind(newQuantity, newAverageCost, newMarketValue, unrealizedPnl, timestamp, existingPosition.id)
        .run();
    } else {
      // Create new position
      const positionId = generateId();
      const market_value = round(body.quantity * price);
      const unrealized_pnl = 0;

      await c.env.DB.prepare(
        'INSERT INTO positions (id, portfolio_id, ticker, asset_type, quantity, average_cost, market_value, unrealized_pnl, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
      )
        .bind(positionId, portfolio.id, ticker, body.asset_type, body.quantity, price, market_value, unrealized_pnl, timestamp, timestamp)
        .run();
    }

    // Deduct cash and update total equity
    const newCashBalance = round(portfolio.cash_balance - total_cost);
    const newTotalEquity = portfolio.total_equity; // Equity stays same (cash -> holdings)

    await c.env.DB.prepare(
      'UPDATE portfolios SET cash_balance = ?, total_equity = ?, updated_at = ? WHERE id = ?'
    )
      .bind(newCashBalance, newTotalEquity, timestamp, portfolio.id)
      .run();

    // Insert trade record
    await c.env.DB.prepare(
      'INSERT INTO trades (id, portfolio_id, ticker, asset_type, side, quantity, price, total_value, executed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
    )
      .bind(tradeId, portfolio.id, ticker, body.asset_type, body.side, body.quantity, price, total_cost, timestamp)
      .run();

    const trade = await c.env.DB.prepare('SELECT * FROM trades WHERE id = ?')
      .bind(tradeId)
      .first<TradeRow>();

    return c.json({
      trade,
      portfolio_summary: {
        cash_balance: newCashBalance,
        total_equity: newTotalEquity,
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
      return c.json({ error: 'Position not found' }, 404);
    }

    if (position.quantity < body.quantity) {
      return c.json({ error: 'Insufficient shares' }, 400);
    }

    const total_value = round(body.quantity * price);
    const newQuantity = position.quantity - body.quantity;

    if (newQuantity === 0) {
      // Delete position if quantity becomes 0
      await c.env.DB.prepare('DELETE FROM positions WHERE id = ?')
        .bind(position.id)
        .run();
    } else {
      // Update position
      const newMarketValue = round(newQuantity * price);
      const unrealizedPnl = round(newMarketValue - position.average_cost * newQuantity);

      await c.env.DB.prepare(
        'UPDATE positions SET quantity = ?, market_value = ?, unrealized_pnl = ?, updated_at = ? WHERE id = ?'
      )
        .bind(newQuantity, newMarketValue, unrealizedPnl, timestamp, position.id)
        .run();
    }

    // Add to cash and update total equity
    const newCashBalance = round(portfolio.cash_balance + total_value);
    const newTotalEquity = portfolio.total_equity; // Equity stays same (holdings -> cash)

    await c.env.DB.prepare(
      'UPDATE portfolios SET cash_balance = ?, total_equity = ?, updated_at = ? WHERE id = ?'
    )
      .bind(newCashBalance, newTotalEquity, timestamp, portfolio.id)
      .run();

    // Insert trade record
    await c.env.DB.prepare(
      'INSERT INTO trades (id, portfolio_id, ticker, asset_type, side, quantity, price, total_value, executed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
    )
      .bind(tradeId, portfolio.id, ticker, body.asset_type, body.side, body.quantity, price, total_value, timestamp)
      .run();

    const trade = await c.env.DB.prepare('SELECT * FROM trades WHERE id = ?')
      .bind(tradeId)
      .first<TradeRow>();

    return c.json({
      trade,
      portfolio_summary: {
        cash_balance: newCashBalance,
        total_equity: newTotalEquity,
      },
    }, 201);
  }
});

export { tradeRoutes };
