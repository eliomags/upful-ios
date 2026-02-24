import { Hono } from 'hono';
import type { Env, CompetitionRow, LeaderboardCacheRow } from '../models/types';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth';
import { parsePagination, calculatePrizeForRank } from '../utils/helpers';

const leaderboardRoutes = new Hono<{ Bindings: Env }>();

// GET / - Get leaderboard (optional auth)
// Query params:
//   period = daily | weekly | monthly (default: weekly)
//   tier   = all | free | premium (default: all) — filters by subscription_tier
//   sort   = top_gainers | top_losers | most_active (default: top_gainers) — sort order
//   page, limit
leaderboardRoutes.get('/', optionalAuthMiddleware, async (c) => {
  const params = new URL(c.req.url).searchParams;
  const period = (params.get('period') || 'weekly') as 'daily' | 'weekly' | 'monthly';
  const tier = params.get('tier') || 'all'; // all | free | premium
  const sort = params.get('sort') || params.get('tab') || 'top_gainers'; // backward-compat with 'tab'
  const { page, limit, offset } = parsePagination(params);

  // Find active competition of matching type (include total_prize_pool and participant_count)
  const competition = await c.env.DB.prepare(
    `SELECT id, total_prize_pool, participant_count FROM competitions WHERE type = ? AND status = ? LIMIT 1`
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

  const prizePool = competition.total_prize_pool || 0;
  const participantCount = competition.participant_count || 0;

  // Build query with tier filter
  let query = `SELECT * FROM leaderboard_cache WHERE competition_id = ?`;
  const bindParams: any[] = [competition.id];

  if (tier === 'premium') {
    query += ` AND subscription_tier IN (?, ?)`;
    bindParams.push('premium', 'pro');
  } else if (tier === 'free') {
    query += ` AND subscription_tier = ?`;
    bindParams.push('free');
  }

  // Get total count
  const countResult = await c.env.DB.prepare(
    query.replace('SELECT *', 'SELECT COUNT(*) as total')
  )
    .bind(...bindParams)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Determine sort order
  let orderClause: string;
  switch (sort) {
    case 'top_losers':
      orderClause = 'ORDER BY growth_pct ASC';
      break;
    case 'most_active':
      // Proxy: sort by absolute equity change from starting 25K
      orderClause = 'ORDER BY ABS(total_equity - 25000) DESC';
      break;
    case 'top_gainers':
    default:
      orderClause = 'ORDER BY growth_pct DESC';
      break;
  }

  // Get paginated results with proper sort
  query += ` ${orderClause} LIMIT ? OFFSET ?`;
  bindParams.push(limit, offset);

  const leaderboard = await c.env.DB.prepare(query)
    .bind(...bindParams)
    .all<LeaderboardCacheRow>();

  // Re-rank results, add prize_amount, transform avatar_key → avatar_url
  const results = (leaderboard.results || []).map((entry: any, index: number) => {
    const rank = offset + index + 1;
    return {
      ...entry,
      rank,
      prize_amount: calculatePrizeForRank(rank, prizePool, participantCount),
      avatar_url: entry.avatar_key ? `https://jyanik-assets.r2.dev/${entry.avatar_key}` : null,
      avatar_key: undefined,
    };
  });

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

// GET /me - My position (authenticated)
// Query params:
//   period = daily | weekly | monthly (default: weekly)
//   tier   = all | free | premium (optional) — only return ranking if user's tier matches
leaderboardRoutes.get('/me', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const params = new URL(c.req.url).searchParams;
  const period = (params.get('period') || 'weekly') as 'daily' | 'weekly' | 'monthly';
  const tier = params.get('tier') || 'all';

  // Find active competition of matching type (include prize pool info)
  const competition = await c.env.DB.prepare(
    `SELECT id, total_prize_pool, participant_count FROM competitions WHERE type = ? AND status = ? LIMIT 1`
  )
    .bind(period, 'active')
    .first<CompetitionRow>();

  if (!competition) {
    // Return a graceful "not ranked" response instead of 404
    return c.json({
      success: true,
      data: null,
      message: 'No active competition for this period',
    });
  }

  // Find user's entry in leaderboard (include subscription_tier)
  const entry = await c.env.DB.prepare(
    `SELECT rank, growth_pct, total_equity, subscription_tier FROM leaderboard_cache
     WHERE competition_id = ? AND user_id = ?`
  )
    .bind(competition.id, userId)
    .first<LeaderboardCacheRow>();

  if (!entry) {
    // Return graceful response - user isn't ranked yet
    return c.json({
      success: true,
      data: null,
      message: 'Not ranked in this competition yet',
    });
  }

  // If tier filter is specified, check if user's tier matches the selected tab
  const userTier = (entry as any).subscription_tier || 'free';
  if (tier === 'free' && userTier !== 'free') {
    return c.json({
      success: true,
      data: null,
      message: 'Not participating in free tier',
    });
  }
  if (tier === 'premium' && !['premium', 'pro'].includes(userTier)) {
    return c.json({
      success: true,
      data: null,
      message: 'Not participating in subscribed tier',
    });
  }

  // Compute tier-specific rank (count users with higher growth in the same tier)
  let tierRank = entry.rank;
  if (tier !== 'all') {
    const tierFilter = tier === 'premium'
      ? `AND subscription_tier IN ('premium', 'pro')`
      : `AND subscription_tier = 'free'`;
    const rankResult = await c.env.DB.prepare(
      `SELECT COUNT(*) as better_count FROM leaderboard_cache
       WHERE competition_id = ? ${tierFilter} AND growth_pct > ?`
    )
      .bind(competition.id, entry.growth_pct)
      .first<{ better_count: number }>();
    tierRank = (rankResult?.better_count || 0) + 1;
  }

  const prizePool = competition.total_prize_pool || 0;
  const participantCount = competition.participant_count || 0;

  return c.json({
    success: true,
    data: {
      rank: tierRank,
      growth_pct: entry.growth_pct,
      total_equity: entry.total_equity,
      prize_amount: calculatePrizeForRank(tierRank, prizePool, participantCount),
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
