import { Hono } from 'hono';
import type { Env, WatchlistRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { generateId, now } from '../utils/helpers';

const watchlistRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
watchlistRoutes.use('/*', authMiddleware);

// GET / - Get watchlist
watchlistRoutes.get('/', async (c) => {
  const userId = c.get('userId');

  const items = await c.env.DB.prepare(
    `SELECT id, ticker, sort_order, notes, created_at
     FROM watchlist
     WHERE user_id = ?
     ORDER BY sort_order ASC`
  )
    .bind(userId)
    .all<WatchlistRow>();

  return c.json({
    success: true,
    data: items.results || [],
  });
});

// POST / - Add to watchlist
watchlistRoutes.post('/', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{ ticker: string; notes?: string }>();

  if (!body.ticker) {
    return c.json({ success: false, error: 'Ticker is required' }, 400);
  }

  // Get max sort_order
  const maxResult = await c.env.DB.prepare(
    `SELECT MAX(sort_order) as max_order FROM watchlist WHERE user_id = ?`
  )
    .bind(userId)
    .first<{ max_order: number | null }>();

  const sortOrder = (maxResult?.max_order || 0) + 1;
  const itemId = generateId();

  try {
    await c.env.DB.prepare(
      `INSERT INTO watchlist (id, user_id, ticker, sort_order, notes, created_at)
       VALUES (?, ?, ?, ?, ?, ?)`
    )
      .bind(itemId, userId, body.ticker.toUpperCase(), sortOrder, body.notes || null, now())
      .run();

    const item = await c.env.DB.prepare(
      `SELECT * FROM watchlist WHERE id = ?`
    )
      .bind(itemId)
      .first<WatchlistRow>();

    return c.json({
      success: true,
      data: item,
    });
  } catch (err: any) {
    // Handle UNIQUE constraint error
    if (err.message?.includes('UNIQUE')) {
      return c.json({ success: false, error: 'Ticker already in watchlist' }, 409);
    }
    throw err;
  }
});

// DELETE /:ticker - Remove from watchlist
watchlistRoutes.delete('/:ticker', async (c) => {
  const userId = c.get('userId');
  const ticker = c.req.param('ticker').toUpperCase();

  const result = await c.env.DB.prepare(
    `DELETE FROM watchlist WHERE user_id = ? AND ticker = ?`
  )
    .bind(userId, ticker)
    .run();

  if (result.meta.changes === 0) {
    return c.json({ success: false, error: 'Ticker not found in watchlist' }, 404);
  }

  return c.json({
    success: true,
    message: 'Ticker removed from watchlist',
  });
});

// PUT /reorder - Reorder watchlist
watchlistRoutes.put('/reorder', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{ items: Array<{ ticker: string; sort_order: number }> }>();

  if (!body.items || !Array.isArray(body.items)) {
    return c.json({ success: false, error: 'Items array is required' }, 400);
  }

  // Update each item's sort_order
  for (const item of body.items) {
    await c.env.DB.prepare(
      `UPDATE watchlist SET sort_order = ? WHERE user_id = ? AND ticker = ?`
    )
      .bind(item.sort_order, userId, item.ticker.toUpperCase())
      .run();
  }

  return c.json({
    success: true,
    message: 'Watchlist reordered',
  });
});

export { watchlistRoutes };
