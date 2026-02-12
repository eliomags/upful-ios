import { Hono } from 'hono';
import type { Env, ChatMessageRow } from '../models/types';
import { authMiddleware, premiumMiddleware } from '../middleware/auth';
import { generateId, now, parsePagination, extractTickers } from '../utils/helpers';

const chatRoutes = new Hono<{ Bindings: Env }>();

// All chat routes require authentication + premium
chatRoutes.use('/*', authMiddleware, premiumMiddleware);

// GET /messages - Get chat messages
chatRoutes.get('/messages', async (c) => {
  const params = new URL(c.req.url).searchParams;
  const ticker = params.get('ticker');
  const { page, limit, offset } = parsePagination(params);

  // Build query
  let query = `
    SELECT
      cm.id, cm.user_id, cm.username, cm.content, cm.image_key,
      cm.tickers, cm.is_deleted, cm.created_at,
      u.avatar_key
    FROM chat_messages cm
    LEFT JOIN users u ON u.id = cm.user_id
    WHERE cm.is_deleted = 0
  `;
  const bindParams: any[] = [];

  // Filter by ticker if specified
  if (ticker) {
    query += ` AND cm.tickers LIKE ?`;
    bindParams.push(`%"${ticker}"%`);
  }

  // Get total count
  const countResult = await c.env.DB.prepare(
    query.replace(/SELECT[\s\S]*FROM/, 'SELECT COUNT(*) as total FROM')
  )
    .bind(...bindParams)
    .first<{ total: number }>();

  const total = countResult?.total || 0;

  // Get paginated results
  query += ` ORDER BY cm.created_at DESC LIMIT ? OFFSET ?`;
  bindParams.push(limit, offset);

  const messages = await c.env.DB.prepare(query)
    .bind(...bindParams)
    .all<ChatMessageRow & { avatar_key: string | null }>();

  // Build avatar URLs
  const results = (messages.results || []).map((msg) => ({
    ...msg,
    avatar_url: msg.avatar_key ? `https://jyanik-assets.r2.dev/${msg.avatar_key}` : null,
    avatar_key: undefined,
    tickers: msg.tickers ? JSON.parse(msg.tickers) : [],
  }));

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

// POST /messages - Send message
chatRoutes.post('/messages', async (c) => {
  const userId = c.get('userId');
  const username = c.get('username');
  const body = await c.req.json<{ content?: string; image_key?: string }>();

  if (!body.content && !body.image_key) {
    return c.json({ success: false, error: 'Message must have content or image' }, 400);
  }

  // Extract tickers from content
  const tickers = body.content ? extractTickers(body.content) : [];
  const tickersJson = tickers.length > 0 ? JSON.stringify(tickers) : null;

  const messageId = generateId();

  await c.env.DB.prepare(
    `INSERT INTO chat_messages (id, user_id, username, content, image_key, tickers, is_deleted, created_at)
     VALUES (?, ?, ?, ?, ?, ?, 0, ?)`
  )
    .bind(messageId, userId, username, body.content || null, body.image_key || null, tickersJson, now())
    .run();

  // Fetch created message with user info
  const message = await c.env.DB.prepare(
    `SELECT
       cm.id, cm.user_id, cm.username, cm.content, cm.image_key,
       cm.tickers, cm.is_deleted, cm.created_at,
       u.avatar_key
     FROM chat_messages cm
     LEFT JOIN users u ON u.id = cm.user_id
     WHERE cm.id = ?`
  )
    .bind(messageId)
    .first<ChatMessageRow & { avatar_key: string | null }>();

  return c.json({
    success: true,
    data: {
      ...message,
      avatar_url: message?.avatar_key ? `https://jyanik-assets.r2.dev/${message.avatar_key}` : null,
      avatar_key: undefined,
      tickers: message?.tickers ? JSON.parse(message.tickers) : [],
    },
  });
});

// POST /messages/:id/report - Report message
chatRoutes.post('/messages/:id/report', async (c) => {
  const userId = c.get('userId');
  const messageId = c.req.param('id');
  const body = await c.req.json<{ reason: string }>();

  if (!body.reason) {
    return c.json({ success: false, error: 'Reason is required' }, 400);
  }

  // Verify message exists
  const message = await c.env.DB.prepare(
    `SELECT id FROM chat_messages WHERE id = ?`
  )
    .bind(messageId)
    .first();

  if (!message) {
    return c.json({ success: false, error: 'Message not found' }, 404);
  }

  // TODO: Implement moderation queue
  // For now, just log the report
  console.log(`Message ${messageId} reported by ${userId}: ${body.reason}`);

  return c.json({
    success: true,
    message: 'Report submitted. Our team will review it.',
  });
});

export { chatRoutes };
