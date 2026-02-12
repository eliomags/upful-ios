import { Hono } from 'hono';
import type { Env, SavedScreenerRow } from '../models/types';
import { authMiddleware } from '../middleware/auth';
import { generateId, now } from '../utils/helpers';

const screenerRoutes = new Hono<{ Bindings: Env }>();

// All routes require authentication
screenerRoutes.use('/*', authMiddleware);

// GET / - Get saved screeners
screenerRoutes.get('/', async (c) => {
  const userId = c.get('userId');

  const screeners = await c.env.DB.prepare(
    `SELECT id, title, description, parameters, color, sort_order, is_prebuilt, usage_count, created_at
     FROM saved_screeners
     WHERE user_id = ?
     ORDER BY sort_order ASC`
  )
    .bind(userId)
    .all<SavedScreenerRow>();

  // Parse parameters JSON for each screener
  const results = (screeners.results || []).map((s) => ({
    ...s,
    parameters: JSON.parse(s.parameters),
  }));

  return c.json({
    success: true,
    data: results,
  });
});

// POST / - Save screener
screenerRoutes.post('/', async (c) => {
  const userId = c.get('userId');
  const body = await c.req.json<{
    title: string;
    description?: string;
    parameters: any;
    color?: string;
  }>();

  if (!body.title || !body.parameters) {
    return c.json({ success: false, error: 'Title and parameters are required' }, 400);
  }

  // Get max sort_order
  const maxResult = await c.env.DB.prepare(
    `SELECT MAX(sort_order) as max_order FROM saved_screeners WHERE user_id = ?`
  )
    .bind(userId)
    .first<{ max_order: number | null }>();

  const sortOrder = (maxResult?.max_order || 0) + 1;
  const screenerId = generateId();

  await c.env.DB.prepare(
    `INSERT INTO saved_screeners (id, user_id, title, description, parameters, color, sort_order, is_prebuilt, usage_count, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, 0, 0, ?)`
  )
    .bind(
      screenerId,
      userId,
      body.title,
      body.description || null,
      JSON.stringify(body.parameters),
      body.color || '#007AFF',
      sortOrder,
      now()
    )
    .run();

  const screener = await c.env.DB.prepare(
    `SELECT * FROM saved_screeners WHERE id = ?`
  )
    .bind(screenerId)
    .first<SavedScreenerRow>();

  return c.json({
    success: true,
    data: {
      ...screener,
      parameters: JSON.parse(screener!.parameters),
    },
  });
});

// PUT /:id - Update screener
screenerRoutes.put('/:id', async (c) => {
  const userId = c.get('userId');
  const screenerId = c.req.param('id');
  const body = await c.req.json<{
    title?: string;
    description?: string;
    parameters?: any;
    color?: string;
  }>();

  // Verify ownership
  const existing = await c.env.DB.prepare(
    `SELECT id FROM saved_screeners WHERE id = ? AND user_id = ?`
  )
    .bind(screenerId, userId)
    .first();

  if (!existing) {
    return c.json({ success: false, error: 'Screener not found' }, 404);
  }

  // Build update query
  const updates: string[] = [];
  const params: any[] = [];

  if (body.title !== undefined) {
    updates.push('title = ?');
    params.push(body.title);
  }
  if (body.description !== undefined) {
    updates.push('description = ?');
    params.push(body.description);
  }
  if (body.parameters !== undefined) {
    updates.push('parameters = ?');
    params.push(JSON.stringify(body.parameters));
  }
  if (body.color !== undefined) {
    updates.push('color = ?');
    params.push(body.color);
  }

  if (updates.length === 0) {
    return c.json({ success: false, error: 'No fields to update' }, 400);
  }

  params.push(screenerId, userId);

  await c.env.DB.prepare(
    `UPDATE saved_screeners SET ${updates.join(', ')} WHERE id = ? AND user_id = ?`
  )
    .bind(...params)
    .run();

  // Fetch updated screener
  const screener = await c.env.DB.prepare(
    `SELECT * FROM saved_screeners WHERE id = ?`
  )
    .bind(screenerId)
    .first<SavedScreenerRow>();

  return c.json({
    success: true,
    data: {
      ...screener,
      parameters: JSON.parse(screener!.parameters),
    },
  });
});

// DELETE /:id - Delete screener
screenerRoutes.delete('/:id', async (c) => {
  const userId = c.get('userId');
  const screenerId = c.req.param('id');

  const result = await c.env.DB.prepare(
    `DELETE FROM saved_screeners WHERE id = ? AND user_id = ?`
  )
    .bind(screenerId, userId)
    .run();

  if (result.meta.changes === 0) {
    return c.json({ success: false, error: 'Screener not found' }, 404);
  }

  return c.json({
    success: true,
    message: 'Screener deleted',
  });
});

export { screenerRoutes };
