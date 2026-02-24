import { Hono } from 'hono';
import type { Env, CompetitionRow, PortfolioRow } from '../models/types';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth';
import { generateId, now, currentMonth, parsePagination, calculatePrizeForRank } from '../utils/helpers';

const competitionRoutes = new Hono<{ Bindings: Env }>();

// GET /current - Get active competitions with join status (optional auth)
competitionRoutes.get('/current', optionalAuthMiddleware, async (c) => {
  const userId = c.get('userId') as string | undefined;

  const competitions = await c.env.DB.prepare(
    `SELECT id, type, status, start_date, end_date, total_prize_pool, participant_count, created_at
     FROM competitions
     WHERE status IN (?, ?)
     ORDER BY type ASC`
  )
    .bind('active', 'registration')
    .all<CompetitionRow>();

  // If user is authenticated, check which competitions they've joined
  let joinedIds = new Set<string>();
  if (userId) {
    const joined = await c.env.DB.prepare(
      `SELECT competition_id FROM competition_entries WHERE user_id = ?`
    )
      .bind(userId)
      .all<{ competition_id: string }>();

    for (const entry of joined.results || []) {
      joinedIds.add(entry.competition_id);
    }
  }

  // Enrich competitions with join status and tier info
  const enriched = (competitions.results || []).map((comp) => ({
    ...comp,
    is_joined: joinedIds.has(comp.id),
    // Derive tier from competition type naming or a tier column if added
    // For now, we check if total_prize_pool > 1000 as premium indicator
    // TODO: Add tier column to competitions table for explicit tracking
    tier: (comp.total_prize_pool > 1000) ? 'premium' : 'free',
  }));

  return c.json({
    success: true,
    data: enriched,
  });
});

// GET /past-results - Past competitions with top winners (public)
competitionRoutes.get('/past-results', optionalAuthMiddleware, async (c) => {
  const { page, limit, offset } = parsePagination(new URL(c.req.url).searchParams);

  // Get total count
  const countResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as total FROM competitions WHERE status IN (?, ?)`
  )
    .bind('completed', 'paid_out')
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get past competitions
  const competitions = await c.env.DB.prepare(
    `SELECT id, type, status, start_date, end_date, total_prize_pool, participant_count, created_at
     FROM competitions
     WHERE status IN (?, ?)
     ORDER BY end_date DESC
     LIMIT ? OFFSET ?`
  )
    .bind('completed', 'paid_out', limit, offset)
    .all<CompetitionRow>();

  // For each competition, get top 3 winners
  const results = [];
  for (const comp of competitions.results || []) {
    const winners = await c.env.DB.prepare(
      `SELECT ce.rank, ce.growth_pct, ce.prize_amount, ce.ending_equity,
              u.id as user_id, u.username, u.display_name, u.avatar_key, u.subscription_tier
       FROM competition_entries ce
       JOIN users u ON u.id = ce.user_id
       WHERE ce.competition_id = ? AND ce.rank IS NOT NULL AND ce.rank <= 3
       ORDER BY ce.rank ASC`
    )
      .bind(comp.id)
      .all();

    results.push({
      ...comp,
      tier: (comp.total_prize_pool > 1000) ? 'premium' : 'free',
      winners: (winners.results || []).map((w: any) => ({
        user_id: w.user_id,
        username: w.username,
        display_name: w.display_name,
        avatar_url: w.avatar_key ? `https://jyanik-assets.r2.dev/${w.avatar_key}` : null,
        subscription_tier: w.subscription_tier,
        rank: w.rank,
        growth_pct: w.growth_pct,
        prize_amount: w.prize_amount,
        ending_equity: w.ending_equity,
      })),
    });
  }

  return c.json({
    success: true,
    data: results,
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

// GET /history - Past competitions (authenticated) - kept for backward compat
competitionRoutes.get('/history', authMiddleware, async (c) => {
  const { page, limit, offset } = parsePagination(new URL(c.req.url).searchParams);

  const countResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as total FROM competitions WHERE status IN (?, ?)`
  )
    .bind('completed', 'paid_out')
    .first<{ total: number }>();

  const total = countResult?.total || 0;

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

// POST /:id/join - Join a competition (authenticated)
competitionRoutes.post('/:id/join', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const competitionId = c.req.param('id');

  // Verify competition exists and is joinable
  const competition = await c.env.DB.prepare(
    `SELECT id, status FROM competitions WHERE id = ?`
  )
    .bind(competitionId)
    .first<CompetitionRow>();

  if (!competition) {
    return c.json({ success: false, error: 'Competition not found' }, 404);
  }

  if (competition.status !== 'active' && competition.status !== 'registration') {
    return c.json({ success: false, error: 'Competition is not open for joining' }, 400);
  }

  // Check if user already joined
  const existing = await c.env.DB.prepare(
    `SELECT id FROM competition_entries WHERE competition_id = ? AND user_id = ?`
  )
    .bind(competitionId, userId)
    .first<{ id: string }>();

  if (existing) {
    return c.json({ success: true, data: { already_joined: true, message: 'Already participating' } });
  }

  // Verify user has an active portfolio
  const portfolio = await c.env.DB.prepare(
    `SELECT id, total_equity FROM portfolios WHERE user_id = ? AND is_active = 1`
  )
    .bind(userId)
    .first<PortfolioRow>();

  if (!portfolio) {
    return c.json({ success: false, error: 'No active portfolio found. Create one first.' }, 400);
  }

  // Atomically join and increment participant count
  const entryId = generateId();
  const timestamp = now();

  await c.env.DB.batch([
    c.env.DB.prepare(
      `INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, created_at, updated_at)
       VALUES (?, ?, ?, ?, ?, ?, ?)`
    ).bind(entryId, competitionId, userId, portfolio.id, portfolio.total_equity, timestamp, timestamp),

    c.env.DB.prepare(
      `UPDATE competitions SET participant_count = participant_count + 1 WHERE id = ?`
    ).bind(competitionId),
  ]);

  return c.json({
    success: true,
    data: {
      entry_id: entryId,
      competition_id: competitionId,
      message: 'Successfully joined competition',
    },
  }, 201);
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
    await c.env.DB.prepare(
      `UPDATE portfolios SET is_active = 0, updated_at = ? WHERE user_id = ? AND is_active = 1`
    )
      .bind(now(), userId)
      .run();

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
    portfolio = await c.env.DB.prepare(
      `SELECT * FROM portfolios WHERE user_id = ? AND is_active = 1`
    )
      .bind(userId)
      .first<PortfolioRow>();

    if (portfolio) {
      await c.env.DB.prepare(
        `UPDATE portfolios SET competition_month = ?, updated_at = ? WHERE id = ?`
      )
        .bind(month, now(), portfolio.id)
        .run();
    }
  }

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

// GET /my-history - User's past competition results (authenticated)
// Query params: period_type (optional), tier (optional: free|premium), page, limit
competitionRoutes.get('/my-history', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const params = new URL(c.req.url).searchParams;
  const periodType = params.get('period_type');
  const tier = params.get('tier'); // free | premium — filters by user's tier at competition time
  const { page, limit, offset } = parsePagination(params);

  let whereClause = 'WHERE ce.user_id = ?';
  const bindParams: any[] = [userId];

  if (periodType) {
    whereClause += ' AND c.type = ?';
    bindParams.push(periodType);
  }

  // Filter by user's tier at the time of competition (from leaderboard_cache).
  // Fall back to user's current tier (from users table) when no cache entry exists
  // (e.g. completed competitions where cache was cleaned up).
  if (tier === 'premium') {
    whereClause += ` AND COALESCE(lc.subscription_tier, u.subscription_tier) IN ('premium', 'pro')`;
  } else if (tier === 'free') {
    whereClause += ` AND COALESCE(lc.subscription_tier, u.subscription_tier) = 'free'`;
  }

  const joinClause = `FROM competition_entries ce
     JOIN competitions c ON c.id = ce.competition_id
     LEFT JOIN leaderboard_cache lc ON lc.competition_id = ce.competition_id AND lc.user_id = ce.user_id
     JOIN users u ON u.id = ce.user_id`;

  // Get total count
  const countResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as total ${joinClause} ${whereClause}`
  )
    .bind(...bindParams)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get paginated results with competition info + tier from leaderboard_cache
  const entries = await c.env.DB.prepare(
    `SELECT
       ce.id, ce.competition_id, ce.starting_equity, ce.ending_equity,
       ce.growth_pct, ce.rank, ce.prize_amount, ce.prize_status, ce.created_at,
       c.type, c.start_date, c.end_date, c.total_prize_pool, c.participant_count,
       COALESCE(lc.subscription_tier, u.subscription_tier) as subscription_tier
     ${joinClause}
     ${whereClause}
     ORDER BY c.end_date DESC
     LIMIT ? OFFSET ?`
  )
    .bind(...bindParams, limit, offset)
    .all();

  // Calculate prize_amount on-the-fly when not set in DB
  const enriched = (entries.results || []).map((entry: any) => {
    const rank = entry.rank;
    const pool = entry.total_prize_pool || 0;
    const participants = entry.participant_count || 0;
    const dbPrize = entry.prize_amount;

    // Use DB prize if set and > 0, otherwise calculate from rank + pool
    const prize = (dbPrize && dbPrize > 0)
      ? dbPrize
      : (rank && rank > 0 ? calculatePrizeForRank(rank, pool, participants) : 0);

    return {
      ...entry,
      prize_amount: prize,
    };
  });

  return c.json({
    success: true,
    data: enriched,
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

export { competitionRoutes };
