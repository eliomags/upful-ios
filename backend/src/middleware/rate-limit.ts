import { Context, Next } from 'hono';
import type { Env } from '../models/types';

interface RateLimitConfig {
  maxRequests: number;
  windowSeconds: number;
  keyPrefix?: string;
}

/**
 * Rate limiting middleware using KV
 * Tracks requests per IP per endpoint within a time window
 */
export function rateLimitMiddleware(config: RateLimitConfig) {
  return async (c: Context<{ Bindings: Env }>, next: Next) => {
    const ip = c.req.header('CF-Connecting-IP') || c.req.header('X-Forwarded-For') || 'unknown';
    const prefix = config.keyPrefix || 'rl';
    const key = `${prefix}:${ip}`;

    try {
      const current = await c.env.CACHE.get(key);
      const count = current ? parseInt(current, 10) : 0;

      if (count >= config.maxRequests) {
        return c.json(
          {
            success: false,
            error: 'Too many requests. Please try again later.',
          },
          429
        );
      }

      // Increment counter
      await c.env.CACHE.put(key, String(count + 1), {
        expirationTtl: config.windowSeconds,
      });
    } catch {
      // If KV fails, allow request through (fail open)
    }

    await next();
  };
}

/**
 * Auth rate limiter: 5 attempts per minute per IP
 */
export const authRateLimiter = rateLimitMiddleware({
  maxRequests: 5,
  windowSeconds: 60,
  keyPrefix: 'rl:auth',
});

/**
 * API rate limiter: 100 requests per minute per IP
 */
export const apiRateLimiter = rateLimitMiddleware({
  maxRequests: 100,
  windowSeconds: 60,
  keyPrefix: 'rl:api',
});

/**
 * Trade rate limiter: 30 trades per minute per IP
 */
export const tradeRateLimiter = rateLimitMiddleware({
  maxRequests: 30,
  windowSeconds: 60,
  keyPrefix: 'rl:trade',
});
