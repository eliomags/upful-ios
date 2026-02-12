import { Hono } from 'hono';
import type { Env, NotificationRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { parsePagination, now } from '../utils/helpers';

const notificationRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
notificationRoutes.use('/*', authMiddleware);

// GET / - Get notifications
notificationRoutes.get('/', async (c) => {
  const userId = c.get('userId');
  const params = new URL(c.req.url).searchParams;
  const unreadOnly = params.get('unread_only') === 'true';
  const { page, limit, offset } = parsePagination(params);

  // Build query
  let query = `SELECT * FROM notifications WHERE user_id = ?`;
  const bindParams: any[] = [userId];

  if (unreadOnly) {
    query += ` AND is_read = 0`;
  }

  // Get total count
  const countResult = await c.env.DB.prepare(
    query.replace('*', 'COUNT(*) as total')
  )
    .bind(...bindParams)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get unread count
  const unreadResult = await c.env.DB.prepare(
    `SELECT COUNT(*) as unread FROM notifications WHERE user_id = ? AND is_read = 0`
  )
    .bind(userId)
    .first<{ unread: number }>();

  const unreadCount = unreadResult?.unread || 0;

  // Get paginated results
  query += ` ORDER BY created_at DESC LIMIT ? OFFSET ?`;
  bindParams.push(limit, offset);

  const notifications = await c.env.DB.prepare(query)
    .bind(...bindParams)
    .all<NotificationRow>();

  return c.json({
    success: true,
    data: notifications.results || [],
    unread_count: unreadCount,
    pagination: {
      page,
      limit,
      total,
      has_more: offset + limit < total,
    },
  });
});

// PUT /:id/read - Mark as read
notificationRoutes.put('/:id/read', async (c) => {
  const userId = c.get('userId');
  const notificationId = c.req.param('id');

  const result = await c.env.DB.prepare(
    `UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?`
  )
    .bind(notificationId, userId)
    .run();

  if (result.meta.changes === 0) {
    return c.json({ success: false, error: 'Notification not found' }, 404);
  }

  return c.json({
    success: true,
    message: 'Notification marked as read',
  });
});

// PUT /read-all - Mark all as read
notificationRoutes.put('/read-all', async (c) => {
  const userId = c.get('userId');

  const result = await c.env.DB.prepare(
    `UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0`
  )
    .bind(userId)
    .run();

  return c.json({
    success: true,
    updated_count: result.meta.changes,
  });
});

export { notificationRoutes };
