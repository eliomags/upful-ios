import { Hono } from 'hono';
import type { Env, CompetitionRow, LeaderboardCacheRow } from '../models/types';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth';
import { parsePagination, calculatePrizeForRank, round } from '../utils/helpers';

const leaderboardRoutes = new Hono<{ Bindings: Env }>();

// ── Date range helpers for extended periods ──

function getQuarterDates(year: number, quarter: number): { start: string; end: string } {
  const startMonth = (quarter - 1) * 3; // 0-indexed month
  const start = new Date(year, startMonth, 1);
  const end = new Date(year, startMonth + 3, 0); // last day of quarter
  return {
    start: start.toISOString().split('T')[0],
    end: end.toISOString().split('T')[0],
  };
}

function getSemiannualDates(year: number, half: number): { start: string; end: string } {
  const startMonth = (half - 1) * 6; // 0 or 6
  const start = new Date(year, startMonth, 1);
  const end = new Date(year, startMonth + 6, 0); // last day of half
  return {
    start: start.toISOString().split('T')[0],
    end: end.toISOString().split('T')[0],
  };
}

function getCurrentQuarter(): number {
  return Math.floor(new Date().getMonth() / 3) + 1;
}

function getCurrentHalf(): number {
  return new Date().getMonth() < 6 ? 1 : 2;
}

// ── Aggregate leaderboard from competition_entries for extended periods ──

async function getAggregatedLeaderboard(
  db: D1Database,
  startDate: string,
  endDate: string,
  tier: string,
  sort: string,
  limit: number,
  offset: number
) {
  // Aggregate: for each user across all competitions in date range,
  // take their best (or latest) growth result.
  // Use AVG growth across competitions as the aggregate metric.
  let tierFilter = '';
  const bindParams: any[] = [startDate, endDate];

  if (tier === 'premium') {
    tierFilter = `AND u.subscription_tier IN (?, ?)`;
    bindParams.push('premium', 'pro');
  } else if (tier === 'free') {
    tierFilter = `AND u.subscription_tier = ?`;
    bindParams.push('free');
  }

  // Sort clause
  let orderClause: string;
  switch (sort) {
    case 'top_losers':
      orderClause = 'ORDER BY avg_growth ASC';
      break;
    case 'most_active':
      orderClause = 'ORDER BY competition_count DESC, ABS(avg_growth) DESC';
      break;
    case 'top_gainers':
    default:
      orderClause = 'ORDER BY avg_growth DESC';
      break;
  }

  // Count total users
  const countQuery = `
    SELECT COUNT(DISTINCT ce.user_id) as total
    FROM competition_entries ce
    JOIN competitions c ON c.id = ce.competition_id
    JOIN users u ON u.id = ce.user_id
    WHERE c.start_date >= ? AND c.end_date <= ?
    ${tierFilter}
  `;
  const countResult = await db.prepare(countQuery)
    .bind(...bindParams)
    .first<{ total: number }>();
  const total = countResult?.total || 0;

  // Get aggregated results
  const dataQuery = `
    SELECT
      ce.user_id,
      u.username,
      u.display_name,
      u.avatar_key,
      u.subscription_tier,
      ROUND(AVG(ce.growth_pct), 2) as avg_growth,
      MAX(ce.ending_equity) as total_equity,
      COUNT(ce.id) as competition_count,
      SUM(COALESCE(ce.prize_amount, 0)) as total_prizes
    FROM competition_entries ce
    JOIN competitions c ON c.id = ce.competition_id
    JOIN users u ON u.id = ce.user_id
    WHERE c.start_date >= ? AND c.end_date <= ?
    ${tierFilter}
    GROUP BY ce.user_id
    ${orderClause}
    LIMIT ? OFFSET ?
  `;
  bindParams.push(limit, offset);

  const results = await db.prepare(dataQuery)
    .bind(...bindParams)
    .all();

  const entries = (results.results || []).map((row: any, index: number) => {
    const rank = offset + index + 1;
    return {
      id: `agg-${row.user_id}`,
      user_id: row.user_id,
      rank,
      username: row.username,
      display_name: row.display_name,
      avatar_url: row.avatar_key ? `https://jyanik-assets.r2.dev/${row.avatar_key}` : null,
      total_equity: row.total_equity || 25000,
      growth_pct: row.avg_growth || 0,
      subscription_tier: row.subscription_tier,
      prize_amount: row.total_prizes || 0,
    };
  });

  return { entries, total };
}

async function getAggregatedMyRanking(
  db: D1Database,
  userId: string,
  startDate: string,
  endDate: string,
  tier: string
) {
  let tierFilter = '';
  const bindParams: any[] = [startDate, endDate];

  if (tier === 'premium') {
    tierFilter = `AND u.subscription_tier IN (?, ?)`;
    bindParams.push('premium', 'pro');
  } else if (tier === 'free') {
    tierFilter = `AND u.subscription_tier = ?`;
    bindParams.push('free');
  }

  // Get user's aggregated growth
  const userQuery = `
    SELECT
      ROUND(AVG(ce.growth_pct), 2) as avg_growth,
      MAX(ce.ending_equity) as total_equity,
      SUM(COALESCE(ce.prize_amount, 0)) as total_prizes,
      u.subscription_tier
    FROM competition_entries ce
    JOIN competitions c ON c.id = ce.competition_id
    JOIN users u ON u.id = ce.user_id
    WHERE ce.user_id = ? AND c.start_date >= ? AND c.end_date <= ?
  `;
  const userResult = await db.prepare(userQuery)
    .bind(userId, startDate, endDate)
    .first<any>();

  if (!userResult || userResult.avg_growth === null) {
    return null;
  }

  // Check tier match
  const userTier = userResult.subscription_tier || 'free';
  if (tier === 'free' && userTier !== 'free') return null;
  if (tier === 'premium' && !['premium', 'pro'].includes(userTier)) return null;

  // Count how many users have higher growth (to compute rank)
  const rankQuery = `
    SELECT COUNT(DISTINCT ce.user_id) as better_count
    FROM competition_entries ce
    JOIN competitions c ON c.id = ce.competition_id
    JOIN users u ON u.id = ce.user_id
    WHERE c.start_date >= ? AND c.end_date <= ?
    ${tierFilter}
    GROUP BY ce.user_id
    HAVING ROUND(AVG(ce.growth_pct), 2) > ?
  `;
  const rankBindParams = [...bindParams, userResult.avg_growth];
  const rankResults = await db.prepare(
    `SELECT COUNT(*) as cnt FROM (${rankQuery})`
  )
    .bind(...rankBindParams)
    .first<{ cnt: number }>();

  const rank = (rankResults?.cnt || 0) + 1;

  return {
    rank,
    growth_pct: userResult.avg_growth || 0,
    total_equity: userResult.total_equity || 25000,
    prize_amount: userResult.total_prizes || 0,
  };
}

// ── GET / — Get leaderboard (optional auth) ──
// Query params:
//   period = daily | weekly | monthly | quarterly | semiannual (default: weekly)
//   tier   = all | free | premium (default: all) — filters by subscription_tier
//   sort   = top_gainers | top_losers | most_active (default: top_gainers)
//   page, limit
leaderboardRoutes.get('/', optionalAuthMiddleware, async (c) => {
  const params = new URL(c.req.url).searchParams;
  const period = params.get('period') || 'weekly';
  const tier = params.get('tier') || 'all';
  const sort = params.get('sort') || params.get('tab') || 'top_gainers';
  const { page, limit, offset } = parsePagination(params);

  // ── Extended periods: aggregate from competition_entries ──
  if (period === 'quarterly' || period === 'semiannual') {
    const year = new Date().getFullYear();
    const { start, end } = period === 'quarterly'
      ? getQuarterDates(year, getCurrentQuarter())
      : getSemiannualDates(year, getCurrentHalf());

    const { entries, total } = await getAggregatedLeaderboard(
      c.env.DB, start, end, tier, sort, limit, offset
    );

    return c.json({
      success: true,
      data: entries,
      pagination: { page, limit, total, has_more: offset + limit < total },
    });
  }

  // ── Standard periods: use leaderboard_cache ──
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

// ── GET /me — My position (authenticated) ──
// Query params:
//   period = daily | weekly | monthly | quarterly | semiannual (default: weekly)
//   tier   = all | free | premium (optional)
leaderboardRoutes.get('/me', authMiddleware, async (c) => {
  const userId = c.get('userId');
  const params = new URL(c.req.url).searchParams;
  const period = params.get('period') || 'weekly';
  const tier = params.get('tier') || 'all';

  // ── Extended periods: aggregate from competition_entries ──
  if (period === 'quarterly' || period === 'semiannual') {
    const year = new Date().getFullYear();
    const { start, end } = period === 'quarterly'
      ? getQuarterDates(year, getCurrentQuarter())
      : getSemiannualDates(year, getCurrentHalf());

    const result = await getAggregatedMyRanking(c.env.DB, userId, start, end, tier);

    if (!result) {
      return c.json({
        success: true,
        data: null,
        message: 'No ranking data for this period',
      });
    }

    return c.json({ success: true, data: result });
  }

  // ── Standard periods: use leaderboard_cache ──
  const competition = await c.env.DB.prepare(
    `SELECT id, total_prize_pool, participant_count FROM competitions WHERE type = ? AND status = ? LIMIT 1`
  )
    .bind(period, 'active')
    .first<CompetitionRow>();

  if (!competition) {
    return c.json({
      success: true,
      data: null,
      message: 'No active competition for this period',
    });
  }

  // Find user's entry in leaderboard
  const entry = await c.env.DB.prepare(
    `SELECT rank, growth_pct, total_equity, subscription_tier FROM leaderboard_cache
     WHERE competition_id = ? AND user_id = ?`
  )
    .bind(competition.id, userId)
    .first<LeaderboardCacheRow>();

  if (!entry) {
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

  // Compute tier-specific rank
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

// ── GET /history — My past positions (authenticated) ──
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
