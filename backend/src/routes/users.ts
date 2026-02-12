import { Hono } from 'hono';
import type { Env, UserRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { now } from '../utils/helpers';

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

export { userRoutes };
