import { Hono } from 'hono';
import type { Env, UserRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { now, calculatePrizeForRank } from '../utils/helpers';

const userRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
userRoutes.use('/*', authMiddleware);

// GET /me - Get current user profile
userRoutes.get('/me', async (c) => {
  const userId = c.get('userId');

  const user = await c.env.DB.prepare(
    'SELECT id, username, email, display_name, avatar_key, subscription_tier, paypal_email, phone, created_at, updated_at FROM users WHERE id = ?'
  )
    .bind(userId)
    .first<UserRow>();

  if (!user) {
    return c.json({ error: 'User not found' }, 404);
  }

  // Build avatar_url from avatar_key if present
  const avatar_url = user.avatar_key ? `https://jyanik-assets.r2.dev/${user.avatar_key}` : null;

  return c.json({
    ...user,
    avatar_url,
    avatar_key: undefined, // Remove avatar_key from response
  });
});

// PUT /me - Update profile
userRoutes.put('/me', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{
    display_name?: string;
    paypal_email?: string;
    phone?: string;
  }>();

  const updates: string[] = [];
  const params: any[] = [];

  if (body.display_name !== undefined) {
    updates.push('display_name = ?');
    params.push(body.display_name);
  }
  if (body.paypal_email !== undefined) {
    updates.push('paypal_email = ?');
    params.push(body.paypal_email);
  }
  if (body.phone !== undefined) {
    updates.push('phone = ?');
    params.push(body.phone);
  }

  if (updates.length === 0) {
    return c.json({ error: 'No fields to update' }, 400);
  }

  updates.push('updated_at = ?');
  params.push(now());
  params.push(userId);

  await c.env.DB.prepare(
    `UPDATE users SET ${updates.join(', ')} WHERE id = ?`
  )
    .bind(...params)
    .run();

  // Fetch updated user
  const user = await c.env.DB.prepare(
    'SELECT id, username, email, display_name, avatar_key, subscription_tier, paypal_email, phone, created_at, updated_at FROM users WHERE id = ?'
  )
    .bind(userId)
    .first<UserRow>();

  const avatar_url = user?.avatar_key ? `https://jyanik-assets.r2.dev/${user.avatar_key}` : null;

  return c.json({
    ...user,
    avatar_url,
    avatar_key: undefined,
  });
});

// POST /me/avatar - Upload avatar to R2
userRoutes.post('/me/avatar', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.arrayBuffer();
  const contentType = c.req.header('content-type') || 'image/jpeg';

  // Determine extension from content type
  const ext = contentType.includes('png') ? 'png' : contentType.includes('gif') ? 'gif' : 'jpg';

  // Generate key
  const key = `avatars/${userId}/${Date.now()}.${ext}`;

  // Upload to R2
  await c.env.STORAGE.put(key, body, {
    httpMetadata: {
      contentType,
    },
  });

  // Update user avatar_key in DB
  await c.env.DB.prepare(
    'UPDATE users SET avatar_key = ?, updated_at = ? WHERE id = ?'
  )
    .bind(key, now(), userId)
    .run();

  const avatar_url = `https://jyanik-assets.r2.dev/${key}`;

  return c.json({ avatar_url });
});

// DELETE /me - Delete account (GDPR)
userRoutes.delete('/me', async (c) => {
  const userId = c.get('userId');

  // Delete user (CASCADE will handle related data)
  await c.env.DB.prepare('DELETE FROM users WHERE id = ?')
    .bind(userId)
    .run();

  return c.json({ success: true, message: 'Account deleted' });
});

// GET /:id/public - Public profile for leaderboard
userRoutes.get('/:id/public', async (c) => {
  const targetUserId = c.req.param('id');

  const user = await c.env.DB.prepare(
    'SELECT id, username, display_name, avatar_key, subscription_tier, created_at FROM users WHERE id = ?'
  )
    .bind(targetUserId)
    .first<UserRow>();

  if (!user) {
    return c.json({ error: 'User not found' }, 404);
  }

  const avatar_url = user.avatar_key ? `https://jyanik-assets.r2.dev/${user.avatar_key}` : null;

  return c.json({
    id: user.id,
    username: user.username,
    display_name: user.display_name,
    avatar_url,
    subscription_tier: user.subscription_tier,
    created_at: user.created_at,
  });
});

// GET /:id/performance - User competition performance history (public)
userRoutes.get('/:id/performance', async (c) => {
  const targetUserId = c.req.param('id');

  const user = await c.env.DB.prepare(
    'SELECT id, username, display_name, avatar_key, subscription_tier, created_at FROM users WHERE id = ?'
  )
    .bind(targetUserId)
    .first<UserRow>();

  if (!user) {
    return c.json({ success: false, error: 'User not found' }, 404);
  }

  const avatar_url = user.avatar_key ? `https://jyanik-assets.r2.dev/${user.avatar_key}` : null;

  const history = await c.env.DB.prepare(
    `SELECT
       ce.id, ce.competition_id, ce.starting_equity, ce.ending_equity,
       ce.growth_pct, ce.rank, ce.prize_amount, ce.prize_status, ce.created_at,
       c.type, c.start_date, c.end_date, c.total_prize_pool, c.participant_count
     FROM competition_entries ce
     JOIN competitions c ON c.id = ce.competition_id
     WHERE ce.user_id = ?
     ORDER BY c.end_date DESC
     LIMIT 50`
  )
    .bind(targetUserId)
    .all();

  const rawEntries = history.results || [];

  // Enrich each entry with calculated prize when DB value is 0/NULL
  const entries = rawEntries.map((e: any) => {
    const dbPrize = e.prize_amount;
    const rank = e.rank;
    const pool = e.total_prize_pool || 0;
    const participants = e.participant_count || 0;

    const prize = (dbPrize && dbPrize > 0)
      ? dbPrize
      : (rank && rank > 0 ? calculatePrizeForRank(rank, pool, participants) : 0);

    return { ...e, prize_amount: prize };
  });

  const totalCompetitions = entries.length;
  const wins = entries.filter((e: any) => e.rank === 1).length;
  const topThreeFinishes = entries.filter((e: any) => e.rank && e.rank <= 3).length;
  const bestRank = entries.reduce((best: number | null, e: any) => {
    if (!e.rank) return best;
    return best === null ? e.rank : Math.min(best, e.rank);
  }, null);
  const avgGrowth = totalCompetitions > 0
    ? entries.reduce((sum: number, e: any) => sum + (e.growth_pct || 0), 0) / totalCompetitions
    : 0;
  // Use enriched prize_amount (calculated on-the-fly) for total
  const totalPrizeWon = entries.reduce((sum: number, e: any) => sum + (e.prize_amount || 0), 0);

  return c.json({
    success: true,
    data: {
      user: {
        id: user.id,
        username: user.username,
        display_name: user.display_name,
        avatar_url,
        subscription_tier: user.subscription_tier,
        member_since: user.created_at,
      },
      stats: {
        total_competitions: totalCompetitions,
        wins,
        top_three_finishes: topThreeFinishes,
        best_rank: bestRank,
        avg_growth_pct: Math.round(avgGrowth * 100) / 100,
        total_prize_won: totalPrizeWon,
      },
      history: entries,
    },
  });
});

export { userRoutes };
