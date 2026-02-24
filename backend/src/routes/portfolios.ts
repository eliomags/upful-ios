import { Hono } from 'hono';
import type { Env, PortfolioRow, PositionRow, TradeRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { generateId, now, currentMonth, round, pctChange, parsePagination } from '../utils/helpers';

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

  const positions = positionsResult.results || [];

  // Calculate holdings_value
  const holdings_value = positions.reduce((sum, pos) => sum + pos.market_value, 0);

  // Calculate total_pnl
  const total_pnl = round(portfolio.total_equity - 25000);
  const total_pnl_pct = round(pctChange(25000, portfolio.total_equity));

  return c.json({
    success: true,
    data: {
      ...portfolio,
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
    unrealized_pnl_pct: round(pctChange(pos.average_cost * pos.quantity, pos.market_value)),
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
