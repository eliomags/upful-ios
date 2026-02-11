# JYANIK - Detailed Task Checklist

**Status Key:** `[ ]` = Pending | `[~]` = In Progress | `[x]` = Complete | `[!]` = Blocked | `[-]` = Skipped

---

## Phase 0: Research & Planning

### 0.1 Existing Codebase Analysis
- [x] 0.1.1 Architecture analysis (research/01-architecture-analysis.txt)
- [x] 0.1.2 Features/UI analysis (research/02-features-ui-analysis.txt)
- [x] 0.1.3 PDF documents analysis (research/03-pdf-analysis.txt)
- [x] 0.1.4 Trading engine/data analysis (research/04-trading-data-analysis.txt)
- [x] 0.1.5 Comprehensive app analysis document (docs/app-analysis.md)

### 0.2 Technology Research
- [x] 0.2.1 Latest tech stack research (research/05-tech-stack-research.txt) — 1,379 lines, Swift 6.1/Xcode 16.3/iOS 17.0 confirmed
- [x] 0.2.2 Free financial APIs deep research (research/06-financial-apis-research.txt) — 1,765 lines, 24 APIs → 14 recommended
- [x] 0.2.3 Backend architecture design (research/07-backend-architecture.txt) — 2,548 lines, full Cloudflare architecture
- [x] 0.2.4 Git branch analysis (research/08-branch-analysis.txt) — 662 lines, 7 branches analyzed

### 0.3 Planning
- [x] 0.3.1 Create plan/ directory
- [x] 0.3.2 Create MASTER-PLAN.md
- [x] 0.3.3 Create TASKS.md (this file)
- [x] 0.3.4 Refine plan after research agents complete — updated API stack, confirmed versions, added research summary
- [x] 0.3.5 Create initial branch (feature/jyanik-rebuild) and push plan — 16 files, 12,097 lines committed

---

## Phase 1: Project Foundation (Weeks 1-2)

### 1.1 Repository Cleanup
- [x] 1.1.1 Create feature/jyanik-rebuild branch from prod
- [x] 1.1.2 Remove duplicate: Upful/Models/CompanyCalculations.swift (identical to IntrinioLookup.swift)
- [x] 1.1.3 Remove "2" and "3" copy files from Stock Detail feature (21 files removed)
- [x] 1.1.4 Remove corrupted BackgroundRefreshManager.swift (binary bookmark file)
- [x] 1.1.5 Remove orphaned TransactionLog.xcdatamodeld
- [x] 1.1.6 Rename "Upful/Features/New Group/" to "Upful/Features/StockTrade_Controllers/"
- [x] 1.1.7 Fix ColorManager.swift: rename VersionManager to ThemeManager (34+ files updated)
- [x] 1.1.8 Move SavedStocksViewModelTest.swift from Extensions/ to UpfulTests/
- [x] 1.1.9 Remove all hardcoded API keys from Constants.swift → now uses Secrets.swift
- [x] 1.1.10 Remove hardcoded IEX key from StockDescriptionLoader.swift URL
- [x] 1.1.11 Remove IAP shared secret from IAPService.swift → now uses Secrets.iapSharedSecret
- [x] 1.1.12 Remove Mixpanel token from Constants.swift → now uses Secrets.mixpanelToken
- [x] 1.1.13 Create Secrets.example.swift with placeholder values
- [x] 1.1.14 Update .gitignore: add Secrets.swift, .env, *.xcuserdata, DerivedData/, Pods/, large PDFs
- [-] 1.1.15 Remove stale hardcoded date ranges in API queries — SKIPPED: Intrinio API files will be entirely replaced in Phase 5
- [x] 1.1.16 Fix 12-hour time format bug (hh -> HH in Date.asString)
- [x] 1.1.17 Fix Double.twoDecimal() to actually use 2 decimals (was maximumFractionDigits=1)
- [x] 1.1.18 Fix typo: FirebaseAnayltics -> FirebaseAnalytics (in AnalyticsTrackers + AnalyticsMapper)
- [x] 1.1.19 Fix typo: sign_up_attempty -> sign_up_attempt
- [x] 1.1.20 Also: extracted hardcoded Intrinio key from StockScreeningService.swift
- [x] 1.1.21 Also: moved misplaced PersistedPerformanceDataPoint.swift from root to Upful/Models/
- [x] 1.1.22 **COMMIT**: "chore: cleanup codebase - remove duplicates, fix bugs, extract secrets" — 74 files, +191/-2,837 lines

### 1.2 Dependency Migration (CocoaPods -> SPM)
- [x] 1.2.1 Documented all Pod dependencies: SwiftyStoreKit, Firebase (Analytics/Core/Crashlytics/DynamicLinks/Firestore), Mixpanel-swift, Charts
- [x] 1.2.2 Removed Podfile, Podfile.lock from git tracking
- [x] 1.2.3 Removed Pods/ directory from git tracking (8,163 files, 163MB)
- [x] 1.2.4 Removed Upful.xcworkspace from git tracking, updated .gitignore
- [x] 1.2.5 Added SPM packages to Upful.xcodeproj:
  - Firebase SDK 11.0+ (Analytics, Core, Crashlytics, DynamicLinks, Firestore)
  - Mixpanel-swift 4.0+
  - SwiftyStoreKit 0.16+ (temporary, will be replaced by StoreKit 2)
  - DGCharts 5.0+ (temporary, will be replaced by Swift Charts)
  - Kept existing: Kingfisher, YSDraggy
- [x] 1.2.6 Updated all `import Charts` → `import DGCharts` across 7 files (SPM module name change)
- [x] 1.2.7 Cleaned all CocoaPods build phases and references from pbxproj (46 references removed)
- [~] 1.2.8 **COMMIT**: "chore: migrate from CocoaPods to SPM"

### 1.3 New Project Structure
- [ ] 1.3.1 Create Jyanik/ top-level directory (new app target or renamed)
- [ ] 1.3.2 Create folder structure:
  ```
  Jyanik/App/
  Jyanik/Core/Models/
  Jyanik/Core/Protocols/
  Jyanik/Core/Extensions/
  Jyanik/Core/Utilities/
  Jyanik/Features/ (one folder per feature)
  Jyanik/Services/
  Jyanik/Design/
  Jyanik/Resources/
  ```
- [ ] 1.3.3 Move existing extension files to Core/Extensions/
- [ ] 1.3.4 Move existing models to Core/Models/
- [ ] 1.3.5 Move trading engine to Services/Trading/
- [ ] 1.3.6 Move service files to Services/
- [ ] 1.3.7 Update all import paths / file references in .xcodeproj
- [ ] 1.3.8 Verify project builds with new structure
- [ ] 1.3.9 **COMMIT**: "refactor: reorganize project structure for Jyanik"

### 1.4 Development Infrastructure
- [ ] 1.4.1 Add SwiftLint SPM plugin
- [ ] 1.4.2 Create .swiftlint.yml with rules:
  - line_length: 120
  - force_unwrapping: error
  - force_cast: error
  - force_try: warning
  - trailing_whitespace: warning
  - unused_closure_parameter: warning
- [ ] 1.4.3 Fix all SwiftLint errors (or disable specific lines with justification)
- [ ] 1.4.4 Create .github/workflows/ci.yml:
  - Trigger: push to feature branches, PRs to prod
  - Jobs: build, test, swiftlint
  - Runner: macos-latest
- [ ] 1.4.5 Set minimum deployment target: iOS 17.0
- [ ] 1.4.6 Update project signing and capabilities
- [ ] 1.4.7 Add Push Notifications capability
- [ ] 1.4.8 Add Sign in with Apple capability
- [ ] 1.4.9 Add In-App Purchase capability
- [ ] 1.4.10 Add Background Modes capability (fetch, remote notifications)
- [ ] 1.4.11 **COMMIT**: "chore: add SwiftLint, CI/CD, update capabilities"

### 1.5 Security Foundation
- [ ] 1.5.1 Create Config.swift with environment enum (dev/staging/prod)
- [ ] 1.5.2 Create APIConfig.swift with base URLs per environment
- [ ] 1.5.3 Create KeychainService.swift using KeychainAccess for token storage
- [ ] 1.5.4 Ensure no secrets in any committed file
- [ ] 1.5.5 **COMMIT**: "feat: add security foundation - config, keychain, environments"
- [ ] 1.5.6 **PUSH all Phase 1 commits**

---

## Phase 2: Backend Infrastructure (Weeks 3-6)

### 2.1 Cloudflare Project Setup
- [ ] 2.1.1 Install Wrangler CLI: `npm install -g wrangler`
- [ ] 2.1.2 Create backend/ directory in repo
- [ ] 2.1.3 Initialize Wrangler project: `wrangler init jyanik-api`
- [ ] 2.1.4 Create wrangler.toml with:
  - D1 database binding
  - KV namespace bindings (MARKET_DATA, SESSIONS, CACHE)
  - R2 bucket binding (jyanik-assets)
  - Queue binding (jyanik-tasks)
  - Environment variables
- [ ] 2.1.5 Create D1 database: `wrangler d1 create jyanik-db`
- [ ] 2.1.6 Create KV namespaces: `wrangler kv:namespace create MARKET_DATA` etc.
- [ ] 2.1.7 Create R2 bucket: `wrangler r2 bucket create jyanik-assets`
- [ ] 2.1.8 Create Queue: `wrangler queues create jyanik-tasks`
- [ ] 2.1.9 Set up project structure:
  ```
  backend/
  ├── src/
  │   ├── index.ts          # Main worker entry, router
  │   ├── routes/            # API route handlers
  │   ├── middleware/         # Auth, CORS, rate limiting
  │   ├── services/          # Business logic
  │   ├── models/            # Type definitions
  │   ├── utils/             # Helpers
  │   └── migrations/        # D1 SQL migrations
  ├── wrangler.toml
  ├── package.json
  └── tsconfig.json
  ```
- [ ] 2.1.10 Install dependencies: hono (router), jose (JWT), bcryptjs
- [ ] 2.1.11 Verify worker deploys: `wrangler deploy --dry-run`
- [ ] 2.1.12 **COMMIT**: "feat: initialize Cloudflare Workers backend"

### 2.2 D1 Database Schema
- [ ] 2.2.1 Create migration 001_initial_schema.sql:
  - users table
  - portfolios table
  - positions table
  - transactions table
  - competitions table
  - competition_entries table
  - leaderboard_snapshots table
  - prizes table
  - saved_stocks table
  - saved_screeners table
  - preferences table
  - subscriptions table
  - All indexes
- [ ] 2.2.2 Create migration 002_chat.sql:
  - chat_messages table
  - chat_reports table
- [ ] 2.2.3 Create migration 003_notifications.sql:
  - notifications table
  - user_devices table
- [ ] 2.2.4 Create migration 004_payouts.sql:
  - payouts table
  - payout_methods table
- [ ] 2.2.5 Run migrations: `wrangler d1 migrations apply jyanik-db`
- [ ] 2.2.6 Verify schema: `wrangler d1 execute jyanik-db --command ".tables"`
- [ ] 2.2.7 **COMMIT**: "feat: create D1 database schema with migrations"

### 2.3 Authentication System
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

### 2.4 User Management API
- [ ] 2.4.1 Create GET /users/me endpoint (current user profile)
- [ ] 2.4.2 Create PUT /users/me endpoint (update profile)
- [ ] 2.4.3 Create POST /users/me/avatar endpoint (upload to R2)
- [ ] 2.4.4 Create DELETE /users/me endpoint (account deletion, GDPR)
- [ ] 2.4.5 Create GET /users/:id/public endpoint (public profile for leaderboard)
- [ ] 2.4.6 **COMMIT**: "feat: implement user management API"

### 2.5 Portfolio & Trading API
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

### 2.6 Market Data Service
- [ ] 2.6.1 Create market data router /market/*
- [ ] 2.6.2 Implement Yahoo Finance client (yahoo-finance2 npm — primary, ~70% of data needs)
- [ ] 2.6.3 Implement Finnhub client (60 req/min — news, calendar, international stocks backup)
- [ ] 2.6.4 Implement CoinGecko client (13K+ crypto, 30 req/min with demo key)
- [ ] 2.6.5 Implement FRED client (120 req/min — economic data, treasury yields)
- [ ] 2.6.6 Implement FMP client (250 req/day — financials, ratios, screener)
- [ ] 2.6.7 Implement Binance WebSocket client (unlimited — crypto streaming)
- [ ] 2.6.8 Implement SEC EDGAR client (free — US filings, XBRL)
- [ ] 2.6.9 Implement US Treasury API client (free — yields, auctions)
- [ ] 2.6.10 Create unified MarketDataService with fallback chains:
  - Stock quote: Yahoo Finance -> Finnhub -> FMP
  - Crypto: CoinGecko -> Binance
  - Financials: FMP -> SEC EDGAR -> Yahoo Finance
  - News: Finnhub -> FMP
  - Forex: Yahoo Finance -> Twelve Data
  - Bonds: FRED + US Treasury -> Yahoo Finance
  - Economic: FRED -> ECB
- [ ] 2.6.8 Create KV caching layer:
  - Quote cache: 15-minute TTL
  - Fundamentals cache: 24-hour TTL
  - News cache: 1-hour TTL
  - Company info cache: 7-day TTL
  - Chart data cache: varies by timeframe
- [ ] 2.6.9 Create GET /market/search?q=AAPL endpoint (universal search)
- [ ] 2.6.10 Create GET /market/quote/:symbol endpoint
- [ ] 2.6.11 Create GET /market/chart/:symbol?range=1D endpoint
- [ ] 2.6.12 Create GET /market/fundamentals/:symbol endpoint
- [ ] 2.6.13 Create GET /market/news?symbol=AAPL endpoint
- [ ] 2.6.14 Create GET /market/screener endpoint (with filter params)
- [ ] 2.6.15 Create GET /market/exchanges endpoint (list of supported exchanges)
- [ ] 2.6.16 Create GET /market/crypto endpoint (top coins list)
- [ ] 2.6.17 Rate limit tracking per API provider
- [ ] 2.6.18 **COMMIT**: "feat: implement multi-source market data service"

### 2.7 Competition Engine
- [ ] 2.7.1 Create competition service with lifecycle management
- [ ] 2.7.2 Create scheduled Worker (cron) for competition management:
  - Daily: create new competition at market open, close at market close
  - Weekly: Monday open to Friday close
  - Monthly: first day to last day of month
- [ ] 2.7.3 Create ranking calculation:
  - Calculate portfolio growth % for each participant
  - Sort by growth %, assign ranks
  - Handle ties
- [ ] 2.7.4 Create leaderboard snapshot generation (every 5 min via cron)
- [ ] 2.7.5 Create prize distribution logic per tier
- [ ] 2.7.6 Create monthly reset handler:
  - Archive current competition
  - Process prizes
  - Reset growth percentages
  - Handle user choice (new portfolio vs keep)
- [ ] 2.7.7 Create GET /competitions/current endpoint
- [ ] 2.7.8 Create GET /competitions/history endpoint
- [ ] 2.7.9 Create GET /leaderboard?period=daily&tab=subscribed endpoint
- [ ] 2.7.10 Create GET /leaderboard/me endpoint (user's position)
- [ ] 2.7.11 Create GET /leaderboard/history endpoint (my past positions)
- [ ] 2.7.12 Create POST /competitions/reset endpoint (user's reset choice)
- [ ] 2.7.13 **COMMIT**: "feat: implement competition engine and leaderboard"

### 2.8 Chat Service
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

### 2.9 Notification Service
- [ ] 2.9.1 Implement APNs integration (p8 key, HTTP/2)
- [ ] 2.9.2 Create POST /devices endpoint (register device token)
- [ ] 2.9.3 Create notification dispatch service
- [ ] 2.9.4 Create GET /notifications endpoint (in-app feed)
- [ ] 2.9.5 Create PUT /notifications/:id/read endpoint
- [ ] 2.9.6 Create PUT /notifications/read-all endpoint
- [ ] 2.9.7 Notification triggers:
  - Competition start/end
  - Rank change (moved into/out of top 100)
  - Prize won
  - Payout processed
  - Monthly reset reminder
- [ ] 2.9.8 **COMMIT**: "feat: implement notification service"
- [ ] 2.9.9 **PUSH all Phase 2 commits**

---

## Phase 3: iOS App Modernization (Weeks 7-10)

### 3.1 SwiftUI App Entry
- [ ] 3.1.1 Create JyanikApp.swift with @main and SwiftUI App protocol
- [ ] 3.1.2 Configure SwiftData ModelContainer
- [ ] 3.1.3 Create AppState observable class (auth state, user, subscription)
- [ ] 3.1.4 Create RootView with auth state routing (onboarding vs main)
- [ ] 3.1.5 Create MainTabView (5 tabs per Figma)
- [ ] 3.1.6 Set up environment objects in app entry
- [ ] 3.1.7 **COMMIT**: "feat: create SwiftUI app entry point"

### 3.2 Design System
- [ ] 3.2.1 Create Design/Theme/JColor.swift (teal primary, semantic colors)
- [ ] 3.2.2 Create Design/Theme/JFont.swift (typography scale)
- [ ] 3.2.3 Create Design/Theme/JSpacing.swift (spacing tokens)
- [ ] 3.2.4 Create Design/Components/JButton.swift (primary, secondary, text)
- [ ] 3.2.5 Create Design/Components/JTextField.swift (styled inputs)
- [ ] 3.2.6 Create Design/Components/JCard.swift (content cards)
- [ ] 3.2.7 Create Design/Components/JBadge.swift (notification badges)
- [ ] 3.2.8 Create Design/Components/JAvatar.swift (user avatars)
- [ ] 3.2.9 Create Design/Components/JLoadingView.swift (skeleton/shimmer)
- [ ] 3.2.10 Create Design/Components/JEmptyState.swift
- [ ] 3.2.11 Create Design/Components/JErrorView.swift
- [ ] 3.2.12 Create Design/Components/JTabBar.swift (custom 5-tab bar)
- [ ] 3.2.13 **COMMIT**: "feat: create design system components"

### 3.3 Networking Layer
- [ ] 3.3.1 Create Services/API/APIClient.swift (async/await, generic request)
- [ ] 3.3.2 Create Services/API/APIEndpoint.swift (protocol for typed endpoints)
- [ ] 3.3.3 Create Services/API/APIError.swift (typed error enum)
- [ ] 3.3.4 Create Services/API/AuthInterceptor.swift (JWT injection)
- [ ] 3.3.5 Create Services/API/TokenRefreshMiddleware.swift
- [ ] 3.3.6 Create Services/API/Endpoints/ (one file per domain)
  - AuthEndpoints.swift
  - UserEndpoints.swift
  - PortfolioEndpoints.swift
  - TradingEndpoints.swift
  - MarketEndpoints.swift
  - CompetitionEndpoints.swift
  - ChatEndpoints.swift
  - NotificationEndpoints.swift
- [ ] 3.3.7 Create NetworkMonitor.swift (NWPathMonitor wrapper)
- [ ] 3.3.8 **COMMIT**: "feat: create networking layer with async/await"

### 3.4 SwiftData Models
- [ ] 3.4.1 Create Core/Models/User.swift (@Model)
- [ ] 3.4.2 Create Core/Models/Portfolio.swift (@Model)
- [ ] 3.4.3 Create Core/Models/Position.swift (@Model)
- [ ] 3.4.4 Create Core/Models/Transaction.swift (@Model)
- [ ] 3.4.5 Create Core/Models/SavedStock.swift (@Model)
- [ ] 3.4.6 Create Core/Models/SavedScreener.swift (@Model)
- [ ] 3.4.7 Create Core/Models/Preference.swift (@Model)
- [ ] 3.4.8 Create Core/Models/CachedNotification.swift (@Model)
- [ ] 3.4.9 Create Core/Models/CachedChatMessage.swift (@Model)
- [ ] 3.4.10 Create Core/Models/MarketQuote.swift (Codable, not persisted)
- [ ] 3.4.11 Create Core/Models/ChartDataPoint.swift (Codable)
- [ ] 3.4.12 Create Core/Models/CompanyInfo.swift (Codable)
- [ ] 3.4.13 Create Core/Models/NewsArticle.swift (Codable)
- [ ] 3.4.14 **COMMIT**: "feat: create SwiftData models"

### 3.5 Service Layer
- [ ] 3.5.1 Create Services/Auth/AuthService.swift
- [ ] 3.5.2 Create Services/Auth/KeychainService.swift
- [ ] 3.5.3 Create Services/Auth/AppleSignInService.swift
- [ ] 3.5.4 Create Services/Portfolio/PortfolioService.swift
- [ ] 3.5.5 Create Services/Trading/TradingService.swift
- [ ] 3.5.6 Create Services/MarketData/MarketDataService.swift
- [ ] 3.5.7 Create Services/Competition/CompetitionService.swift
- [ ] 3.5.8 Create Services/Chat/ChatService.swift (WebSocket)
- [ ] 3.5.9 Create Services/Notifications/NotificationService.swift
- [ ] 3.5.10 Create Services/Storage/CacheService.swift
- [ ] 3.5.11 **COMMIT**: "feat: create service layer"

### 3.6 Navigation
- [ ] 3.6.1 Create Core/Navigation/AppRouter.swift
- [ ] 3.6.2 Create Core/Navigation/Route.swift (enum of all destinations)
- [ ] 3.6.3 Implement NavigationStack-based routing per tab
- [ ] 3.6.4 Implement sheet/fullScreenCover presentation
- [ ] 3.6.5 **COMMIT**: "feat: create navigation architecture"

### 3.7 StoreKit 2
- [ ] 3.7.1 Create Services/StoreKit/StoreKitService.swift
- [ ] 3.7.2 Define product IDs (monthly subscription, virtual cash IAP)
- [ ] 3.7.3 Implement product loading and display
- [ ] 3.7.4 Implement purchase flow
- [ ] 3.7.5 Implement Transaction.updates listener
- [ ] 3.7.6 Implement subscription status check
- [ ] 3.7.7 Implement restore purchases
- [ ] 3.7.8 Server-side receipt validation endpoint call
- [ ] 3.7.9 **COMMIT**: "feat: implement StoreKit 2 integration"
- [ ] 3.7.10 **PUSH all Phase 3 commits**

---

## Phase 4: Core New Features (Weeks 11-16)

### 4.1 Onboarding
- [ ] 4.1.1 Create Features/Onboarding/Views/SubscribeWinView.swift (Step 1)
- [ ] 4.1.2 Create Features/Onboarding/Views/RegisterView.swift (Step 2)
- [ ] 4.1.3 Create Features/Onboarding/Views/ThankYouView.swift
- [ ] 4.1.4 Create Features/Onboarding/Views/WelcomeView.swift ($25K)
- [ ] 4.1.5 Create Features/Onboarding/ViewModels/OnboardingViewModel.swift
- [ ] 4.1.6 Create Features/Auth/Views/LoginView.swift
- [ ] 4.1.7 Create Features/Auth/Views/ForgotPasswordView.swift
- [ ] 4.1.8 Create Features/Auth/ViewModels/AuthViewModel.swift
- [ ] 4.1.9 Implement Sign in with Apple button and flow
- [ ] 4.1.10 Test complete onboarding flow end-to-end
- [ ] 4.1.11 **COMMIT**: "feat: implement onboarding and auth screens"

### 4.2 Home Screen (Enhanced Portfolio)
- [ ] 4.2.1 Create Features/Home/Views/HomeView.swift
- [ ] 4.2.2 Create Features/Home/Views/PortfolioHeaderView.swift (balance, P/L)
- [ ] 4.2.3 Create Features/Home/Views/HoldingRowView.swift
- [ ] 4.2.4 Create Features/Home/Views/CompetitionBadgeView.swift (#26)
- [ ] 4.2.5 Create Features/Home/Views/EquityDonutChart.swift (Swift Charts)
- [ ] 4.2.6 Create Features/Home/Views/StockSuggestionRow.swift
- [ ] 4.2.7 Create Features/Home/ViewModels/HomeViewModel.swift
- [ ] 4.2.8 Implement pull-to-refresh
- [ ] 4.2.9 Implement context menu on holdings
- [ ] 4.2.10 Implement notification/chat icon badges in toolbar
- [ ] 4.2.11 Test home screen with mock data
- [ ] 4.2.12 **COMMIT**: "feat: implement enhanced home/portfolio screen"

### 4.3 Leaderboard
- [ ] 4.3.1 Create Features/Leaderboard/Views/LeaderboardView.swift
- [ ] 4.3.2 Create Features/Leaderboard/Views/LeaderboardRowView.swift
- [ ] 4.3.3 Create Features/Leaderboard/Views/TopThreeView.swift (highlighted top 3)
- [ ] 4.3.4 Create Features/Leaderboard/Views/TimePeriodPicker.swift
- [ ] 4.3.5 Create Features/Leaderboard/ViewModels/LeaderboardViewModel.swift
- [ ] 4.3.6 Implement tab switching (Subscribed / Free)
- [ ] 4.3.7 Implement time period filtering
- [ ] 4.3.8 Implement "Your Position" indicator
- [ ] 4.3.9 Implement pull-to-refresh
- [ ] 4.3.10 Test with mock leaderboard data
- [ ] 4.3.11 **COMMIT**: "feat: implement leaderboard"

### 4.4 My History
- [ ] 4.4.1 Create Features/Leaderboard/Views/MyHistoryView.swift
- [ ] 4.4.2 Create Features/Leaderboard/Views/HistoryDayRow.swift
- [ ] 4.4.3 Create Features/Leaderboard/ViewModels/HistoryViewModel.swift
- [ ] 4.4.4 Implement time period filtering
- [ ] 4.4.5 Implement Free/Subscribed tabs
- [ ] 4.4.6 **COMMIT**: "feat: implement my history"

### 4.5 Chat
- [ ] 4.5.1 Create Features/Chat/Views/ChatView.swift
- [ ] 4.5.2 Create Features/Chat/Views/ChatBubbleView.swift
- [ ] 4.5.3 Create Features/Chat/Views/ChatInputView.swift
- [ ] 4.5.4 Create Features/Chat/Views/TickerFilterView.swift
- [ ] 4.5.5 Create Features/Chat/ViewModels/ChatViewModel.swift
- [ ] 4.5.6 Implement WebSocket connection
- [ ] 4.5.7 Implement message sending/receiving
- [ ] 4.5.8 Implement image attachment (camera/library -> R2)
- [ ] 4.5.9 Implement ticker filtering
- [ ] 4.5.10 Implement premium gate for free users
- [ ] 4.5.11 Implement scroll to bottom / lazy loading
- [ ] 4.5.12 **COMMIT**: "feat: implement chat"

### 4.6 Notifications
- [ ] 4.6.1 Create Features/Notifications/Views/NotificationsView.swift
- [ ] 4.6.2 Create Features/Notifications/Views/NotificationRowView.swift
- [ ] 4.6.3 Create Features/Notifications/ViewModels/NotificationsViewModel.swift
- [ ] 4.6.4 Implement notification feed with time grouping
- [ ] 4.6.5 Implement time period totals
- [ ] 4.6.6 Implement "What you missed" for free users
- [ ] 4.6.7 Implement push notification handling
- [ ] 4.6.8 Implement mark as read
- [ ] 4.6.9 **COMMIT**: "feat: implement notifications"

### 4.7 Profile
- [ ] 4.7.1 Create Features/Profile/Views/ProfileView.swift
- [ ] 4.7.2 Create Features/Profile/Views/AvatarEditorView.swift
- [ ] 4.7.3 Create Features/Profile/Views/SettingsView.swift (within profile)
- [ ] 4.7.4 Create Features/Profile/ViewModels/ProfileViewModel.swift
- [ ] 4.7.5 Implement avatar upload
- [ ] 4.7.6 Implement profile editing
- [ ] 4.7.7 Implement subscription status display
- [ ] 4.7.8 Implement preference management
- [ ] 4.7.9 Implement account deletion
- [ ] 4.7.10 **COMMIT**: "feat: implement profile"

### 4.8 Out of Budget & Virtual Cash
- [ ] 4.8.1 Create Features/Trading/Views/OutOfBudgetView.swift (modal)
- [ ] 4.8.2 Create Features/Trading/Views/BuyVirtualCashView.swift
- [ ] 4.8.3 Implement balance monitoring ($10K threshold)
- [ ] 4.8.4 Implement $2.99 IAP purchase flow
- [ ] 4.8.5 Implement balance top-up after purchase
- [ ] 4.8.6 **COMMIT**: "feat: implement out of budget and virtual cash purchase"

### 4.9 Monthly Reset
- [ ] 4.9.1 Create Features/Competition/Views/MonthlyResetView.swift
- [ ] 4.9.2 Create Features/Competition/ViewModels/ResetViewModel.swift
- [ ] 4.9.3 Implement choice: "Build New Portfolio" vs "Keep Old Portfolio"
- [ ] 4.9.4 Implement portfolio reset logic
- [ ] 4.9.5 Implement growth % reset
- [ ] 4.9.6 **COMMIT**: "feat: implement monthly competition reset"
- [ ] 4.9.7 **PUSH all Phase 4 commits**

---

## Phase 5: Market Data & Trading (Weeks 17-20)

### 5.1 Search & Discovery
- [ ] 5.1.1 Create Features/Search/Views/SearchView.swift (universal search)
- [ ] 5.1.2 Create Features/Search/Views/SearchResultRow.swift
- [ ] 5.1.3 Create Features/Search/ViewModels/SearchViewModel.swift
- [ ] 5.1.4 Implement debounced search across stocks, crypto, ETFs, etc.
- [ ] 5.1.5 Implement asset type filtering
- [ ] 5.1.6 Implement recent searches
- [ ] 5.1.7 **COMMIT**: "feat: implement universal search"

### 5.2 Stock Detail (Rebuilt)
- [ ] 5.2.1 Create Features/StockDetail/Views/StockDetailView.swift
- [ ] 5.2.2 Create Features/StockDetail/Views/PriceChartView.swift (Swift Charts)
- [ ] 5.2.3 Create Features/StockDetail/Views/FinancialsView.swift
- [ ] 5.2.4 Create Features/StockDetail/Views/KeyMetricsView.swift
- [ ] 5.2.5 Create Features/StockDetail/Views/NewsListView.swift
- [ ] 5.2.6 Create Features/StockDetail/Views/CompanyDescriptionView.swift
- [ ] 5.2.7 Create Features/StockDetail/ViewModels/StockDetailViewModel.swift
- [ ] 5.2.8 Implement save/unsave
- [ ] 5.2.9 Implement trade button -> trading sheet
- [ ] 5.2.10 Implement compare button
- [ ] 5.2.11 **COMMIT**: "feat: rebuild stock detail in SwiftUI"

### 5.3 Trading Screen (Rebuilt)
- [ ] 5.3.1 Create Features/Trading/Views/TradeView.swift
- [ ] 5.3.2 Create Features/Trading/ViewModels/TradeViewModel.swift
- [ ] 5.3.3 Implement buy/sell with validation
- [ ] 5.3.4 Support all asset types (stocks, crypto, ETFs, etc.)
- [ ] 5.3.5 Support fractional shares for crypto
- [ ] 5.3.6 Implement trade confirmation
- [ ] 5.3.7 Implement success/error feedback
- [ ] 5.3.8 **COMMIT**: "feat: rebuild trading screen"

### 5.4 Screener (Rebuilt)
- [ ] 5.4.1 Create Features/Screener/Views/ScreenerView.swift
- [ ] 5.4.2 Create Features/Screener/Views/PrebuiltScreenerList.swift
- [ ] 5.4.3 Create Features/Screener/Views/CustomScreenerBuilder.swift
- [ ] 5.4.4 Create Features/Screener/Views/ScreenerResultsView.swift
- [ ] 5.4.5 Create Features/Screener/ViewModels/ScreenerViewModel.swift
- [ ] 5.4.6 Implement for stocks, crypto, ETFs
- [ ] 5.4.7 Implement save screener
- [ ] 5.4.8 **COMMIT**: "feat: rebuild screener"

### 5.5 Saved Items (Rebuilt)
- [ ] 5.5.1 Create Features/Saved/Views/SavedView.swift
- [ ] 5.5.2 Create Features/Saved/Views/SavedStocksTab.swift
- [ ] 5.5.3 Create Features/Saved/Views/SavedScreenersTab.swift
- [ ] 5.5.4 Create Features/Saved/ViewModels/SavedViewModel.swift
- [ ] 5.5.5 Implement drag-and-drop reorder
- [ ] 5.5.6 Implement swipe-to-delete
- [ ] 5.5.7 **COMMIT**: "feat: rebuild saved items"

### 5.6 Comparison Tool (Rebuilt)
- [ ] 5.6.1 Create Features/StockDetail/Views/ComparisonView.swift
- [ ] 5.6.2 Create Features/StockDetail/ViewModels/ComparisonViewModel.swift
- [ ] 5.6.3 Implement multi-metric comparison chart
- [ ] 5.6.4 Allow search for comparison stock (not just saved)
- [ ] 5.6.5 **COMMIT**: "feat: rebuild comparison tool"
- [ ] 5.6.6 **PUSH all Phase 5 commits**

---

## Phase 6: Monetization & Payouts (Weeks 21-23)

### 6.1 Subscription
- [ ] 6.1.1 Create Features/Subscription/Views/SubscribeWinView.swift (redesigned)
- [ ] 6.1.2 Implement StoreKit 2 subscription purchase
- [ ] 6.1.3 Implement subscription status sync with backend
- [ ] 6.1.4 Implement free vs premium feature gating
- [ ] 6.1.5 Implement upgrade prompts at gate points
- [ ] 6.1.6 **COMMIT**: "feat: implement subscription system"

### 6.2 Prize Payouts
- [ ] 6.2.1 Backend: Stripe Connect integration for payouts
- [ ] 6.2.2 Backend: PayPal payout integration
- [ ] 6.2.3 Create Features/Profile/Views/PayoutHistoryView.swift
- [ ] 6.2.4 Create Features/Profile/Views/RequestPayoutView.swift
- [ ] 6.2.5 Implement payout request flow
- [ ] 6.2.6 Implement payout history display
- [ ] 6.2.7 Implement payout email notifications (Resend)
- [ ] 6.2.8 **COMMIT**: "feat: implement prize payout system"
- [ ] 6.2.9 **PUSH all Phase 6 commits**

---

## Phase 7: Polish & Launch (Weeks 24-28)

### 7.1 Testing
- [ ] 7.1.1 Unit tests: AuthService
- [ ] 7.1.2 Unit tests: TradingService
- [ ] 7.1.3 Unit tests: PortfolioService
- [ ] 7.1.4 Unit tests: MarketDataService
- [ ] 7.1.5 Unit tests: CompetitionService
- [ ] 7.1.6 Unit tests: All ViewModels
- [ ] 7.1.7 Integration tests: API communication
- [ ] 7.1.8 Integration tests: SwiftData operations
- [ ] 7.1.9 UI tests: Onboarding flow
- [ ] 7.1.10 UI tests: Trading flow
- [ ] 7.1.11 UI tests: Subscription flow
- [ ] 7.1.12 Backend tests: All Worker endpoints
- [ ] 7.1.13 Backend tests: Competition engine
- [ ] 7.1.14 Verify test coverage >70%
- [ ] 7.1.15 **COMMIT**: "test: add comprehensive test suite"

### 7.2 Performance
- [ ] 7.2.1 Profile app launch time (<2 seconds target)
- [ ] 7.2.2 Profile list scrolling performance
- [ ] 7.2.3 Optimize image loading/caching
- [ ] 7.2.4 Verify KV cache hit rates on backend
- [ ] 7.2.5 Fix any memory leaks
- [ ] 7.2.6 **COMMIT**: "perf: optimize performance"

### 7.3 Accessibility
- [ ] 7.3.1 Add VoiceOver labels to all interactive elements
- [ ] 7.3.2 Implement Dynamic Type throughout
- [ ] 7.3.3 Verify color contrast ratios
- [ ] 7.3.4 Test with VoiceOver enabled
- [ ] 7.3.5 **COMMIT**: "a11y: add accessibility support"

### 7.4 App Store Preparation
- [ ] 7.4.1 Create app icons
- [ ] 7.4.2 Create screenshots
- [ ] 7.4.3 Write app description
- [ ] 7.4.4 Configure App Store Connect
- [ ] 7.4.5 TestFlight beta
- [ ] 7.4.6 Submit for review
- [ ] 7.4.7 **COMMIT**: "chore: prepare for App Store submission"
- [ ] 7.4.8 **PUSH all Phase 7 commits**

---

## Total Task Count

| Phase | Tasks | Status |
|-------|-------|--------|
| Phase 0 | 14 | 13 done, 1 in progress |
| Phase 1 | 37 | All pending |
| Phase 2 | 70 | All pending |
| Phase 3 | 54 | All pending |
| Phase 4 | 56 | All pending |
| Phase 5 | 37 | All pending |
| Phase 6 | 11 | All pending |
| Phase 7 | 22 | All pending |
| **TOTAL** | **301** | |

---

*Last Updated: February 11, 2026*
