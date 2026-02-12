# Phase 2: Backend Infrastructure (Weeks 3-6)

**Status:** IN PROGRESS
**Duration:** Weeks 3-6

---

## 2.1 Cloudflare Project Setup
- [ ] 2.1.1 Create backend/ directory with project scaffold
- [ ] 2.1.2 Initialize package.json with dependencies (hono, jose, bcryptjs)
- [ ] 2.1.3 Create wrangler.toml with D1, KV, R2, Queue bindings
- [ ] 2.1.4 Create tsconfig.json for TypeScript
- [ ] 2.1.5 Create src/index.ts (main worker entry + Hono router)
- [ ] 2.1.6 Create directory structure (routes/, middleware/, services/, models/, utils/, migrations/)
- [ ] 2.1.7 Create CORS middleware
- [ ] 2.1.8 Create error handling middleware
- [ ] 2.1.9 Create health check endpoint
- [ ] 2.1.10 Verify dry-run deploy: `wrangler deploy --dry-run`
- [ ] 2.1.11 **COMMIT**: "feat: initialize Cloudflare Workers backend"

## 2.2 D1 Database Schema
- [ ] 2.2.1 Create migration 001_users_auth.sql (users, device_tokens, refresh_tokens)
- [ ] 2.2.2 Create migration 002_portfolios_trading.sql (portfolios, positions, trades, portfolio_snapshots)
- [ ] 2.2.3 Create migration 003_competitions.sql (competitions, competition_entries, leaderboard_cache)
- [ ] 2.2.4 Create migration 004_social_notifications.sql (chat_messages, notifications, payouts, purchases)
- [ ] 2.2.5 Create migration 005_user_data.sql (watchlist, saved_screeners, user_preferences, monthly_resets)
- [ ] 2.2.6 Create migration 006_market_data.sql (market_quotes, market_history, market_news)
- [ ] 2.2.7 All tables with proper indexes
- [ ] 2.2.8 **COMMIT**: "feat: create D1 database schema with migrations"

## 2.3 Authentication System
- [ ] 2.3.1 Create POST /auth/register endpoint (email, username, password)
- [ ] 2.3.2 Implement bcrypt password hashing
- [ ] 2.3.3 Create POST /auth/login endpoint (email + password)
- [ ] 2.3.4 Implement JWT generation (access token + refresh token)
- [ ] 2.3.5 Create POST /auth/apple endpoint (Sign in with Apple server validation)
- [ ] 2.3.6 Create POST /auth/refresh endpoint (refresh token rotation)
- [ ] 2.3.7 Create auth middleware (JWT validation on protected routes)
- [ ] 2.3.8 Create POST /auth/forgot-password endpoint
- [ ] 2.3.9 Implement password reset email via Resend
- [ ] 2.3.10 Create POST /auth/reset-password endpoint
- [ ] 2.3.11 Session storage in KV (token -> user mapping)
- [ ] 2.3.12 Rate limiting: 5 login attempts per minute per IP
- [ ] 2.3.13 Test all auth flows
- [ ] 2.3.14 **COMMIT**: "feat: implement authentication system"

## 2.4 User Management API
- [ ] 2.4.1 Create GET /users/me endpoint (current user profile)
- [ ] 2.4.2 Create PUT /users/me endpoint (update profile)
- [ ] 2.4.3 Create POST /users/me/avatar endpoint (upload to R2)
- [ ] 2.4.4 Create DELETE /users/me endpoint (account deletion, GDPR)
- [ ] 2.4.5 Create GET /users/:id/public endpoint (public profile for leaderboard)
- [ ] 2.4.6 **COMMIT**: "feat: implement user management API"

## 2.5 Portfolio & Trading API
- [ ] 2.5.1 Create POST /portfolios endpoint (create portfolio with $25K)
- [ ] 2.5.2 Create GET /portfolios/:id endpoint (portfolio details, positions, P/L)
- [ ] 2.5.3 Create GET /portfolios/:id/positions endpoint (all positions)
- [ ] 2.5.4 Create GET /portfolios/:id/transactions endpoint (transaction history)
- [ ] 2.5.5 Create GET /portfolios/:id/performance endpoint (performance over time)
- [ ] 2.5.6 Create POST /portfolios/:id/trade endpoint (buy/sell)
  - Validate: sufficient balance (buy), sufficient shares (sell)
  - Support: stocks, crypto, ETFs, bonds, options, futures, forex
  - Create transaction record
  - Update position
  - Update cash balance
- [ ] 2.5.7 Create GET /portfolios/:id/holdings endpoint (current holdings with live prices)
- [ ] 2.5.8 **COMMIT**: "feat: implement portfolio and trading API"

## 2.6 Market Data Service
- [ ] 2.6.1 Create market data router /market/*
- [ ] 2.6.2 Implement Yahoo Finance client (yahoo-finance2 npm -- primary, ~70% of data needs)
- [ ] 2.6.3 Implement Finnhub client (60 req/min -- news, calendar, international stocks backup)
- [ ] 2.6.4 Implement CoinGecko client (13K+ crypto, 30 req/min with demo key)
- [ ] 2.6.5 Implement FRED client (120 req/min -- economic data, treasury yields)
- [ ] 2.6.6 Implement FMP client (250 req/day -- financials, ratios, screener)
- [ ] 2.6.7 Implement Binance WebSocket client (unlimited -- crypto streaming)
- [ ] 2.6.8 Implement SEC EDGAR client (free -- US filings, XBRL)
- [ ] 2.6.9 Implement US Treasury API client (free -- yields, auctions)
- [ ] 2.6.10 Create unified MarketDataService with fallback chains:
  - Stock quote: Yahoo Finance -> Finnhub -> FMP
  - Crypto: CoinGecko -> Binance
  - Financials: FMP -> SEC EDGAR -> Yahoo Finance
  - News: Finnhub -> FMP
  - Forex: Yahoo Finance -> Twelve Data
  - Bonds: FRED + US Treasury -> Yahoo Finance
  - Economic: FRED -> ECB
- [ ] 2.6.11 Create KV caching layer:
  - Quote cache: 15-minute TTL
  - Fundamentals cache: 24-hour TTL
  - News cache: 1-hour TTL
  - Company info cache: 7-day TTL
  - Chart data cache: varies by timeframe
- [ ] 2.6.12 Create GET /market/search?q=AAPL endpoint (universal search)
- [ ] 2.6.13 Create GET /market/quote/:symbol endpoint
- [ ] 2.6.14 Create GET /market/chart/:symbol?range=1D endpoint
- [ ] 2.6.15 Create GET /market/fundamentals/:symbol endpoint
- [ ] 2.6.16 Create GET /market/news?symbol=AAPL endpoint
- [ ] 2.6.17 Create GET /market/screener endpoint (with filter params)
- [ ] 2.6.18 Create GET /market/exchanges endpoint (list of supported exchanges)
- [ ] 2.6.19 Create GET /market/crypto endpoint (top coins list)
- [ ] 2.6.20 Rate limit tracking per API provider
- [ ] 2.6.21 **COMMIT**: "feat: implement multi-source market data service"

## 2.7 Competition Engine
- [ ] 2.7.1 Create competition service with lifecycle management
- [ ] 2.7.2 Create scheduled Worker (cron) for competition management
- [ ] 2.7.3 Create ranking calculation (sort by growth %, handle ties)
- [ ] 2.7.4 Create leaderboard snapshot generation (every 5 min via cron)
- [ ] 2.7.5 Create prize distribution logic per tier
- [ ] 2.7.6 Create monthly reset handler
- [ ] 2.7.7 Create GET /competitions/current endpoint
- [ ] 2.7.8 Create GET /competitions/history endpoint
- [ ] 2.7.9 Create GET /leaderboard?period=daily&tab=subscribed endpoint
- [ ] 2.7.10 Create GET /leaderboard/me endpoint (user's position)
- [ ] 2.7.11 Create GET /leaderboard/history endpoint (my past positions)
- [ ] 2.7.12 Create POST /competitions/reset endpoint (user's reset choice)
- [ ] 2.7.13 **COMMIT**: "feat: implement competition engine and leaderboard"

## 2.8 Chat Service
- [ ] 2.8.1 Create Durable Object for chat rooms
- [ ] 2.8.2 Implement WebSocket connection handling
- [ ] 2.8.3 Message persistence in D1
- [ ] 2.8.4 Ticker extraction from messages (regex for $AAPL or standalone AAPL)
- [ ] 2.8.5 Image upload handling (R2)
- [ ] 2.8.6 3-month message retention (cron cleanup)
- [ ] 2.8.7 Premium-only access gate
- [ ] 2.8.8 Create GET /chat/messages endpoint (paginated, filterable by ticker)
- [ ] 2.8.9 Create POST /chat/messages endpoint (HTTP fallback)
- [ ] 2.8.10 Create POST /chat/messages/:id/report endpoint
- [ ] 2.8.11 **COMMIT**: "feat: implement chat service with Durable Objects"

## 2.9 Notification Service
- [ ] 2.9.1 Implement APNs integration (p8 key, HTTP/2)
- [ ] 2.9.2 Create POST /devices endpoint (register device token)
- [ ] 2.9.3 Create notification dispatch service
- [ ] 2.9.4 Create GET /notifications endpoint (in-app feed)
- [ ] 2.9.5 Create PUT /notifications/:id/read endpoint
- [ ] 2.9.6 Create PUT /notifications/read-all endpoint
- [ ] 2.9.7 Notification triggers: competition start/end, rank change, prize won, payout, monthly reset
- [ ] 2.9.8 **COMMIT**: "feat: implement notification service"
- [ ] 2.9.9 **PUSH all Phase 2 commits**
