// ============================================================
// Cloudflare Bindings
// ============================================================

export interface Env {
  DB: D1Database;
  CACHE: KVNamespace;
  SESSIONS: KVNamespace;
  STORAGE: R2Bucket;
  TASK_QUEUE: Queue;

  // Environment variables
  ENVIRONMENT: string;
  APP_NAME: string;
  STARTING_BALANCE: string;
  CORS_ORIGIN: string;

  // Secrets (set via wrangler secret put)
  JWT_SECRET: string;
  JWT_REFRESH_SECRET: string;
  RESEND_API_KEY: string;
  TWILIO_ACCOUNT_SID: string;
  TWILIO_AUTH_TOKEN: string;
  TWILIO_FROM_NUMBER: string;
  STRIPE_SECRET_KEY: string;
  FINNHUB_API_KEY: string;
  FMP_API_KEY: string;
  ALPHA_VANTAGE_KEY: string;
  TWELVE_DATA_KEY: string;
  COINGECKO_DEMO_KEY: string;
  APPLE_TEAM_ID: string;
  APPLE_KEY_ID: string;
  APPLE_PRIVATE_KEY: string;
  APPLE_CLIENT_ID: string;
  APNS_KEY_ID: string;
  APNS_TEAM_ID: string;
  APNS_PRIVATE_KEY: string;
}

// ============================================================
// Database Row Types
// ============================================================

export interface UserRow {
  id: string;
  email: string;
  username: string;
  display_name: string | null;
  password_hash: string | null;
  apple_user_id: string | null;
  avatar_key: string | null;
  paypal_email: string | null;
  phone: string | null;
  phone_verified: number;
  email_verified: number;
  subscription_tier: 'free' | 'premium';
  subscription_expires_at: string | null;
  apple_original_transaction_id: string | null;
  role: 'user' | 'admin' | 'moderator';
  is_banned: number;
  ban_reason: string | null;
  created_at: string;
  updated_at: string;
}

export interface PortfolioRow {
  id: string;
  user_id: string;
  cash_balance: number;
  total_equity: number;
  is_active: number;
  competition_month: string | null;
  created_at: string;
  updated_at: string;
}

export interface PositionRow {
  id: string;
  portfolio_id: string;
  user_id: string;
  ticker: string;
  asset_type: AssetType;
  quantity: number;
  average_cost: number;
  current_price: number;
  market_value: number;
  unrealized_pnl: number;
  updated_at: string;
}

export interface TradeRow {
  id: string;
  portfolio_id: string;
  user_id: string;
  ticker: string;
  asset_type: AssetType;
  side: 'buy' | 'sell';
  quantity: number;
  price: number;
  total_value: number;
  order_type: 'market' | 'limit';
  status: 'filled' | 'cancelled';
  executed_at: string;
  created_at: string;
}

export interface PortfolioSnapshotRow {
  id: string;
  portfolio_id: string;
  user_id: string;
  snapshot_date: string;
  cash_balance: number;
  holdings_value: number;
  total_equity: number;
  daily_pnl: number;
  daily_pnl_pct: number;
  total_pnl: number;
  total_pnl_pct: number;
  created_at: string;
}

export interface CompetitionRow {
  id: string;
  type: 'daily' | 'weekly' | 'monthly' | 'quarterly' | 'semiannual';
  status: 'active' | 'calculating' | 'completed' | 'paid_out';
  start_date: string;
  end_date: string;
  total_prize_pool: number;
  participant_count: number;
  created_at: string;
}

export interface CompetitionEntryRow {
  id: string;
  competition_id: string;
  user_id: string;
  portfolio_id: string;
  starting_equity: number;
  ending_equity: number | null;
  growth_pct: number;
  rank: number | null;
  prize_amount: number;
  prize_status: 'none' | 'pending' | 'approved' | 'paid' | 'failed';
  created_at: string;
  updated_at: string;
}

export interface LeaderboardCacheRow {
  id: string;
  competition_id: string;
  user_id: string;
  rank: number;
  username: string;
  display_name: string | null;
  avatar_key: string | null;
  total_equity: number;
  growth_pct: number;
  subscription_tier: string;
  updated_at: string;
}

export interface ChatMessageRow {
  id: string;
  user_id: string;
  username: string;
  content: string | null;
  image_key: string | null;
  tickers: string | null;
  is_deleted: number;
  created_at: string;
}

export interface NotificationRow {
  id: string;
  user_id: string;
  type: NotificationType;
  title: string;
  body: string;
  amount: number | null;
  metadata: string | null;
  is_read: number;
  created_at: string;
}

export interface PayoutRow {
  id: string;
  user_id: string;
  competition_entry_id: string | null;
  amount: number;
  method: 'paypal' | 'stripe';
  paypal_email: string | null;
  stripe_transfer_id: string | null;
  status: 'pending' | 'approved' | 'processing' | 'completed' | 'failed';
  admin_approved_by: string | null;
  approved_at: string | null;
  processed_at: string | null;
  failure_reason: string | null;
  created_at: string;
}

export interface WatchlistRow {
  id: string;
  user_id: string;
  ticker: string;
  sort_order: number;
  notes: string | null;
  created_at: string;
}

export interface SavedScreenerRow {
  id: string;
  user_id: string;
  title: string;
  description: string | null;
  parameters: string;
  color: string;
  sort_order: number;
  is_prebuilt: number;
  usage_count: number;
  created_at: string;
}

// ============================================================
// Enums & Constants
// ============================================================

export type AssetType = 'stock' | 'crypto' | 'etf' | 'bond' | 'option' | 'future' | 'forex';

export type NotificationType =
  | 'prize_won'
  | 'rank_change'
  | 'competition_start'
  | 'competition_end'
  | 'withdrawal_processed'
  | 'monthly_reset'
  | 'system';

export type CompetitionPeriod = 'daily' | 'weekly' | 'monthly' | 'quarterly' | 'semiannual';

export type SubscriptionTier = 'free' | 'premium';

// ============================================================
// API Request/Response Types
// ============================================================

export interface RegisterRequest {
  email: string;
  username: string;
  password: string;
  display_name?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AppleAuthRequest {
  identity_token: string;
  authorization_code: string;
  full_name?: {
    given_name?: string;
    family_name?: string;
  };
}

export interface AuthTokens {
  access_token: string;
  refresh_token: string;
  expires_in: number;
  token_type: 'Bearer';
}

export interface TradeRequest {
  ticker: string;
  asset_type: AssetType;
  side: 'buy' | 'sell';
  quantity: number;
}

export interface UserProfile {
  id: string;
  email: string;
  username: string;
  display_name: string | null;
  avatar_url: string | null;
  paypal_email: string | null;
  subscription_tier: SubscriptionTier;
  created_at: string;
}

export interface PortfolioSummary {
  id: string;
  cash_balance: number;
  total_equity: number;
  holdings_value: number;
  total_pnl: number;
  total_pnl_pct: number;
  positions: PositionSummary[];
}

export interface PositionSummary {
  ticker: string;
  asset_type: AssetType;
  quantity: number;
  average_cost: number;
  current_price: number;
  market_value: number;
  unrealized_pnl: number;
  unrealized_pnl_pct: number;
}

export interface MarketQuote {
  ticker: string;
  company_name: string;
  asset_type: AssetType;
  current_price: number;
  previous_close: number;
  open_price: number;
  day_high: number;
  day_low: number;
  volume: number;
  market_cap: number | null;
  pe_ratio: number | null;
  dividend_yield: number | null;
  change_dollar: number;
  change_percent: number;
  updated_at: string;
}

export interface LeaderboardEntry {
  rank: number;
  username: string;
  display_name: string | null;
  avatar_url: string | null;
  total_equity: number;
  growth_pct: number;
  subscription_tier: SubscriptionTier;
}

export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    has_more: boolean;
  };
}

// ============================================================
// JWT Payload
// ============================================================

export interface JWTPayload {
  sub: string;       // user_id
  email: string;
  username: string;
  role: string;
  tier: SubscriptionTier;
  iat: number;
  exp: number;
}

// ============================================================
// Queue Messages
// ============================================================

export interface QueueMessage {
  type: QueueMessageType;
  payload: Record<string, unknown>;
  created_at: string;
}

export type QueueMessageType =
  | 'send_email'
  | 'send_push'
  | 'send_sms'
  | 'calculate_leaderboard'
  | 'process_payout'
  | 'snapshot_portfolios'
  | 'roll_competition';
