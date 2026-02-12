import { Hono } from 'hono';
import type { Env, CompetitionRow, LeaderboardCacheRow } from '../models/types';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth';
import { parsePagination } from '../utils/helpers';

const leaderboardRoutes = new Hono<{ Bindings: Env }>();

// GET / - Get leaderboard (optional auth)
leaderboardRoutes.get('/', optionalAuthMiddleware, async (c) => {
  const params = new URL(c.req.url).searchParams;
  const period = (params.get('period') || 'daily') as 'daily' | 'weekly' | 'monthly';
  const tab = params.get('tab') || 'all'; // all | subscribed | free
  const { page, limit, offset } = parsePagination(params);

  // Find active competition of matching type
  const competition = await c.env.DB.prepare(
    `SELECT id FROM competitions WHERE type = ? AND status = ? LIMIT 1`
  )
    .bind(period, 'active')
    .first<CompetitionRow>();

  if (!competition) {
    return c.json({
      success: true,
      data: [],
      pagination: { page, limit, total: 0, has_more: false },
    });
  }

  // Build query based on tab filter
  let query = `SELECT * FROM leaderboard_cache WHERE competition_id = ?`;
  const bindParams: any[] = [competition.id];

  if (tab === 'subscribed') {
    query += ` AND subscription_tier = ?`;
    bindParams.push('premium');
  } else if (tab === 'free') {
    query += ` AND subscription_tier = ?`;
    bindParams.push('free');
  }

  // Get total count
  const countResult = await c.env.DB.prepare(
    query.replace('*', 'COUNT(*) as total')
  )
    .bind(...bindParams)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get paginated results
  query += ` ORDER BY rank ASC LIMIT ? OFFSET ?`;
  bindParams.push(limit, offset);

  const leaderboard = await c.env.DB.prepare(query)
    .bind(...bindParams)
    .all<LeaderboardCacheRow>();

  return c.json({
    success: true,
    data: leaderboard.results || [],
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

// GET /me - My position (authenticated)
leaderboardRoutes.get('/me', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const params = new URL(c.req.url).searchParams;
  const period = (params.get('period') || 'daily') as 'daily' | 'weekly' | 'monthly';

  // Find active competition of matching type
  const competition = await c.env.DB.prepare(
    `SELECT id FROM competitions WHERE type = ? AND status = ? LIMIT 1`
  )
    .bind(period, 'active')
    .first<CompetitionRow>();

  if (!competition) {
    return c.json({
      success: false,
      error: 'No active competition found',
    }, 404);
  }

  // Find user's entry in leaderboard
  const entry = await c.env.DB.prepare(
    `SELECT rank, growth_pct, total_equity FROM leaderboard_cache
     WHERE competition_id = ? AND user_id = ?`
  )
    .bind(competition.id, userId)
    .first<LeaderboardCacheRow>();

  if (!entry) {
    return c.json({
      success: false,
      error: 'Not participating in this competition',
    }, 404);
  }

  return c.json({
    success: true,
    data: {
      rank: entry.rank,
      growth_pct: entry.growth_pct,
      total_equity: entry.total_equity,
    },
  });
});

// GET /history - My past positions (authenticated)
leaderboardRoutes.get('/history', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const { page, limit, offset } = parsePagination(new URL(c.req.url).searchParams);

  // Get total count
  const countResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as total FROM competition_entries WHERE user_id = ?`
  )
    .bind(userId)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get paginated results with competition info
  const entries = await c.env.DB.prepare(
    `SELECT
       ce.id, ce.competition_id, ce.starting_equity, ce.ending_equity,
       ce.growth_pct, ce.rank, ce.prize_amount, ce.prize_status, ce.created_at,
       c.type, c.start_date, c.end_date
     FROM competition_entries ce
     JOIN competitions c ON c.id = ce.competition_id
     WHERE ce.user_id = ?
     ORDER BY c.end_date DESC
     LIMIT ? OFFSET ?`
  )
    .bind(userId, limit, offset)
    .all();

  return c.json({
    success: true,
    data: entries.results || [],
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

export { leaderboardRoutes };
