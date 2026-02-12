import { Context, Next } from 'hono';
import * as jose from 'jose';
import type { Env, JWTPayload } from '../models/types';

// Extend Hono context with user info
declare module 'hono' {
  interface ContextVariableMap {
    userId: string;
    userEmail: string;
    username: string;
    userRole: string;
    userTier: string;
  }
}

/**
 * Auth middleware - validates JWT and sets user context
 * Use on all protected routes
 */
export async function authMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const authHeader = c.req.header('Authorization');

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ success: false, error: 'Missing or invalid Authorization header' }, 401);
  }

  const token = authHeader.substring(7);

  try {
    const secret = new TextEncoder().encode(c.env.JWT_SECRET);
    const { payload } = await jose.jwtVerify(token, secret, {
      algorithms: ['HS256'],
    });

    const jwtPayload = payload as unknown as JWTPayload;

    // Set user info in context
    c.set('userId', jwtPayload.sub);
    c.set('userEmail', jwtPayload.email);
    c.set('username', jwtPayload.username);
    c.set('userRole', jwtPayload.role);
    c.set('userTier', jwtPayload.tier);

    await next();
  } catch (err) {
    if (err instanceof jose.errors.JWTExpired) {
      return c.json({ success: false, error: 'Token expired' }, 401);
    }
    return c.json({ success: false, error: 'Invalid token' }, 401);
  }
}

/**
 * Optional auth - sets user context if token present, but doesn't block
 */
export async function optionalAuthMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const authHeader = c.req.header('Authorization');

  if (authHeader && authHeader.startsWith('Bearer ')) {
    const token = authHeader.substring(7);
    try {
      const secret = new TextEncoder().encode(c.env.JWT_SECRET);
      const { payload } = await jose.jwtVerify(token, secret, {
        algorithms: ['HS256'],
      });
      const jwtPayload = payload as unknown as JWTPayload;
      c.set('userId', jwtPayload.sub);
      c.set('userEmail', jwtPayload.email);
      c.set('username', jwtPayload.username);
      c.set('userRole', jwtPayload.role);
      c.set('userTier', jwtPayload.tier);
    } catch {
      // Token invalid but that's OK for optional auth
    }
  }

  await next();
}

/**
 * Premium-only middleware - blocks free users
 */
export async function premiumMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const tier = c.get('userTier');
  if (tier !== 'premium') {
    return c.json({ success: false, error: 'Premium subscription required' }, 403);
  }
  await next();
}

/**
 * Admin-only middleware
 */
export async function adminMiddleware(c: Context<{ Bindings: Env }>, next: Next) {
  const role = c.get('userRole');
  if (role !== 'admin') {
    return c.json({ success: false, error: 'Admin access required' }, 403);
  }
  await next();
}

/**
 * Generate JWT tokens for a user
 */
export async function generateTokens(
  user: { id: string; email: string; username: string; role: string; subscription_tier: string },
  env: Env
): Promise<{ access_token: string; refresh_token: string; expires_in: number }> {
  const secret = new TextEncoder().encode(env.JWT_SECRET);
  const refreshSecret = new TextEncoder().encode(env.JWT_REFRESH_SECRET || env.JWT_SECRET);

  const accessToken = await new jose.SignJWT({
    sub: user.id,
    email: user.email,
    username: user.username,
    role: user.role,
    tier: user.subscription_tier,
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime('1h')
    .sign(secret);

  const refreshToken = await new jose.SignJWT({
    sub: user.id,
    type: 'refresh',
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime('30d')
    .sign(refreshSecret);

  return {
    access_token: accessToken,
    refresh_token: refreshToken,
    expires_in: 3600, // 1 hour
  };
}
