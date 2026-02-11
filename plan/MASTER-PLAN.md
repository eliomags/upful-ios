# UPFUL/JYANIK - Master Implementation Plan

**Created:** February 11, 2026
**Repository:** https://github.com/eliomags/upful-ios.git
**Current Branch:** `prod`
**Working Branch:** `feature/jyanik-rebuild`

---

## Executive Summary

Transform the Upful paper trading iOS app (built 2019, Swift 5/UIKit/CoreData) into **Jyanik** — a gamified stock trading competition platform where users compete with $25K virtual money to win real cash prizes. The app will support ALL global stock exchanges, crypto, ETFs, bonds, options, futures, and forex.

### Key Decisions (Confirmed by Research)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Swift Version** | Swift 6.1 (Xcode 16.3) | Latest stable; strict concurrency from day one; typed throws; full Sendable enforcement |
| **Xcode** | 16.3 (requires macOS 15 Sequoia) | Current user has 15.4 — **upgrade required before Phase 1** |
| **Min Deployment** | iOS 17.0 | Covers 90-95% of iPhones; unlocks SwiftData, @Observable, StoreKit views, #Preview |
| **UI Framework** | SwiftUI (100% new screens) | Production-ready in 2026; all Upful screens (lists, charts, forms, tabs, search) are ideal SwiftUI use cases |
| **Data Layer** | SwiftData | Production-ready since iOS 17; cleaner than CoreData; auto-migration |
| **Networking** | URLSession async/await | No third-party dependency needed; native Swift concurrency |
| **Architecture** | MVVM + Router + @Observable | Community standard; testable; @Observable replaces ObservableObject with fine-grained updates |
| **Backend** | Cloudflare Workers + D1 + KV + R2 + Durable Objects + Queues | Cost-effective serverless; global edge deployment; no server management |
| **Package Manager** | Swift Package Manager (SPM) | Industry standard; CocoaPods is legacy |
| **Charts** | Swift Charts (native, iOS 16+) | No third-party dep; SwiftUI-native; supports candlestick, line, area, donut |
| **Auth** | Sign in with Apple + email/password (custom JWT via jose) | Apple requirement for social login; custom gives us control |
| **Payments** | StoreKit 2 (subscriptions/IAP) + Stripe Connect (payouts) | Native Apple payments; Stripe for prize distribution |
| **Market Data** | 14-API aggregation: Yahoo Finance (primary, ~70% of needs) + Finnhub (60 req/min, news) + CoinGecko (13K+ crypto) + FRED (economic) + FMP (250 req/day, fundamentals) + Binance (crypto streaming) + SEC EDGAR (filings) + US Treasury (bonds) + Alpha Vantage (25 req/day, tech indicators) + Twelve Data (forex) + Quandl (futures) + ECB (EUR rates) + ExchangeRate-API (conversion) + OpenFIGI (ID mapping) | COMPLETE coverage for US/international stocks, crypto, ETFs, forex; GOOD for options, bonds; MODERATE for futures |
| **Email** | Resend | Modern, developer-friendly, good free tier |
| **SMS** | Twilio | Industry standard; reliable delivery |
| **Chat** | Cloudflare Durable Objects + WebSocket | No third-party chat service; we control the data |
| **Push Notifications** | APNs via Cloudflare Worker (p8 key, HTTP/2) | Direct APNs integration; no Firebase dependency |
| **Backend Router** | Hono (lightweight, Cloudflare-native) | Fast, TypeScript-first, perfect for Workers |
| **Backend Auth** | jose (JWT) + bcryptjs (passwords) | Standard, well-maintained, Workers-compatible |

> **IMPORTANT**: User must upgrade to Xcode 16.3 + macOS 15 Sequoia before starting Phase 1.
> Current setup: Xcode 15.4 / Swift 5.10 — cannot build Swift 6.1 / iOS 17 targets.

---

## Phase Overview

| Phase | Name | Duration | Focus |
|-------|------|----------|-------|
| **0** | Research & Planning | Week 0 (now) | Technology research, API evaluation, architecture design |
| **1** | Project Foundation | Weeks 1-2 | Repo cleanup, new project structure, SPM, CI/CD, .gitignore |
| **2** | Backend Infrastructure | Weeks 3-6 | Cloudflare Workers, D1 schema, auth, market data service |
| **3** | iOS App Modernization | Weeks 7-10 | SwiftUI migration, SwiftData, new architecture, StoreKit 2 |
| **4** | Core New Features | Weeks 11-16 | Leaderboard, competitions, chat, notifications, profiles |
| **5** | Market Data & Trading | Weeks 17-20 | Multi-API aggregation, global exchanges, crypto, all asset types |
| **6** | Monetization & Payouts | Weeks 21-23 | Subscription redesign, IAP, Stripe payouts, free vs paid |
| **7** | Polish & Launch | Weeks 24-28 | Testing, accessibility, performance, App Store submission |

---

## Phase 0: Research & Planning (Current)

### Tasks
- [x] Deep analyze existing codebase (research/01-04)
- [x] Create comprehensive app analysis (docs/app-analysis.md)
- [x] Research latest tech stack — Swift 6.1, Xcode 16.3, SwiftUI, SwiftData, iOS 17.0 (research/05 — 1,379 lines)
- [x] Research free financial APIs — 24 APIs evaluated, 14 recommended (research/06 — 1,765 lines)
- [x] Design backend architecture — Complete Cloudflare ecosystem design (research/07 — 2,548 lines)
- [x] Analyze all git branches — 7 branches analyzed, 4 stale (research/08 — 662 lines)
- [x] Finalize this master plan (refined with research findings)
- [x] Create detailed task checklist (plan/TASKS.md — 301 tasks)
- [ ] Create branch, commit, push

---

## Phase 1: Project Foundation (Weeks 1-2)

### Goal
Clean up the existing codebase, establish modern project structure, and set up development infrastructure.

### 1.1 Repository Cleanup
- [ ] Remove duplicate files (CompanyCalculations.swift = IntrinioLookup.swift)
- [ ] Remove "2" and "3" copy files from Stock Detail
- [ ] Remove corrupted BackgroundRefreshManager.swift
- [ ] Remove orphaned TransactionLog.xcdatamodeld
- [ ] Rename "New Group" folder to "StockTrade"
- [ ] Fix VersionManager naming (ColorManager.swift)
- [ ] Move misplaced test file from Extensions to UpfulTests
- [ ] Remove all hardcoded API keys from source code
- [ ] Create .env.example with placeholder keys
- [ ] Update .gitignore (add secrets, build artifacts, .env)

### 1.2 Project Structure
- [ ] Create new folder structure:
  ```
  Jyanik/
  ├── App/                    # App entry point, delegates
  ├── Core/                   # Shared models, protocols, extensions
  │   ├── Models/
  │   ├── Protocols/
  │   ├── Extensions/
  │   └── Utilities/
  ├── Features/               # Feature modules (MVVM)
  │   ├── Auth/
  │   ├── Home/
  │   ├── Portfolio/
  │   ├── Trading/
  │   ├── Leaderboard/
  │   ├── Chat/
  │   ├── Notifications/
  │   ├── Profile/
  │   ├── Screener/
  │   ├── StockDetail/
  │   ├── Search/
  │   ├── Saved/
  │   ├── Subscription/
  │   ├── Settings/
  │   └── Onboarding/
  ├── Services/               # Business logic services
  │   ├── API/
  │   ├── Auth/
  │   ├── Trading/
  │   ├── MarketData/
  │   ├── Competition/
  │   ├── Chat/
  │   ├── Notifications/
  │   └── Storage/
  ├── Design/                 # Design system
  │   ├── Colors/
  │   ├── Fonts/
  │   ├── Components/
  │   └── Theme/
  └── Resources/              # Assets, strings, configs
  ```

### 1.3 Dependency Migration (CocoaPods -> SPM)
- [ ] Remove Podfile, Podfile.lock, Pods/
- [ ] Remove .xcworkspace (switch to .xcodeproj with SPM)
- [ ] Add SPM dependencies:
  - swift-collections (Apple)
  - swift-algorithms (Apple)
  - KeychainAccess (kishikawakatsumi) - for secure storage
  - Nuke (kean) - image loading/caching
  - SwiftUI-Introspect (if UIKit bridging needed)
- [ ] Remove Charts pod (replace with Swift Charts)
- [ ] Remove SwiftyStoreKit (replace with StoreKit 2)
- [ ] Remove Firebase pods (replace with custom backend)
- [ ] Remove Mixpanel (consolidate analytics)

### 1.4 Development Infrastructure
- [ ] Set up SwiftLint via SPM plugin
- [ ] Create .swiftlint.yml with project rules
- [ ] Set up basic GitHub Actions CI:
  - Build on push to feature branches
  - Run tests
  - SwiftLint check
- [ ] Create branch protection rules for `prod`
- [ ] Set up Xcode project with proper signing, capabilities
- [ ] Minimum deployment target: iOS 17.0

### 1.5 Security Foundation
- [ ] Create Secrets.swift.template (git-tracked) + Secrets.swift (git-ignored)
- [ ] Set up Keychain storage for auth tokens
- [ ] Create config system for API endpoints (dev/staging/prod)
- [ ] Remove IAP shared secret from client code

**Commit & Push after Phase 1 completion**

---

## Phase 2: Backend Infrastructure (Weeks 3-6)

### Goal
Build the complete Cloudflare-based backend that powers the app.

### 2.1 Cloudflare Project Setup
- [ ] Create Cloudflare account/project
- [ ] Install Wrangler CLI
- [ ] Create Worker projects:
  - `jyanik-api` - Main REST API
  - `jyanik-market-data` - Market data aggregation/caching
  - `jyanik-chat` - WebSocket chat (Durable Objects)
  - `jyanik-cron` - Scheduled tasks (competition calc, leaderboard update)
- [ ] Create D1 database: `jyanik-db`
- [ ] Create KV namespaces: `MARKET_DATA`, `SESSIONS`, `CACHE`
- [ ] Create R2 bucket: `jyanik-assets` (avatars, images)
- [ ] Create Queue: `jyanik-tasks` (async processing)

### 2.2 D1 Database Schema
- [ ] Design and create all tables:
  - `users` - id, username, email, paypal_email, avatar_url, subscription_status, created_at
  - `user_profiles` - user_id, bio, experience_level, country, timezone
  - `portfolios` - id, user_id, competition_id, cash_balance, total_value, growth_percent
  - `positions` - id, portfolio_id, symbol, asset_type, shares, avg_price, current_price
  - `transactions` - id, portfolio_id, symbol, type (buy/sell), shares, price, total, timestamp
  - `competitions` - id, type (daily/weekly/monthly), start_date, end_date, status, prize_pool
  - `competition_entries` - id, competition_id, user_id, portfolio_id, starting_value, ending_value, rank
  - `leaderboard_snapshots` - id, competition_id, user_id, rank, value, growth_percent, calculated_at
  - `prizes` - id, competition_id, user_id, amount, status, payout_method
  - `chat_messages` - id, user_id, content, image_url, tickers, created_at
  - `notifications` - id, user_id, type, title, body, amount, is_read, created_at
  - `saved_stocks` - id, user_id, symbol, company_name, notes, sort_order
  - `saved_screeners` - id, user_id, title, description, parameters, sort_order
  - `preferences` - id, user_id, industries, growth, profitability, dividend
  - `subscriptions` - id, user_id, apple_transaction_id, status, plan, expires_at
  - `payouts` - id, user_id, amount, method, status, reference, processed_at
  - `market_cache` - symbol, data_type, data, fetched_at, expires_at
  - `user_devices` - id, user_id, device_token, platform, active
- [ ] Create indexes for all frequent query patterns
- [ ] Create migration system

### 2.3 Authentication System
- [ ] Implement Sign in with Apple flow (server-side validation)
- [ ] Implement email/password registration with bcrypt hashing
- [ ] JWT token generation and validation
- [ ] Refresh token rotation
- [ ] Session management via KV
- [ ] Password reset flow (Resend email)
- [ ] SMS verification via Twilio (optional, for payouts)
- [ ] Rate limiting on auth endpoints

### 2.4 Core API Endpoints
- [ ] User management: register, login, profile CRUD, avatar upload (R2)
- [ ] Portfolio management: create, get positions, get history, get performance
- [ ] Trading: buy, sell, get quote, validate order
- [ ] Screener: list prebuilt, create custom, run screen, save
- [ ] Saved items: save/unsave stocks, save/unsave screeners, reorder
- [ ] Search: company search, ticker lookup
- [ ] Settings: preferences, notification settings

### 2.5 Market Data Service (14-API Stack — from research/06)
- [ ] Create market data aggregation Worker
- [ ] **Tier 1 — Primary Sources:**
  - [ ] Yahoo Finance via yahoo-finance2 npm (US/intl stocks, ETFs, options, futures, forex, crypto — ~70% of all needs)
  - [ ] Finnhub (60 req/min — news, economic calendar, insider trading, international stocks backup)
  - [ ] CoinGecko (13,000+ crypto, 30 req/min with demo key)
  - [ ] FRED (800,000+ economic series, 120 req/min — macro data, treasury yields)
- [ ] **Tier 2 — Gap Fillers:**
  - [ ] FMP (250 req/day — financial statements, ratios, DCF, stock screener)
  - [ ] Binance API (unlimited crypto streaming via WebSocket)
  - [ ] SEC EDGAR (free, no rate limit — US filings, XBRL data)
  - [ ] US Treasury API (free — yields, auction results)
- [ ] **Tier 3 — Optional Enhancements:**
  - [ ] Alpha Vantage (25 req/day only — technical indicators, use sparingly)
  - [ ] Twelve Data (800 req/day — forex supplement)
  - [ ] Quandl/CHRIS (futures historical data)
  - [ ] ECB API (EUR exchange rates)
  - [ ] ExchangeRate-API (1,500 req/month — currency conversion)
  - [ ] OpenFIGI (identifier mapping between FIGI/ISIN/CUSIP/ticker)
- [ ] Cache strategy: KV with TTLs (quotes: 15min, fundamentals: 24h, news: 1h, company info: 7 days)
- [ ] Unified response format regardless of source API
- [ ] Fallback chains: Stock → Yahoo→Finnhub→FMP | Crypto → CoinGecko→Binance | Forex → Yahoo→TwelveData
- [ ] Symbol search across all asset types and exchanges
- [ ] Exchange information and trading hours

### 2.6 Competition Engine
- [ ] Competition lifecycle: create, start, calculate, end, distribute
- [ ] Daily competition: 24h cycles, auto-create via cron
- [ ] Weekly competition: Monday-Friday cycles
- [ ] Monthly competition: calendar month cycles
- [ ] Ranking calculation: sort by portfolio growth % over period
- [ ] Prize distribution logic per tier (from pitch deck structure)
- [ ] Monthly reset: new portfolio or keep, growth % resets
- [ ] Leaderboard snapshot generation (every 5 minutes via cron)
- [ ] Free vs. paid leaderboard separation

### 2.7 Notification Service
- [ ] APNs integration (p8 key auth)
- [ ] Push notification Worker
- [ ] Notification types: prize_won, rank_change, competition_start, competition_end, withdrawal
- [ ] In-app notification feed API
- [ ] Notification preferences per user
- [ ] Badge count management

### 2.8 Email & SMS
- [ ] Resend integration for transactional emails
- [ ] Email templates: welcome, password reset, prize notification, withdrawal confirmation
- [ ] Twilio integration for SMS verification
- [ ] SMS templates: verification code, payout confirmation

**Commit & Push after each sub-phase (2.1, 2.2, etc.)**

---

## Phase 3: iOS App Modernization (Weeks 7-10)

### Goal
Modernize the iOS app architecture, migrate to SwiftUI/SwiftData, establish design system.

### 3.1 App Entry Point
- [ ] Migrate from @UIApplicationMain to @main with App protocol
- [ ] Create JyanikApp.swift (SwiftUI App entry)
- [ ] Set up SwiftData ModelContainer
- [ ] Set up environment objects (AuthManager, ThemeManager)
- [ ] Implement app lifecycle handling
- [ ] Set up deep link handling

### 3.2 Design System
- [ ] Create Color tokens (from Figma: teal primary, whites, grays)
- [ ] Create Typography scale (SF Pro, semantic sizes)
- [ ] Create Spacing/layout tokens
- [ ] Create reusable SwiftUI components:
  - JButton (primary, secondary, text styles)
  - JTextField (styled input fields)
  - JCard (content cards)
  - JBadge (notification badges)
  - JAvatar (user avatar with fallback)
  - JLoadingView (skeleton/shimmer)
  - JEmptyState (empty state views)
  - JErrorView (error state views)
  - JTabBar (custom 5-tab bar matching Figma)

### 3.3 Networking Layer
- [ ] Create APIClient with async/await
- [ ] Request/Response types with Codable
- [ ] Authentication interceptor (JWT injection)
- [ ] Token refresh middleware
- [ ] Error handling with typed APIError enum
- [ ] Retry logic with exponential backoff
- [ ] Network connectivity monitoring
- [ ] Request logging for debug builds

### 3.4 SwiftData Models
- [ ] User model
- [ ] Portfolio model
- [ ] Position model
- [ ] Transaction model
- [ ] SavedStock model
- [ ] SavedScreener model
- [ ] Preference model
- [ ] Notification model (local cache)
- [ ] ChatMessage model (local cache)
- [ ] Configure ModelContainer with proper schema

### 3.5 Service Layer
- [ ] AuthService - login, register, token management, Keychain storage
- [ ] PortfolioService - positions, P/L calculation, performance history
- [ ] TradingService - buy, sell, order validation
- [ ] MarketDataService - quotes, charts, fundamentals, news, search
- [ ] CompetitionService - current competitions, rankings, history
- [ ] ChatService - WebSocket connection, message send/receive
- [ ] NotificationService - APNs registration, in-app feed
- [ ] StorageService - local persistence, cache management

### 3.6 Navigation Architecture
- [ ] Implement Router pattern for SwiftUI NavigationStack
- [ ] Define all app routes/destinations
- [ ] Tab-based navigation (5 tabs per Figma):
  - Home (house)
  - Search (magnifying glass)
  - Favorites (heart)
  - Leaderboard (chart)
  - Profile (person)
- [ ] Sheet/modal presentation management
- [ ] Deep link route mapping

### 3.7 Migrate Existing Screens (UIKit -> SwiftUI)
- [ ] Settings -> Profile/Settings (SwiftUI, new design)
- [ ] Preferences -> integrated into Profile
- [ ] Subscription -> Subscribe & Win (SwiftUI, new design)
- [ ] Recommendations/NPS -> simplified feedback in Settings

### 3.8 StoreKit 2 Integration
- [ ] Define products: monthly subscription, $2.99 virtual cash IAP
- [ ] Product display and purchase flow
- [ ] Transaction listener for real-time updates
- [ ] Subscription status monitoring
- [ ] Server-side receipt validation via Cloudflare Worker
- [ ] Restore purchases flow
- [ ] Grace period and billing retry handling

**Commit & Push after each sub-phase**

---

## Phase 4: Core New Features (Weeks 11-16)

### Goal
Build all the new features from the Figma designs and Features Guide.

### 4.1 Onboarding Flow
- [ ] Subscribe & Win - Step 1 (value proposition screen)
- [ ] Subscribe & Win - Step 2 (username, PayPal email registration)
- [ ] Thank You confirmation screen
- [ ] $25K Welcome / monthly reset choice screen
- [ ] First-time user flow orchestration

### 4.2 Home Screen (Enhanced Portfolio Dashboard)
- [ ] Rebuild in SwiftUI with new design
- [ ] Total balance, cash balance, P/L display
- [ ] Holdings list with live quotes
- [ ] Competition position badge (#26)
- [ ] Messages icon with unread count badge
- [ ] Notifications icon with badge
- [ ] See History link
- [ ] Equity Breakdown donut chart (Swift Charts)
- [ ] Stocks You May Like recommendations
- [ ] Pull-to-refresh
- [ ] Context menu on holdings (View, Trade, Sell All)

### 4.3 Leaderboard
- [ ] Leaderboard main screen (new)
- [ ] Time period tabs: Daily, Weekly, Monthly, Quarterly, 6-month
- [ ] Subscribed vs Free sub-tabs
- [ ] Top 100 user list with rank, avatar, username, growth %, portfolio value, prize
- [ ] Highlighted top 3 winners
- [ ] "Your Position" indicator
- [ ] Pull-to-refresh
- [ ] Portfolio growth line chart

### 4.4 My History
- [ ] History screen with past competition results (new)
- [ ] Same time period tabs as leaderboard
- [ ] Daily position entries with rank, %, dollar value
- [ ] Subscribed vs Free sub-tabs
- [ ] Performance trend visualization

### 4.5 Chat / Social Hub
- [ ] Chat main screen (new, premium only)
- [ ] WebSocket connection via Cloudflare Durable Objects
- [ ] Message list (text bubbles)
- [ ] Message input with send button
- [ ] Ticker-based filtering (filter by stock mentions)
- [ ] Photo attachments (R2 upload)
- [ ] 3-month message history
- [ ] Premium gate (show upgrade prompt for free users)
- [ ] Basic moderation (report message)

### 4.6 Notifications
- [ ] Notification feed screen (new)
- [ ] Prize notifications: "You won $X"
- [ ] Withdrawal notifications
- [ ] Time-filtered totals (Day, Week, Month)
- [ ] Free user version: "What you missed out on" upsell
- [ ] Mark as read
- [ ] Push notification handling

### 4.7 Profile
- [ ] Profile screen (new)
- [ ] Avatar upload (camera/library -> R2)
- [ ] Username and email editing
- [ ] PayPal email management
- [ ] Screener preferences
- [ ] Subscription status display
- [ ] Save Changes functionality

### 4.8 Out of Budget & Virtual Cash Purchase
- [ ] Budget monitor: trigger at $10K threshold
- [ ] Out of Budget modal overlay
- [ ] Buy $25K flow ($2.99 IAP via StoreKit 2)
- [ ] Balance top-up logic

### 4.9 Monthly Competition Reset
- [ ] Reset detection (competition end)
- [ ] Choice screen: "Build New Portfolio" vs "Keep Old Portfolio"
- [ ] Portfolio reset logic
- [ ] Growth percentage reset
- [ ] New competition entry creation

**Commit & Push after each feature (4.1, 4.2, etc.)**

---

## Phase 5: Market Data & Trading (Weeks 17-20)

### Goal
Implement comprehensive market data coverage and trading for ALL asset types.

### 5.1 Stock Trading (US & International)
- [ ] US exchanges: NYSE, NASDAQ, AMEX
- [ ] International: LSE, TSE, HKEX, SSE, TSX, XETR, BSE/NSE, ASX, Euronext, KRX
- [ ] Company search across all exchanges
- [ ] Stock detail view: price chart, financials, description, news
- [ ] Buy/sell flow for all stocks
- [ ] Position tracking with multi-currency support

### 5.2 Cryptocurrency Trading
- [ ] All major cryptocurrencies (BTC, ETH, SOL, ADA, DOT, etc.)
- [ ] All CoinGecko-listed tokens
- [ ] Crypto price charts
- [ ] Crypto market data (market cap, volume, supply)
- [ ] Buy/sell crypto with virtual money
- [ ] Fractional crypto purchases

### 5.3 ETF Trading
- [ ] All US ETFs (SPY, QQQ, VTI, etc.)
- [ ] International ETFs
- [ ] ETF holdings/composition data
- [ ] ETF performance charts
- [ ] Buy/sell flow

### 5.4 Bonds
- [ ] Government bonds (US Treasury, UK Gilts, etc.)
- [ ] Corporate bonds (where data available)
- [ ] Bond yields and pricing
- [ ] Include in portfolio tracking

### 5.5 Options
- [ ] Options chains for US stocks
- [ ] Call/put pricing
- [ ] Greeks display (delta, gamma, theta, vega)
- [ ] Options trading simulation (buy/sell options contracts)
- [ ] Options P/L tracking

### 5.6 Futures & Forex
- [ ] Commodity futures (gold, oil, etc.)
- [ ] Financial futures (S&P 500, etc.)
- [ ] Forex pairs (all major and minor)
- [ ] Futures/forex price charts
- [ ] Trading simulation

### 5.7 Screener Enhancement
- [ ] Rebuild screener with all asset types
- [ ] Additional screening criteria for new asset types
- [ ] Crypto screener (by market cap, volume, % change)
- [ ] ETF screener (by sector, expense ratio, yield)
- [ ] Save/share screener configurations

### 5.8 Stock Detail Enhancement
- [ ] Rebuild in SwiftUI
- [ ] Swift Charts for price charts (candlestick, line, area)
- [ ] Financials section (revenue, earnings, balance sheet)
- [ ] Key metrics (P/E, P/B, market cap, etc.)
- [ ] News section
- [ ] Company description
- [ ] Comparison tool
- [ ] Notes per stock

**Commit & Push after each sub-phase**

---

## Phase 6: Monetization & Payouts (Weeks 21-23)

### Goal
Implement the complete payment and prize distribution system.

### 6.1 Subscription System
- [ ] Subscribe & Win redesigned flow
- [ ] StoreKit 2 subscription management
- [ ] Free vs Premium feature gating
- [ ] Subscription status sync with backend
- [ ] Offer codes support
- [ ] Family sharing consideration

### 6.2 In-App Purchases
- [ ] $2.99 virtual cash purchase (consumable IAP)
- [ ] Purchase flow with StoreKit 2
- [ ] Server-side validation
- [ ] Balance update on successful purchase

### 6.3 Prize Payout System
- [ ] Stripe Connect integration on backend
- [ ] PayPal payout integration on backend
- [ ] Payout request flow in app
- [ ] Payout history screen
- [ ] Minimum payout threshold
- [ ] Payout status tracking (pending, processing, completed, failed)
- [ ] Email notification on payout (Resend)

### 6.4 Free vs Paid Experience
- [ ] Free tier: paper trading, basic screener, limited saves, view-only leaderboard
- [ ] Paid tier: competitions, prizes, chat, unlimited screener/saves, all time periods
- [ ] "What you missed" upsell messaging for free users
- [ ] Smooth upgrade flow from any gating point

**Commit & Push after each sub-phase**

---

## Phase 7: Polish & Launch (Weeks 24-28)

### Goal
Testing, performance, accessibility, and App Store submission.

### 7.1 Testing
- [ ] Unit tests for all ViewModels (minimum 70% coverage)
- [ ] Unit tests for all services
- [ ] Integration tests for API communication
- [ ] SwiftData model tests
- [ ] UI tests for critical flows (onboarding, trading, subscription)
- [ ] Backend Worker tests
- [ ] Load testing for leaderboard calculations
- [ ] Chat stress testing

### 7.2 Performance
- [ ] Profile with Instruments (Time Profiler, Allocations)
- [ ] Optimize list scrolling (lazy loading, prefetching)
- [ ] Image caching optimization
- [ ] API response caching strategy verification
- [ ] Memory leak detection and fixing
- [ ] App launch time optimization (<2 seconds)
- [ ] Background fetch for portfolio updates

### 7.3 Accessibility
- [ ] VoiceOver support for all screens
- [ ] Dynamic Type support
- [ ] Color contrast compliance
- [ ] Reduce Motion support
- [ ] Bold Text support
- [ ] Accessibility audit with Xcode Accessibility Inspector

### 7.4 Analytics
- [ ] Implement lightweight custom analytics (via Cloudflare Worker)
- [ ] Key events: screen views, trades, searches, subscription, competition entries
- [ ] No third-party analytics SDK (privacy-first)
- [ ] Analytics dashboard in admin panel

### 7.5 Legal & Compliance
- [ ] Terms of Service document
- [ ] Privacy Policy document
- [ ] Competition rules document
- [ ] Age verification (18+ for competitions)
- [ ] Data deletion capability (GDPR/CCPA)
- [ ] Export user data capability
- [ ] Cookie/tracking consent

### 7.6 App Store Submission
- [ ] App icons (all required sizes)
- [ ] Screenshots (6.7", 6.5", 5.5")
- [ ] App description and keywords
- [ ] App Store Connect configuration
- [ ] Review notes for Apple reviewers (competition = skill-based, not gambling)
- [ ] TestFlight beta distribution
- [ ] Production release

**Commit & Push after each sub-phase**

---

## Branching Strategy

```
prod (production)
  └── feature/jyanik-rebuild (main working branch)
       ├── phase1/cleanup
       ├── phase1/spm-migration
       ├── phase2/backend-setup
       ├── phase2/auth
       ├── phase2/market-data
       ├── phase2/competition-engine
       ├── phase3/app-modernization
       ├── phase3/design-system
       ├── phase3/networking
       ├── phase4/onboarding
       ├── phase4/leaderboard
       ├── phase4/chat
       ├── phase4/notifications
       ├── phase5/multi-asset
       ├── phase5/crypto
       ├── phase6/payments
       └── phase7/polish
```

Each phase branch merges back to `feature/jyanik-rebuild`. When ready for launch, merge to `prod`.

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Free API rate limits exceeded | High | Medium | Multiple API fallbacks; aggressive caching; Cloudflare KV |
| Apple rejects app (gambling concern) | Medium | High | Frame as skill-based competition; legal review; clear rules |
| Chat scalability issues | Medium | Medium | Cloudflare Durable Objects auto-scale; message retention limits |
| SwiftData migration bugs | Low | High | Comprehensive testing; incremental migration; fallback to CoreData |
| API providers deprecating free tiers | Medium | Medium | Multi-provider strategy; easy to swap providers via abstraction |
| Stripe payout compliance | Medium | High | Legal review early; KYC implementation; geographic restrictions |

---

## Success Metrics

| Metric | Target |
|--------|--------|
| App Store rating | 4.5+ stars |
| App launch time | <2 seconds |
| API response time | <500ms (p95) |
| Test coverage | >70% |
| Crash-free rate | >99.5% |
| Subscription conversion | >5% (from pitch deck) |
| Monthly active users (Year 1) | 2,000+ |

---

## Research Documents (COMPLETED)

All research agents have completed. These files serve as detailed reference throughout implementation:

| File | Lines | Size | Key Findings |
|------|-------|------|-------------|
| research/01-architecture-analysis.txt | 488 | 20KB | App architecture, APIs, 18+ issues identified |
| research/02-features-ui-analysis.txt | 674 | 27KB | All 15 feature modules documented |
| research/03-pdf-analysis.txt | 735 | 29KB | Features Guide + Pitch Deck analysis |
| research/04-trading-data-analysis.txt | 523 | 21KB | Trading engine, CoreData, extensions |
| research/05-tech-stack-research.txt | 1,379 | 55KB | Swift 6.1, Xcode 16.3, SwiftUI mature, SwiftData ready, iOS 17.0 target |
| research/06-financial-apis-research.txt | 1,765 | 69KB | 24 APIs evaluated → 14 recommended, COMPLETE coverage matrix |
| research/07-backend-architecture.txt | 2,548 | 96KB | Full Cloudflare architecture, D1 schema SQL, all API endpoints |
| research/08-branch-analysis.txt | 662 | 27KB | 7 branches analyzed, 4 stale → delete, pastPrices has reusable patterns |
| docs/app-analysis.md | 1,776 | 69KB | Comprehensive 3-part analysis (existing + modernization + new vision) |

### Key Takeaways from Research:
1. **Xcode upgrade required** — User has 15.4/Swift 5.10, needs 16.3/Swift 6.1 (requires macOS 15)
2. **Alpha Vantage severely limited** — Only 25 req/day now (was 500). Yahoo Finance is primary source
3. **Yahoo Finance handles ~70%** of data needs via yahoo-finance2 backend proxy
4. **pastPrices branch** has useful historical price fetching patterns worth referencing
5. **Two Next.js web branches** have TypeScript types and Zustand state management to reference
6. **4 branches to delete** — develop, feature-share-deeplinking, claude/rebuild-nextjs-mobile-first-5WiKP, claude/upful-web-only-5WiKP

---

*This plan is a living document. It will be updated as implementation progresses. Last refined: February 11, 2026.*
