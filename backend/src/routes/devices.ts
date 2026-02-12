import { Hono } from 'hono';
import type { Env } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { generateId, now } from '../utils/helpers';

const deviceRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
deviceRoutes.use('/*', authMiddleware);

// POST / - Register device token
deviceRoutes.post('/', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{ token: string; platform?: string }>();

  if (!body.token) {
    return c.json({ success: false, error: 'Token is required' }, 400);
  }

  // Use INSERT OR REPLACE to handle updates
  await c.env.DB.prepare(
    `INSERT OR REPLACE INTO device_tokens (id, user_id, token, platform, created_at, updated_at)
     VALUES (?, ?, ?, ?, ?, ?)`
  )
    .bind(
      generateId(),
      userId,
      body.token,
      body.platform || 'ios',
      now(),
      now()
    )
    .run();

  return c.json({
    success: true,
    message: 'Device token registered',
  });
});

// DELETE /:token - Unregister device
deviceRoutes.delete('/:token', async (c) => {
  const userId = c.get('userId');
  const token = c.req.param('token');

  const result = await c.env.DB.prepare(
    `DELETE FROM device_tokens WHERE user_id = ? AND token = ?`
  )
    .bind(userId, token)
    .run();

  if (result.meta.changes === 0) {
    return c.json({ success: false, error: 'Device token not found' }, 404);
  }

  return c.json({
    success: true,
    message: 'Device token unregistered',
  });
});

export { deviceRoutes };
