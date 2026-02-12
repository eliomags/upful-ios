import { Hono } from 'hono';
import bcrypt from 'bcryptjs';
import * as jose from 'jose';
import type { Env, RegisterRequest, LoginRequest, AppleAuthRequest, UserRow } from '../models/types';
import { generateTokens } from '../middleware/auth';
import { authRateLimiter } from '../middleware/rate-limit';
import { generateId, isValidEmail, isValidUsername, isValidPassword, sha256, now } from '../utils/helpers';

const authRoutes = new Hono<{ Bindings: Env }>();

// ============================================================
// POST /register - Register new user
// ============================================================
authRoutes.post('/register', authRateLimiter, async (c) => {
  try {
    const body = await c.req.json<RegisterRequest>();
    const { email, username, password, display_name } = body;

    // Validate inputs
    if (!email || !username || !password) {
      return c.json({ success: false, error: 'Email, username, and password are required' }, 400);
    }

    if (!isValidEmail(email)) {
      return c.json({ success: false, error: 'Invalid email format' }, 400);
    }

    if (!isValidUsername(username)) {
      return c.json({ success: false, error: 'Username must be 3-30 characters, alphanumeric and underscore only' }, 400);
    }

    if (!isValidPassword(password)) {
      return c.json({ success: false, error: 'Password must be at least 8 characters with at least 1 letter and 1 number' }, 400);
    }

    // Check email uniqueness
    const existingEmail = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?')
      .bind(email.toLowerCase())
      .first();

    if (existingEmail) {
      return c.json({ success: false, error: 'Email already registered' }, 409);
    }

    // Check username uniqueness
    const existingUsername = await c.env.DB.prepare('SELECT id FROM users WHERE username = ?')
      .bind(username)
      .first();

    if (existingUsername) {
      return c.json({ success: false, error: 'Username already taken' }, 409);
    }

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    // Generate user ID
    const userId = generateId();
    const timestamp = now();

    // Insert user
    await c.env.DB.prepare(
      `INSERT INTO users (
        id, email, username, display_name, password_hash,
        subscription_tier, role, is_banned, email_verified, phone_verified,
        created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, 'free', 'user', 0, 0, 0, ?, ?)`
    )
      .bind(userId, email.toLowerCase(), username, display_name || null, password_hash, timestamp, timestamp)
      .run();

    // Create initial portfolio with $25K
    const portfolioId = generateId();
    await c.env.DB.prepare(
      `INSERT INTO portfolios (
        id, user_id, cash_balance, total_equity, is_active, created_at, updated_at
      ) VALUES (?, ?, 25000, 25000, 1, ?, ?)`
    )
      .bind(portfolioId, userId, timestamp, timestamp)
      .run();

    // Generate tokens
    const tokens = await generateTokens(
      {
        id: userId,
        email: email.toLowerCase(),
        username,
        role: 'user',
        subscription_tier: 'free',
      },
      c.env
    );

    // Store refresh token hash in DB
    const refreshTokenHash = await sha256(tokens.refresh_token);
    await c.env.DB.prepare(
      `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, created_at)
       VALUES (?, ?, ?, datetime('now', '+30 days'), ?)`
    )
      .bind(generateId(), userId, refreshTokenHash, timestamp)
      .run();

    // Build user profile
    const user = {
      id: userId,
      email: email.toLowerCase(),
      username,
      display_name: display_name || null,
      avatar_url: null,
      paypal_email: null,
      subscription_tier: 'free' as const,
      created_at: timestamp,
    };

    return c.json(
      {
        success: true,
        data: {
          user,
          tokens: {
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token,
            expires_in: tokens.expires_in,
            token_type: 'Bearer' as const,
          },
        },
      },
      201
    );
  } catch (err) {
    console.error('Register error:', err);
    return c.json({ success: false, error: 'Registration failed' }, 500);
  }
});

// ============================================================
// POST /login - Login with email/password
// ============================================================
authRoutes.post('/login', authRateLimiter, async (c) => {
  try {
    const body = await c.req.json<LoginRequest>();
    const { email, password } = body;

    if (!email || !password) {
      return c.json({ success: false, error: 'Email and password are required' }, 400);
    }

    // Find user by email
    const user = await c.env.DB.prepare(
      `SELECT id, email, username, display_name, password_hash, avatar_key,
              paypal_email, subscription_tier, role, is_banned, created_at
       FROM users
       WHERE email = ?`
    )
      .bind(email.toLowerCase())
      .first<UserRow>();

    if (!user) {
      return c.json({ success: false, error: 'Invalid email or password' }, 401);
    }

    // Check if user is banned
    if (user.is_banned) {
      return c.json({ success: false, error: 'Account is banned' }, 403);
    }

    // Verify password
    if (!user.password_hash) {
      return c.json({ success: false, error: 'Invalid email or password' }, 401);
    }

    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return c.json({ success: false, error: 'Invalid email or password' }, 401);
    }

    // Generate tokens
    const tokens = await generateTokens(
      {
        id: user.id,
        email: user.email,
        username: user.username,
        role: user.role,
        subscription_tier: user.subscription_tier,
      },
      c.env
    );

    // Store refresh token hash
    const refreshTokenHash = await sha256(tokens.refresh_token);
    await c.env.DB.prepare(
      `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, created_at)
       VALUES (?, ?, ?, datetime('now', '+30 days'), ?)`
    )
      .bind(generateId(), user.id, refreshTokenHash, now())
      .run();

    // Build user profile
    const userProfile = {
      id: user.id,
      email: user.email,
      username: user.username,
      display_name: user.display_name,
      avatar_url: user.avatar_key ? `/api/storage/${user.avatar_key}` : null,
      paypal_email: user.paypal_email,
      subscription_tier: user.subscription_tier,
      created_at: user.created_at,
    };

    return c.json({
      success: true,
      data: {
        user: userProfile,
        tokens: {
          access_token: tokens.access_token,
          refresh_token: tokens.refresh_token,
          expires_in: tokens.expires_in,
          token_type: 'Bearer' as const,
        },
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    return c.json({ success: false, error: 'Login failed' }, 500);
  }
});

// ============================================================
// POST /apple - Sign in with Apple
// ============================================================
authRoutes.post('/apple', authRateLimiter, async (c) => {
  try {
    const body = await c.req.json<AppleAuthRequest>();
    const { identity_token } = body;

    if (!identity_token) {
      return c.json({ success: false, error: 'identity_token is required' }, 400);
    }

    // Decode Apple JWT (without verification for now)
    const decoded = jose.decodeJwt(identity_token);
    const apple_user_id = decoded.sub as string;
    const email = decoded.email as string;

    if (!apple_user_id || !email) {
      return c.json({ success: false, error: 'Invalid Apple identity token' }, 400);
    }

    // Check if user exists by apple_user_id
    let user = await c.env.DB.prepare(
      `SELECT id, email, username, display_name, avatar_key, paypal_email,
              subscription_tier, role, is_banned, created_at
       FROM users
       WHERE apple_user_id = ?`
    )
      .bind(apple_user_id)
      .first<UserRow>();

    let isNewUser = false;

    if (!user) {
      // New Apple user - create account
      isNewUser = true;
      const userId = generateId();
      const username = email.split('@')[0].replace(/[^a-zA-Z0-9_]/g, '_').substring(0, 30);
      const timestamp = now();

      // Insert user
      await c.env.DB.prepare(
        `INSERT INTO users (
          id, email, username, apple_user_id,
          subscription_tier, role, is_banned, email_verified, phone_verified,
          created_at, updated_at
        ) VALUES (?, ?, ?, ?, 'free', 'user', 0, 1, 0, ?, ?)`
      )
        .bind(userId, email.toLowerCase(), username, apple_user_id, timestamp, timestamp)
        .run();

      // Create initial portfolio with $25K
      const portfolioId = generateId();
      await c.env.DB.prepare(
        `INSERT INTO portfolios (
          id, user_id, cash_balance, total_equity, is_active, created_at, updated_at
        ) VALUES (?, ?, 25000, 25000, 1, ?, ?)`
      )
        .bind(portfolioId, userId, timestamp, timestamp)
        .run();

      // Fetch the created user
      user = await c.env.DB.prepare(
        `SELECT id, email, username, display_name, avatar_key, paypal_email,
                subscription_tier, role, is_banned, created_at
         FROM users
         WHERE id = ?`
      )
        .bind(userId)
        .first<UserRow>();

      if (!user) {
        return c.json({ success: false, error: 'User creation failed' }, 500);
      }
    }

    // Check if user is banned
    if (user.is_banned) {
      return c.json({ success: false, error: 'Account is banned' }, 403);
    }

    // Generate tokens
    const tokens = await generateTokens(
      {
        id: user.id,
        email: user.email,
        username: user.username,
        role: user.role,
        subscription_tier: user.subscription_tier,
      },
      c.env
    );

    // Store refresh token hash
    const refreshTokenHash = await sha256(tokens.refresh_token);
    await c.env.DB.prepare(
      `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, created_at)
       VALUES (?, ?, ?, datetime('now', '+30 days'), ?)`
    )
      .bind(generateId(), user.id, refreshTokenHash, now())
      .run();

    // Build user profile
    const userProfile = {
      id: user.id,
      email: user.email,
      username: user.username,
      display_name: user.display_name,
      avatar_url: user.avatar_key ? `/api/storage/${user.avatar_key}` : null,
      paypal_email: user.paypal_email,
      subscription_tier: user.subscription_tier,
      created_at: user.created_at,
    };

    return c.json(
      {
        success: true,
        data: {
          user: userProfile,
          tokens: {
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token,
            expires_in: tokens.expires_in,
            token_type: 'Bearer' as const,
          },
          is_new_user: isNewUser,
        },
      },
      isNewUser ? 201 : 200
    );
  } catch (err) {
    console.error('Apple auth error:', err);
    return c.json({ success: false, error: 'Apple authentication failed' }, 500);
  }
});

// ============================================================
// POST /refresh - Refresh access token
// ============================================================
authRoutes.post('/refresh', async (c) => {
  try {
    const body = await c.req.json<{ refresh_token: string }>();
    const { refresh_token } = body;

    if (!refresh_token) {
      return c.json({ success: false, error: 'refresh_token is required' }, 400);
    }

    // Verify refresh token
    const refreshSecret = new TextEncoder().encode(c.env.JWT_REFRESH_SECRET || c.env.JWT_SECRET);
    let userId: string;

    try {
      const { payload } = await jose.jwtVerify(refresh_token, refreshSecret, {
        algorithms: ['HS256'],
      });
      userId = payload.sub as string;
    } catch (err) {
      return c.json({ success: false, error: 'Invalid or expired refresh token' }, 401);
    }

    // Check if refresh token hash exists in DB
    const tokenHash = await sha256(refresh_token);
    const storedToken = await c.env.DB.prepare(
      'SELECT id FROM refresh_tokens WHERE token_hash = ? AND user_id = ? AND expires_at > datetime("now")'
    )
      .bind(tokenHash, userId)
      .first();

    if (!storedToken) {
      return c.json({ success: false, error: 'Invalid or expired refresh token' }, 401);
    }

    // Delete old refresh token
    await c.env.DB.prepare('DELETE FROM refresh_tokens WHERE token_hash = ?').bind(tokenHash).run();

    // Get user info
    const user = await c.env.DB.prepare(
      'SELECT id, email, username, role, subscription_tier FROM users WHERE id = ?'
    )
      .bind(userId)
      .first<{ id: string; email: string; username: string; role: string; subscription_tier: string }>();

    if (!user) {
      return c.json({ success: false, error: 'User not found' }, 404);
    }

    // Generate new tokens
    const tokens = await generateTokens(user, c.env);

    // Store new refresh token hash
    const newTokenHash = await sha256(tokens.refresh_token);
    await c.env.DB.prepare(
      `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, created_at)
       VALUES (?, ?, ?, datetime('now', '+30 days'), ?)`
    )
      .bind(generateId(), userId, newTokenHash, now())
      .run();

    return c.json({
      success: true,
      data: {
        access_token: tokens.access_token,
        refresh_token: tokens.refresh_token,
        expires_in: tokens.expires_in,
        token_type: 'Bearer' as const,
      },
    });
  } catch (err) {
    console.error('Refresh token error:', err);
    return c.json({ success: false, error: 'Token refresh failed' }, 500);
  }
});

// ============================================================
// POST /forgot-password - Request password reset
// ============================================================
authRoutes.post('/forgot-password', authRateLimiter, async (c) => {
  try {
    const body = await c.req.json<{ email: string }>();
    const { email } = body;

    if (!email || !isValidEmail(email)) {
      return c.json({ success: false, error: 'Valid email is required' }, 400);
    }

    // Find user
    const user = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?')
      .bind(email.toLowerCase())
      .first<{ id: string }>();

    if (user) {
      // Generate 6-digit code
      const code = Math.floor(100000 + Math.random() * 900000).toString();

      // Store code in KV with 15min TTL
      await c.env.CACHE.put(`reset:${email.toLowerCase()}`, code, { expirationTtl: 900 });

      // Queue email task
      await c.env.TASK_QUEUE.send({
        type: 'send_email',
        payload: {
          to: email.toLowerCase(),
          subject: 'Password Reset Code',
          text: `Your password reset code is: ${code}. This code expires in 15 minutes.`,
          html: `<p>Your password reset code is: <strong>${code}</strong></p><p>This code expires in 15 minutes.</p>`,
        },
        created_at: now(),
      });
    }

    // Always return success to prevent email enumeration
    return c.json({
      success: true,
      message: 'If an account exists with that email, a reset code has been sent.',
    });
  } catch (err) {
    console.error('Forgot password error:', err);
    return c.json({ success: false, error: 'Request failed' }, 500);
  }
});

// ============================================================
// POST /reset-password - Reset password with code
// ============================================================
authRoutes.post('/reset-password', authRateLimiter, async (c) => {
  try {
    const body = await c.req.json<{ email: string; code: string; new_password: string }>();
    const { email, code, new_password } = body;

    if (!email || !code || !new_password) {
      return c.json({ success: false, error: 'Email, code, and new_password are required' }, 400);
    }

    if (!isValidEmail(email)) {
      return c.json({ success: false, error: 'Invalid email format' }, 400);
    }

    if (!isValidPassword(new_password)) {
      return c.json({ success: false, error: 'Password must be at least 8 characters with at least 1 letter and 1 number' }, 400);
    }

    // Verify code from KV
    const storedCode = await c.env.CACHE.get(`reset:${email.toLowerCase()}`);

    if (!storedCode || storedCode !== code) {
      return c.json({ success: false, error: 'Invalid or expired reset code' }, 400);
    }

    // Hash new password
    const password_hash = await bcrypt.hash(new_password, 10);

    // Update user password
    const result = await c.env.DB.prepare('UPDATE users SET password_hash = ?, updated_at = ? WHERE email = ?')
      .bind(password_hash, now(), email.toLowerCase())
      .run();

    if (!result.meta.changes || result.meta.changes === 0) {
      return c.json({ success: false, error: 'User not found' }, 404);
    }

    // Delete reset code from KV
    await c.env.CACHE.delete(`reset:${email.toLowerCase()}`);

    return c.json({
      success: true,
      message: 'Password reset successfully',
    });
  } catch (err) {
    console.error('Reset password error:', err);
    return c.json({ success: false, error: 'Password reset failed' }, 500);
  }
});

// ============================================================
// POST /logout - Logout (invalidate refresh token)
// ============================================================
authRoutes.post('/logout', async (c) => {
  try {
    const body = await c.req.json<{ refresh_token: string }>();
    const { refresh_token } = body;

    if (!refresh_token) {
      return c.json({ success: false, error: 'refresh_token is required' }, 400);
    }

    // Delete refresh token from DB
    const tokenHash = await sha256(refresh_token);
    await c.env.DB.prepare('DELETE FROM refresh_tokens WHERE token_hash = ?').bind(tokenHash).run();

    return c.json({
      success: true,
      message: 'Logged out successfully',
    });
  } catch (err) {
    console.error('Logout error:', err);
    return c.json({ success: false, error: 'Logout failed' }, 500);
  }
});

export { authRoutes };
