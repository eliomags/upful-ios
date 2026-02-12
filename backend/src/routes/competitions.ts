import { Hono } from 'hono';
import type { Env, CompetitionRow, PortfolioRow } from '../models/types';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth';
import { generateId, now, currentMonth, parsePagination } from '../utils/helpers';

const competitionRoutes = new Hono<{ Bindings: Env }>();

// GET /current - Get active competitions (optional auth)
competitionRoutes.get('/current', optionalAuthMiddleware, async (c) => {
  const competitions = await c.env.DB.prepare(
    `SELECT id, type, status, start_date, end_date, total_prize_pool, participant_count, created_at
     FROM competitions
     WHERE status = ?
     ORDER BY type ASC`
  )
    .bind('active')
    .all<CompetitionRow>();

  return c.json({
    success: true,
    data: competitions.results || [],
  });
});

// GET /history - Past competitions (authenticated)
competitionRoutes.get('/history', authMiddleware, async (c) => {
  const { page, limit, offset } = parsePagination(new URL(c.req.url).searchParams);

  // Get total count
  const countResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as total FROM competitions WHERE status IN (?, ?)`
  )
    .bind('completed', 'paid_out')
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get paginated results
  const competitions = await c.env.DB.prepare(
    `SELECT id, type, status, start_date, end_date, total_prize_pool, participant_count, created_at
     FROM competitions
     WHERE status IN (?, ?)
     ORDER BY end_date DESC
     LIMIT ? OFFSET ?`
  )
    .bind('completed', 'paid_out', limit, offset)
    .all<CompetitionRow>();

  return c.json({
    success: true,
    data: competitions.results || [],
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

// POST /reset - User's monthly reset choice (authenticated)
competitionRoutes.post('/reset', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{ choice: 'new' | 'keep' }>();

  if (!body.choice || !['new', 'keep'].includes(body.choice)) {
    return c.json({ success: false, error: 'Invalid choice. Must be "new" or "keep"' }, 400);
  }

  const month = currentMonth();
  const startingBalance = parseFloat(c.env.STARTING_BALANCE || '25000');

  let portfolio: PortfolioRow | null = null;

  if (body.choice === 'new') {
    // Deactivate current portfolio
    await c.env.DB.prepare(
      `UPDATE portfolios SET is_active = 0, updated_at = ? WHERE user_id = ? AND is_active = 1`
    )
      .bind(now(), userId)
      .run();

    // Create new portfolio with fresh $25K
    const newPortfolioId = generateId();
    await c.env.DB.prepare(
      `INSERT INTO portfolios (id, user_id, cash_balance, total_equity, is_active, competition_month, created_at, updated_at)
       VALUES (?, ?, ?, ?, 1, ?, ?, ?)`
    )
      .bind(newPortfolioId, userId, startingBalance, startingBalance, month, now(), now())
      .run();

    portfolio = await c.env.DB.prepare(
      `SELECT * FROM portfolios WHERE id = ?`
    )
      .bind(newPortfolioId)
      .first<PortfolioRow>();
  } else {
    // Keep current portfolio - just continue with it
    portfolio = await c.env.DB.prepare(
      `SELECT * FROM portfolios WHERE user_id = ? AND is_active = 1`
    )
      .bind(userId)
      .first<PortfolioRow>();

    // Update competition_month to current month
    if (portfolio) {
      await c.env.DB.prepare(
        `UPDATE portfolios SET competition_month = ?, updated_at = ? WHERE id = ?`
      )
        .bind(month, now(), portfolio.id)
        .run();
    }
  }

  // Record the reset choice
  await c.env.DB.prepare(
    `INSERT INTO monthly_resets (id, user_id, competition_month, choice, processed_at)
     VALUES (?, ?, ?, ?, ?)`
  )
    .bind(generateId(), userId, month, body.choice, now())
    .run();

  return c.json({
    success: true,
    data: {
      choice: body.choice,
      portfolio,
      message: body.choice === 'new'
        ? 'New portfolio created with $25,000'
        : 'Continuing with current portfolio',
    },
  });
});

export { competitionRoutes };
