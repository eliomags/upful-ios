import { Hono } from 'hono';
import type { Env, PortfolioRow, PositionRow, TradeRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { generateId, now, currentMonth, round, pctChange, parsePagination } from '../utils/helpers';
import { YahooFinanceClient } from '../services/market-data/yahoo-finance';

const portfolioRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
portfolioRoutes.use('/*', authMiddleware);

// POST / - Create portfolio
portfolioRoutes.post('/', async (c) => {
  const userId = c.get('userId');

  // Check if user already has active portfolio
  const activePortfolio = await c.env.DB.prepare(
    'SELECT id FROM portfolios WHERE user_id = ? AND is_active = 1'
  )
    .bind(userId)
    .first<PortfolioRow>();

  if (activePortfolio) {
    return c.json({ success: false, error: 'Active portfolio already exists' }, 409);
  }

  const portfolioId = generateId();
  const timestamp = now();
  const competitionMonth = currentMonth();

  await c.env.DB.prepare(
    'INSERT INTO portfolios (id, user_id, cash_balance, total_equity, is_active, competition_month, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
  )
    .bind(portfolioId, userId, 25000, 25000, 1, competitionMonth, timestamp, timestamp)
    .run();

  const portfolio = await c.env.DB.prepare(
    'SELECT * FROM portfolios WHERE id = ?'
  )
    .bind(portfolioId)
    .first<PortfolioRow>();

  return c.json({ success: true, data: portfolio }, 201);
});

// GET /active - Get user's active portfolio with positions
portfolioRoutes.get('/active', async (c) => {
  const userId = c.get('userId');

  // Query active portfolio
  const portfolio = await c.env.DB.prepare(
    'SELECT * FROM portfolios WHERE user_id = ? AND is_active = 1'
  )
    .bind(userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'No active portfolio found' }, 404);
  }

  // Query all positions for the portfolio
  const positionsResult = await c.env.DB.prepare(
    'SELECT * FROM positions WHERE portfolio_id = ?'
  )
    .bind(portfolio.id)
    .all<PositionRow>();

  const rawPositions = positionsResult.results || [];

  // Refresh prices from Yahoo Finance (with KV cache, 15 min TTL)
  const yahooClient = new YahooFinanceClient(c.env);
  const uniqueTickers = [...new Set(rawPositions.map((p) => p.ticker))];

  // Build ticker → asset_type map for Yahoo symbol conversion
  const tickerTypeMap = new Map<string, string>();
  rawPositions.forEach((p) => tickerTypeMap.set(p.ticker, p.asset_type));

  // Crypto tickers need "-USD" suffix for Yahoo (BTC → BTC-USD)
  const toYahooSymbol = (ticker: string): string => {
    return tickerTypeMap.get(ticker) === 'crypto' ? `${ticker}-USD` : ticker;
  };

  // Fetch live prices concurrently (KV cached at 15 min in market routes)
  const priceMap = new Map<string, number>();
  await Promise.all(
    uniqueTickers.map(async (ticker) => {
      try {
        // Check KV cache first (shared with market routes)
        const yahooSymbol = toYahooSymbol(ticker);
        const cacheKey = `quote:${yahooSymbol}`;
        const cached = await c.env.CACHE.get(cacheKey, 'json') as any;
        if (cached?.current_price) {
          priceMap.set(ticker, cached.current_price);
          return;
        }

        // Fetch from Yahoo
        const quote = await yahooClient.getQuote(yahooSymbol);
        if (quote?.current_price) {
          priceMap.set(ticker, quote.current_price);
          // Cache for 15 minutes (same as market routes)
          await c.env.CACHE.put(cacheKey, JSON.stringify(quote), { expirationTtl: 900 });
        }
      } catch (err) {
        console.error(`Failed to fetch price for ${ticker}:`, err);
        // Fall back to DB price
      }
    })
  );

  // Update positions with live prices and persist to DB
  const updateStatements: ReturnType<ReturnType<typeof c.env.DB.prepare>['bind']>[] = [];
  const timestamp = now();
  const positions = rawPositions.map((pos) => {
    const livePrice = priceMap.get(pos.ticker);
    const currentPrice = livePrice ?? pos.current_price;
    const marketValue = round(pos.quantity * currentPrice);
    const costBasis = pos.average_cost * pos.quantity;
    const unrealizedPnl = round(marketValue - costBasis);
    const unrealizedPnlPct = round(pctChange(marketValue, costBasis));

    // Queue DB update if price changed
    if (livePrice && livePrice !== pos.current_price) {
      updateStatements.push(
        c.env.DB.prepare(
          'UPDATE positions SET current_price = ?, market_value = ?, unrealized_pnl = ?, updated_at = ? WHERE id = ?'
        ).bind(livePrice, marketValue, unrealizedPnl, timestamp, pos.id)
      );
    }

    return {
      ...pos,
      current_price: currentPrice,
      market_value: marketValue,
      unrealized_pnl: unrealizedPnl,
      unrealized_pnl_pct: unrealizedPnlPct,
    };
  });

  // Batch update positions in DB (non-blocking, don't fail the response)
  if (updateStatements.length > 0) {
    c.env.DB.batch(updateStatements).catch((err) =>
      console.error('Failed to persist position prices:', err)
    );
  }

  // Calculate holdings_value from live position data
  const holdings_value = positions.reduce((sum, pos) => sum + pos.market_value, 0);

  // Compute total_equity live: cash + holdings (don't trust stale DB value)
  const total_equity = round(portfolio.cash_balance + holdings_value);
  const total_pnl = round(total_equity - 25000);
  const total_pnl_pct = round(pctChange(total_equity, 25000));

  return c.json({
    success: true,
    data: {
      ...portfolio,
      total_equity,
      holdings_value: round(holdings_value),
      total_pnl,
      total_pnl_pct,
      positions,
    },
  });
});

// GET /:id - Get specific portfolio
portfolioRoutes.get('/:id', async (c) => {
  const userId = c.get('userId');
  const portfolioId = c.req.param('id');

  const portfolio = await c.env.DB.prepare(
    'SELECT * FROM portfolios WHERE id = ? AND user_id = ?'
  )
    .bind(portfolioId, userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'Portfolio not found' }, 404);
  }

  return c.json({ success: true, data: portfolio });
});

// GET /:id/positions - Get positions for portfolio
portfolioRoutes.get('/:id/positions', async (c) => {
  const userId = c.get('userId');
  const portfolioId = c.req.param('id');

  // Verify ownership
  const portfolio = await c.env.DB.prepare(
    'SELECT id FROM portfolios WHERE id = ? AND user_id = ?'
  )
    .bind(portfolioId, userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'Portfolio not found' }, 404);
  }

  // Query positions
  const positionsResult = await c.env.DB.prepare(
    'SELECT * FROM positions WHERE portfolio_id = ?'
  )
    .bind(portfolioId)
    .all<PositionRow>();

  const positions = (positionsResult.results || []).map((pos) => ({
    ...pos,
    unrealized_pnl_pct: round(pctChange(pos.market_value, pos.average_cost * pos.quantity)),
  }));

  return c.json({ success: true, data: positions });
});

// GET /:id/transactions - Get trade history (paginated)
portfolioRoutes.get('/:id/transactions', async (c) => {
  const userId = c.get('userId');
  const portfolioId = c.req.param('id');

  // Verify ownership
  const portfolio = await c.env.DB.prepare(
    'SELECT id FROM portfolios WHERE id = ? AND user_id = ?'
  )
    .bind(portfolioId, userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'Portfolio not found' }, 404);
  }

  const { page, limit, offset } = parsePagination(new URL(c.req.url).searchParams);

  // Query trades with pagination
  const tradesResult = await c.env.DB.prepare(
    'SELECT * FROM trades WHERE portfolio_id = ? ORDER BY executed_at DESC LIMIT ? OFFSET ?'
  )
    .bind(portfolioId, limit, offset)
    .all<TradeRow>();

  const trades = tradesResult.results || [];

  // Count total
  const countResult = await c.env.DB.prepare(
    'SELECT COUNT(*) as count FROM trades WHERE portfolio_id = ?'
  )
    .bind(portfolioId)
    .first<{ count: number }>();

  const total = countResult?.count || 0;

  return c.json({
    success: true,
    data: trades,
    pagination: {
      page,
      limit,
      total,
      total_pages: Math.ceil(total / limit),
    },
  });
});

// GET /:id/performance - Get performance over time
portfolioRoutes.get('/:id/performance', async (c) => {
  const userId = c.get('userId');
  const portfolioId = c.req.param('id');
  const range = c.req.query('range') || 'all'; // 7d|1m|3m|6m|1y|all

  // Verify ownership
  const portfolio = await c.env.DB.prepare(
    'SELECT id FROM portfolios WHERE id = ? AND user_id = ?'
  )
    .bind(portfolioId, userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'Portfolio not found' }, 404);
  }

  // Calculate date filter using parameterized query (no string interpolation)
  let snapshotsResult;

  if (range === 'all') {
    snapshotsResult = await c.env.DB.prepare(
      'SELECT * FROM portfolio_snapshots WHERE portfolio_id = ? ORDER BY snapshot_date ASC'
    )
      .bind(portfolioId)
      .all();
  } else {
    let daysAgo = 0;
    switch (range) {
      case '7d': daysAgo = 7; break;
      case '1m': daysAgo = 30; break;
      case '3m': daysAgo = 90; break;
      case '6m': daysAgo = 180; break;
      case '1y': daysAgo = 365; break;
    }

    const filterDate = new Date();
    filterDate.setDate(filterDate.getDate() - daysAgo);
    const filterDateISO = filterDate.toISOString();

    snapshotsResult = await c.env.DB.prepare(
      'SELECT * FROM portfolio_snapshots WHERE portfolio_id = ? AND snapshot_date >= ? ORDER BY snapshot_date ASC'
    )
      .bind(portfolioId, filterDateISO)
      .all();
  }

  const snapshots = snapshotsResult.results || [];

  return c.json({ success: true, data: snapshots });
});

export { portfolioRoutes };
