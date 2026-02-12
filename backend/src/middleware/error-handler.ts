import { Context } from 'hono';
import type { Env } from '../models/types';

/**
 * Global error handler for the API
 */
export function errorHandler(err: Error, c: Context<{ Bindings: Env }>) {
  console.error(`[ERROR] ${err.message}`, err.stack);

  // Don't leak internal errors in production
  const isProduction = c.env.ENVIRONMENT === 'production';

  return c.json(
    {
      success: false,
      error: isProduction ? 'Internal server error' : err.message,
      ...(isProduction ? {} : { stack: err.stack }),
    },
    500
  );
}

/**
 * Not found handler
 */
export function notFoundHandler(c: Context) {
  return c.json(
    {
      success: false,
      error: `Route not found: ${c.req.method} ${c.req.path}`,
    },
    404
  );
}
