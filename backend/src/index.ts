import { Hono } from 'hono';
import { logger } from 'hono/logger';
import { prettyJSON } from 'hono/pretty-json';
import type { Env } from './models/types';
import { corsMiddleware } from './middleware/cors';
import { errorHandler, notFoundHandler } from './middleware/error-handler';
import { apiRateLimiter } from './middleware/rate-limit';
import { authRoutes } from './routes/auth';
import { userRoutes } from './routes/users';
import { portfolioRoutes } from './routes/portfolios';
import { tradeRoutes } from './routes/trades';
import { marketRoutes } from './routes/market';
import { competitionRoutes } from './routes/competitions';
import { leaderboardRoutes } from './routes/leaderboard';
import { chatRoutes } from './routes/chat';
import { notificationRoutes } from './routes/notifications';
import { deviceRoutes } from './routes/devices';
import { watchlistRoutes } from './routes/watchlist';
import { screenerRoutes } from './routes/screeners';

// ============================================================
// Create Hono App
// ============================================================

const app = new Hono<{ Bindings: Env }>();

// ============================================================
// Global Middleware
// ============================================================

app.use('*', corsMiddleware);
app.use('*', logger());
app.use('*', prettyJSON());
app.use('/api/*', apiRateLimiter);

// ============================================================
// Health Check
// ============================================================

app.get('/', (c) => {
  return c.json({
    success: true,
    data: {
      name: 'Jyanik API',
      version: '0.1.0',
      environment: c.env.ENVIRONMENT,
      status: 'healthy',
    },
  });
});

app.get('/health', async (c) => {
  // Check D1 connectivity
  let dbStatus = 'unknown';
  try {
    await c.env.DB.prepare('SELECT 1').first();
    dbStatus = 'connected';
  } catch {
    dbStatus = 'error';
  }

  return c.json({
    success: true,
    data: {
      status: 'healthy',
      database: dbStatus,
      timestamp: new Date().toISOString(),
    },
  });
});

// ============================================================
// API Routes (v1)
// ============================================================

app.route('/api/v1/auth', authRoutes);
app.route('/api/v1/users', userRoutes);
app.route('/api/v1/portfolios', portfolioRoutes);
app.route('/api/v1/trade', tradeRoutes);
app.route('/api/v1/market', marketRoutes);
app.route('/api/v1/competitions', competitionRoutes);
app.route('/api/v1/leaderboard', leaderboardRoutes);
app.route('/api/v1/chat', chatRoutes);
app.route('/api/v1/notifications', notificationRoutes);
app.route('/api/v1/devices', deviceRoutes);
app.route('/api/v1/watchlist', watchlistRoutes);
app.route('/api/v1/screeners', screenerRoutes);

// ============================================================
// Error Handling
// ============================================================

app.onError(errorHandler);
app.notFound(notFoundHandler);

// ============================================================
// Queue Consumer
// ============================================================

export default {
  fetch: app.fetch,

  // Handle queued messages
  async queue(batch: MessageBatch, env: Env): Promise<void> {
    for (const message of batch.messages) {
      try {
        const data = message.body as { type: string; payload: Record<string, unknown> };
        console.log(`[QUEUE] Processing: ${data.type}`);

        switch (data.type) {
          case 'send_email':
            // TODO: Implement Resend email sending
            break;
          case 'send_push':
            // TODO: Implement APNs push notification
            break;
          case 'calculate_leaderboard':
            // TODO: Implement leaderboard calculation
            break;
          case 'process_payout':
            // TODO: Implement payout processing
            break;
          case 'snapshot_portfolios':
            // TODO: Implement portfolio snapshot
            break;
          default:
            console.warn(`[QUEUE] Unknown message type: ${data.type}`);
        }

        message.ack();
      } catch (err) {
        console.error(`[QUEUE] Error processing message:`, err);
        message.retry();
      }
    }
  },

  // Handle cron triggers
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    const trigger = event.cron;
    console.log(`[CRON] Triggered: ${trigger} at ${new Date().toISOString()}`);

    switch (trigger) {
      case '*/15 * * * *':
        // Every 15 min: refresh leaderboard rankings
        console.log('[CRON] Refreshing leaderboard...');
        // TODO: Implement leaderboard refresh
        break;

      case '0 * * * *':
        // Every hour: clean expired cache
        console.log('[CRON] Cleaning expired cache...');
        break;

      case '0 0 * * *':
        // Daily: roll daily competition
        console.log('[CRON] Rolling daily competition...');
        // TODO: Implement daily competition roll
        break;

      case '0 0 * * 1':
        // Monday: roll weekly competition
        console.log('[CRON] Rolling weekly competition...');
        break;

      case '0 0 1 * *':
        // 1st of month: roll monthly competition
        console.log('[CRON] Rolling monthly competition...');
        break;

      case '0 22 * * *':
        // 10pm UTC: snapshot portfolio values
        console.log('[CRON] Snapshotting portfolios...');
        // TODO: Implement portfolio snapshots
        break;

      default:
        console.warn(`[CRON] Unknown trigger: ${trigger}`);
    }
  },
};
