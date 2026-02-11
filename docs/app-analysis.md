# Upful iOS Application - Comprehensive Analysis Document

**Document Version:** 1.0
**Date:** February 2026
**Repository:** `/Users/elshanmagsudov/upful-ios`
**Branch:** `prod`
**Bundle ID:** `com.syanik.Upful`
**App Store ID:** `1447909027`
**Original Author:** Yanik Simpson (syanik94)
**Project Start:** August 2019

---

## Table of Contents

- [PART 1: EXISTING APPLICATION](#part-1-existing-application)
  - [1. Application Overview](#1-application-overview)
  - [2. Architecture](#2-architecture)
  - [3. Navigation & Screen Flow](#3-navigation--screen-flow)
  - [4. Feature Modules](#4-feature-modules)
  - [5. Trading Engine](#5-trading-engine)
  - [6. Data Layer & CoreData](#6-data-layer--coredata)
  - [7. API Integrations](#7-api-integrations)
  - [8. Networking Layer](#8-networking-layer)
  - [9. Payment & Subscription System](#9-payment--subscription-system)
  - [10. Analytics & Tracking](#10-analytics--tracking)
  - [11. User Profile & Sync](#11-user-profile--sync)
  - [12. Permission Management](#12-permission-management)
  - [13. UI Component Library](#13-ui-component-library)
  - [14. Extensions & Utilities](#14-extensions--utilities)
  - [15. Third-Party Dependencies](#15-third-party-dependencies)
  - [16. Known Issues & Technical Debt](#16-known-issues--technical-debt)
- [PART 2: MODERNIZATION RECOMMENDATIONS](#part-2-modernization-recommendations-feb-2026)
  - [17. Swift Language & Concurrency](#17-swift-language--concurrency)
  - [18. Architecture Modernization](#18-architecture-modernization)
  - [19. UI Framework Migration](#19-ui-framework-migration)
  - [20. Data Layer Modernization](#20-data-layer-modernization)
  - [21. Networking Overhaul](#21-networking-overhaul)
  - [22. Dependency Management & StoreKit](#22-dependency-management--storekit)
  - [23. Security Remediation](#23-security-remediation)
  - [24. Testing & CI/CD](#24-testing--cicd)
  - [25. Accessibility & Localization](#25-accessibility--localization)
  - [26. Performance & Modern APIs](#26-performance--modern-apis)
- [PART 3: NEW DESIGN VISION](#part-3-new-design-vision)
  - [27. Vision Overview: Paper Trading to Gamified Competition](#27-vision-overview-paper-trading-to-gamified-competition)
  - [28. New Screen-by-Screen Analysis](#28-new-screen-by-screen-analysis)
  - [29. Business Model Transformation](#29-business-model-transformation)
  - [30. Implementation Requirements](#30-implementation-requirements)
  - [31. Technical Implementation Roadmap](#31-technical-implementation-roadmap)

---

# PART 1: EXISTING APPLICATION

## 1. Application Overview

Upful is a **paper trading and stock research iOS application** built in 2019. Users simulate stock trades with a virtual $25,000 balance, screen stocks using financial criteria, save companies to watchlists, view historical financial data and charts, and track simulated portfolio performance over time.

The app operates on a **freemium model** with a single monthly auto-renewable subscription ($6.99/month) that unlocks expanded screener access, additional saved stocks/screeners, and deeper historical data.

### Core Value Propositions
- Risk-free stock trading simulation with real market data
- Stock screening by financial criteria (P/E, market cap, dividend yield, etc.)
- Portfolio tracking with performance visualization
- Company research with charts, fundamentals, and news
- Stock comparison on financial metrics

### Current Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift (pre-async/await era) |
| UI Framework | UIKit (100% programmatic, no storyboards) |
| Persistence | CoreData (3 separate data models) |
| Networking | URLSession with completion handlers |
| Charts | danielgindi/Charts |
| Analytics | Firebase Analytics + Mixpanel (dual-tracker) |
| Crash Reporting | Firebase Crashlytics |
| Payments | SwiftyStoreKit (StoreKit v1) |
| Cloud Sync | Firebase Firestore |
| Deep Linking | Firebase Dynamic Links |
| Dependency Manager | CocoaPods (no version pinning) |

---

## 2. Architecture

### 2.1 Architectural Pattern

The app uses a **hybrid MVC + Coordinator + Lightweight MVVM** pattern that evolved organically:

- **MVC (dominant):** Most features use UIKit `UIViewController` subclasses with direct data loading from service classes. Controllers like `HomeGeneralViewController`, `ExploreViewController`, `SavedViewController`, and `SettingsViewController` serve as both controllers and view managers.

- **Coordinator Pattern (partial):** A `Coordinator` protocol exists with `start()` method and `presenter` property. Coordinators are used inconsistently - only for detail/trade/news flows:
  - `MainCoordinator` - Tab bar initialization
  - `StockDetailsCoordinator` - Stock detail navigation
  - `StockTradeCoordinator` - Trading flow
  - `NewsCoordinator` - News article navigation
  - `ProfileSyncCoordinator` - Background data sync

- **Logic Controllers:** Some features use a "Logic Controller" pattern (e.g., `HomeGeneralLogicController`, `ExploreLogicController`) functioning as lightweight presenters separating business logic from view controllers.

- **ViewModels:** Used selectively - `StockOverviewViewModel`, `MetricPreviewViewModel`, `ScreenerViewModel`, `UpfulProductViewModel`.

- **Presenters:** `SubscriptionPresenter`, `NotificationSetupPresenter`, `ReportPresenter` handle modal presentation logic.

### 2.2 State Management Pattern

A consistent state machine pattern is used across features:

```
enum State {
    case new
    case loading
    case loaded
    case empty
    case error
}
```

State changes propagate via closure callbacks (`holdingsStateChanged`, `suggestionsStateChanged`, etc.) with `didSet` observers. This is a pre-Combine reactive pattern.

### 2.3 Observer Pattern

A custom generic pub/sub mechanism (`CompletionHandler<T>`) uses a `Set<Handler<T>>` where `Handler` wraps a closure with a UUID for identity/hashability. Supports `subscribe`, `unsubscribe`, and `notify`. Primary use: `TradingEngine.loadHandlerObservers` broadcasts holding updates to multiple listeners.

### 2.4 Singleton Usage

Heavy singleton pattern throughout:

| Singleton | Responsibility |
|-----------|---------------|
| `TradingEngine.shared` | Trading operations orchestration |
| `PersistenceService.shared` | StockDataModel CoreData container |
| `TransactionContainerManager.shared` | TransactionDataModel CoreData container |
| `PermissionManager.shared` | Freemium gating logic |
| `AnalyticsLogger.instance` | Dual analytics dispatch |
| `UserProfile.instance` | User identity management |
| `ProfileSyncCoordinator.shared` | Firestore sync |

---

## 3. Navigation & Screen Flow

### 3.1 App Lifecycle

```
AppDelegate (@UIApplicationMain)
  -> Configures Firebase, Mixpanel
  -> IAPService().completeTransactions()
  -> MainCoordinator.start()
     -> UITabBarController (4 tabs)
        -> SplashScreenViewController (child, removed after animation)
```

### 3.2 Tab Structure

```
UITabBarController
├── Tab 0: HomeGeneralViewController (House icon)
│     ├── NewsCoordinator -> NewsViewController
│     ├── TransactionHistoryViewController
│     ├── StockDetailsCoordinator -> Stock Detail flow
│     └── StockTradeCoordinator -> Trading flow
│
├── Tab 1: ExploreViewController (Magnifying glass icon)
│     └── Search Results -> StockDetailsCoordinator
│
├── Tab 2: SavedViewController (Heart icon)
│     ├── Saved Stocks sub-tab
│     └── Saved Screeners sub-tab
│
└── Tab 3: SettingsViewController (Gear icon)
      ├── SubscriptionViewController
      ├── SuggestionFeedViewController
      └── WebNavigation (SFSafariViewController)
```

### 3.3 UI Construction

All UI is **100% programmatic UIKit**. The only storyboard is `Launch Screen.storyboard` (required by iOS). No XIBs are used. All views are built in code using a custom auto-layout DSL defined in `UIView+Extensions.swift`.

Each tab wraps its root view controller in a `UINavigationController` with large titles enabled and translucent navigation bars disabled.

---

## 4. Feature Modules

### 4.1 Home (Portfolio Dashboard)

**Location:** `Upful/Features/Home/`
**Key Files:** 23 files including controllers, logic controllers, view models, views, and news cells

**Purpose:** Main landing screen showing the user's simulated trading portfolio.

**User Stories:**
1. View total equity vs. the $25,000 initial balance with dollar and percentage change
2. View cash balance and "last updated" timestamp
3. View individual holdings with ticker, shares, current price, cost basis, dollar/percent P/L (color-coded green/red)
4. Long-press a holding for context menu: View (stock detail), Trade (trade screen), Sell All
5. View collapsible pie chart portfolio breakdown (donut chart with 62% hole radius)
6. Receive stock suggestions based on preferences (up to 3 random suggestions per preference group)
7. Pull-to-refresh plus 15-second auto-refresh timer
8. Navigate to screener via nav bar button
9. First-time experience: splash animation followed by subscription prompt

**UI Components:**
- `UITableView` (grouped) with 3 sections: Holdings, Breakdown (pie chart), Suggestions
- `TradingBalanceView` as table header with `TotalEquityView` and `CashBalanceView`
- `StockHoldingTableViewCell` with ticker, shares, price, P/L labels
- `HoldingsBreakdownTableViewCell` containing `GenericPieChartView`
- `HomeFeedAuxiliaryActionView` with action buttons
- `SentimentView` for news sentiment pills

**Data Flow:**
- `HomeGeneralLogicController` uses `TradingEngine.shared` for holdings via completion handlers
- Preferences loaded from CoreData via `PreferenceDataManager`
- Stock screening via `StockScreeningService` (Intrinio API)
- News via `NewsLoader` from stocknewsapi.com

**Known Issues:**
- No empty state for holdings when user has no positions
- Hardcoded API key in `StockScreeningService.swift`
- 15-second auto-refresh timer without battery/background awareness
- Performance chart section (1W-ALL) is prepared but commented out
- Force-unwrap on `priceFormatter.string(from: product.price)!`

---

### 4.2 Stock Detail

**Location:** `Upful/Features/Stock Detail/`
**Key Files:** 8 files including controller, coordinator, viewmodels, datasources

**Purpose:** Deep dive into a single stock with price chart, financial bar graphs, fundamental calculations, news, and company description.

**User Stories:**
1. View stock price performance chart
2. View revenue and earnings bar charts over time
3. View fundamental metrics: P/E, P/B, P/R, dividend yield, market cap, EBIT margin, etc.
4. Read related news articles
5. Read company description
6. Save/unsave a stock (toggle nav bar button, persists via CoreData)
7. Share stock via deep link (`UpfulDeepLinkManager.create()`) with `UIActivityViewController`
8. Drag bottom panel up to reveal TRADE button -> trading screen
9. Drag bottom panel up to reveal COMPARE button -> comparison modal
10. View metric previews (P/E ratio and EBIT margin with 5-year historical line charts)
11. Change comparison metric via full-drag position metric selector

**UI Components:**
- `UITableView` with 5 sections: Price Performance, Bar Graph, Calculations, News, Description
- `StockDetailDragViewController` with `YSDraggy.DragView` (3 positions: collapsed, preview, full)
- `SearchCriteriaSelectionViewController` for metric selection
- Line charts and bar charts from Charts library

**Data Flow:**
- `StockOverviewViewModel` loads all data in parallel via `DispatchGroup`: company name, quote, historical revenue/earnings, calculations, news, description
- Dependencies injected: `QuoteLoader`, `FinancialLoader`, `BatchFinancialLoader`, `NewsLoaderProtocol`, `DescriptionLoader`
- `MetricPreviewViewModel` loads 5-year historical data
- Three separate datasource objects manage drag view content

**Known Issues:**
- Tab bar manually hidden/shown (visual glitch risk)
- No skeleton/shimmer loading state
- Hardcoded default metrics (P/E and EBIT margin)
- `fatalError("No Product with that Identifier found")` in UpfulProductViewModel

---

### 4.3 Screener Selection

**Location:** `Upful/Features/Screener Selection/`
**Key Files:** 7 files for prebuilt and manual screener flows

**Purpose:** Filter stocks by financial criteria via prebuilt screeners (remote) or manual custom screeners.

**User Stories:**
1. Browse prebuilt screeners in "Popular" and "Available" sections
2. Run a prebuilt screener (navigates to search results)
3. Build a custom screener: 3 criteria sections (Valuation, Financial, Performance) as 3-column collection view grid
4. Adjust criteria values via bottom-sheet slider with greater-than/less-than toggle
5. Long-press for metric definitions
6. Execute screen (BUILD button, requires at least one criterion)
7. Permission gating for non-premium users

**Data Flow:**
- Prebuilt screeners from `RemoteScreenerLoader` (Firebase Firestore)
- Interest tracking: `incrementScreenerInterest(documentID:)` on each tap
- Manual criteria via `ManualScreenItemViewModel` with ranges, step sizes, formatting

---

### 4.4 Search Results

**Location:** `Upful/Features/Search Results/`
**Key Files:** 3 files (controller, viewmodel, coordinator)

**Purpose:** Display stock screening results with pagination and sorting.

**User Stories:**
1. View matching stocks in scrollable list
2. Sort by Market Cap (ascending/descending)
3. Infinite scroll (loads next page near end)
4. Navigate to stock detail on tap
5. Save screener (prompt for name if "Custom")

**Known Issues:**
- No pull-to-refresh
- No empty state guidance
- Each result loads quote independently (no batch API)

---

### 4.5 Saved (Stocks & Screeners)

**Location:** `Upful/Features/SaveView/`
**Key Files:** 8 files across saved stocks and saved screeners

**Purpose:** Two sub-tabs for watchlist stocks and saved screener configurations.

**User Stories:**
1. View saved stocks with live quote data
2. Drag-and-drop reorder (UIKit drag/drop APIs)
3. Swipe-to-delete
4. Navigate to stock detail on tap
5. View saved screeners with color-coded indicators
6. Run saved screener on tap
7. Add new screeners via plus button

**Data Flow:**
- `LocalStockLoader` performs CoreData CRUD on `SavedStock` entities
- `LocalScreenerLoader` performs CoreData CRUD on `SavedScreener` entities
- Each saved stock independently loads current quote

**Critical Issue:**
- **Destructive reorder persistence:** Deletes all entries and re-saves in new order. App crash mid-operation = data loss.

---

### 4.6 Subscription

**Location:** `Upful/Features/Subscription/`
**Key Files:** 5 files (controller, model, presenter, viewmodels)

**Purpose:** Premium in-app purchase promotion and processing.

**Product:** Single monthly subscription at $6.99/month (`com.syanik.Upful.Yanik.MonthlySubscription`)

**Trigger Contexts:**
- `firstAppOpen` - First launch
- `savedStockLimit` - Exceeded saved stock limit
- `savedScreenerLimit` - Exceeded screener limit
- `screeningLimit` - Exceeded daily screening limit
- `settings` - From Settings screen
- `fiveYearDataInterest` - Requesting 5-year data

**Premium Unlocks:**
- Unlimited saved stocks (free: 3)
- Unlimited saved screeners (free: 2)
- Unlimited daily screener navigations (free: 6/day)
- 5-year historical financial data (free: 3 years)

**Known Issues:**
- `fatalError` on unknown product ID (crash in production)
- No loading indicator during purchase
- Typo: "occured" should be "occurred"
- UI logic in `deinit` (fragile)

---

### 4.7 Explore (Discovery Feed)

**Location:** `Upful/Features/Explore Feed/`
**Key Files:** 2 files (controller, logic controller)

**Purpose:** Discovery/search screen with curated content and company search.

**Sections (normal mode):**
1. Market news (3 articles)
2. Popular stocks (4 stocks from Firestore)
3. Popular screeners (3 screeners)

**Search:** UISearchController with 250ms debounce via `DispatchWorkItem`

---

### 4.8 Stock Comparison

**Location:** `Upful/Features/Stock Comparison/`
**Key Files:** 2 files (controller, viewmodel)

**Purpose:** Side-by-side comparison of two stocks on a selected financial metric with 5-year historical line chart.

**Limitation:** Second ticker must come from saved stocks only (can't search all stocks).

---

### 4.9 Stock Trade

**Location:** `Upful/Features/StockTrade/` and `Upful/Features/New Group/` (misnamed folder)

**Purpose:** Simulated trading screen for buying/selling shares.

**User Stories:**
1. Enter share count via number pad
2. View current price and real-time trade estimate
3. View current position and cash balance
4. Buy shares (validates sufficient cash)
5. Sell shares (validates sufficient holdings)
6. Success animation with haptic feedback

**Limitations:**
- Whole shares only (no fractional)
- Market orders only (no limit/stop)
- No confirmation dialog before execution

---

### 4.10 Recommendations (NPS Survey)

**Location:** `Upful/Features/Recommendations/`

**Purpose:** Net Promoter Score survey (0-10 scale).

**Issue:** App Store review prompt fires for ALL scores including detractors (0-6), which is counterproductive.

---

### 4.11 Reports & Suggestions (Feedback)

**Location:** `Upful/Features/Reports/` and `Upful/Features/Suggestions/`

**Purpose:** Issue reporting, suggestion submission, and community suggestion voting.

**Issues:**
- Unlimited voting (no per-user rate limiting)
- Vote commit on `deinit` (lost on crash)
- Hardcoded email: `elio@jyanik.com`

---

### 4.12 Settings

**Location:** `Upful/Features/Settings/`

**Sections:** Preferences, Purchase (upgrade), Support (suggestions, report issue, tracking toggle), Review

**Issue:** Tracking opt-out is premium-gated, potentially conflicting with App Store privacy guidelines.

---

### 4.13 Preferences

**Location:** `Upful/Features/Preferences/`

**Categories (drive Home screen suggestions):**
1. **Industry** (up to 3): 24 options from Retail to Biotechnology
2. **Growth:** Any, High, Medium, Low, Negative
3. **Profitability:** Any, Highly Profitable, Medium, Low, Not Profitable
4. **Dividend:** Any, No Dividends, High/Medium/Low Yield

Persisted via `PreferenceDataManager` in CoreData.

---

### 4.14 Splash Screen

**Location:** `Upful/Features/Splash Screen Module/`

Animated "UPFUL" brand reveal: mask animation -> scale up -> scale down -> fade out (~1.1 seconds with 0.6s initial delay). Uses `UIView.animateKeyframes`. Added as child VC, removed after completion.

---

### 4.15 Web Navigation

**Location:** `Upful/Features/WebNavigation/`

`SafariPresenter` opens URLs in `SFSafariViewController` for news articles and legal documents.

---

## 5. Trading Engine

### 5.1 Architecture

Located at `Upful/Custom APIs/Trading Engine/`, this is the most well-structured component of the codebase. It implements a paper trading system organized into four subsystems:

```
TradingEngine (Singleton Facade)
├── BalanceManager - Cash & equity tracking
├── TransactionLoggingManager - Audit trail (local + remote)
├── LedgerManager - Active positions (CoreData)
└── StockSplitHandler - Split adjustment logic
```

### 5.2 Buy Flow

1. `buy(transaction:completion:)` called
2. `validatePurchaseAttempt`: checks `tradePrice * numberOfShares <= currentCashBalance`
3. `TransactionLoggingManager.log()`: writes to Firestore first, then local CoreData `LoggedTransaction`
4. `LedgerManager.save()`: persists as `PersistedTransaction` in CoreData
5. `BalanceManager.handleBuy()`: debits cash balance
6. Analytics event reported

### 5.3 Sell Flow

1. `sell(transaction:completion:)` called
2. **No inline validation** (unlike buy) - `validateSaleAttempt` exists but must be called externally
3. Same logging and ledger persistence as buy
4. `BalanceManager.handleSell()`: credits cash balance

### 5.4 Holdings Loading

1. `loadHoldings()` fetches all `PersistedTransaction` records from CoreData
2. `HoldingMapper` groups by ticker, creates `Holding` objects
3. `StockPriceLoader` fetches current prices via `DispatchGroup`
4. Equity balance updated
5. Stock split checks execute (once per day)
6. Results propagated via `CompletionHandler<[Holding]>` observer pattern
7. `ProfileSyncCoordinator.sync()` pushes to Firestore

### 5.5 Balance Management

`BalanceManager` stores two values in **UserDefaults only** (not CoreData):
- `cash` - initialized to $25,000
- `equity` - total portfolio value

**Critical:** Balances are not recoverable from transaction history if UserDefaults is cleared. No reconciliation mechanism exists.

### 5.6 Transaction Protocol

```swift
protocol Transaction: class {
    var ticker: String { get set }
    var numberOfShares: Int32 { get set }
    var tradePrice: Double { get set }
    var type: String { get set }
    var transactionDate: String { get set }
    var id: String { get set }
    var lastAppliedStockSplit: Date? { get set }
}
```

Three conforming types:
1. `PersistedTransaction` (NSManagedObject) - ledger entity
2. `LoggedTransaction` (NSManagedObject) - log entity
3. `TransactionAdapter` (plain class) - in-memory adapter

### 5.7 Holdings Model

`Holding` aggregates transactions per ticker and computes:
- `totalShareCount` = buy shares - sell shares
- `currentTotalValue` = currentPrice * totalShareCount
- `averagePrice` = weighted average of buy prices
- `totalPriceMovementDollar` and `totalPriceMovementPercent` (P/L)

### 5.8 Stock Split Handling

- `StockSplitFetcher` queries IEX Cloud `/splits/1yr` per ticker
- `StockSplitHandler` adjusts: `tradePrice / ratio` and `numberOfShares * ratio`
- Runs once per calendar day (UserDefaults date check)
- Multiple tickers processed via `DispatchGroup`

---

## 6. Data Layer & CoreData

### 6.1 Schema Overview

The app uses **three separate CoreData data models** with **two separate `NSPersistentContainer` instances**:

#### StockDataModel (managed by `PersistenceService.shared`)

| Entity | Attributes | Uniqueness |
|--------|-----------|------------|
| `SavedStock` | `ticker`, `companyName`, `notes` | Unique on `ticker` |
| `SavedScreener` | `id`, `title`, `screenDescription`, `searchParameters`, `colorMap`, `symbol` | Unique on `id`, indexed |
| `Notes` | `content`, `id` | Unique on `id` |

No relationships defined in schema.

#### TransactionDataModel (managed by `TransactionContainerManager.shared`)

| Entity | Attributes | Uniqueness |
|--------|-----------|------------|
| `PersistedTransaction` | `id`, `ticker`, `numberOfShares` (Int32), `tradePrice` (Double), `transactionDate`, `type`, `lastAppliedStockSplit` (Date) | None |
| `LoggedTransaction` | Same schema as PersistedTransaction | None |
| `User` | `id`, `firstTransactionDate` (Date) | None |
| `PersistedPerformanceDataPoint` | `cashBalance` (Double), `holdingBalance` (Double), `date` (Date) | Unique on `date` |

#### TransactionLog (Legacy/Orphaned)

Older schema with `averagePrice`/`currentPrice` instead of `tradePrice`. Both entities incorrectly have `representedClassName="PersistedTransaction"`. Appears superseded by TransactionDataModel.

### 6.2 Context Management

- `TransactionContainerManager` uses parent-child pattern: backgroundContext (private queue) -> viewContext (main queue)
- `PersistenceService` uses viewContext only. `saveContext()` calls `fatalError` on save failure
- Both use `NSMergeByPropertyObjectTrumpMergePolicy`

### 6.3 Data Models (API/Codable)

| Model | Purpose |
|-------|---------|
| `CompanyFundamentals` | Intrinio financial statement data |
| `HistoricalDataSearch` | Date-value pairs for historical data |
| `CompanyNewsModel` | News articles (title, date, URL, summary) |
| `ScreeningResponse` | Paged stock screening results |
| `Stock` | Class with name, ticker, fundamentals, quote (uses NSCache) |
| `SearchCriteria` | 24-case enum with display names, parameter types, definitions, value bounds |
| `StockQuote` | Real-time price data from IEX Cloud |
| `StockSplit` | Split ratio data from IEX Cloud |

### 6.4 Data Flow Diagram

```
[IEX Cloud / Intrinio APIs]
        |
  HTTP Response (JSON)
        |
  Decodable Structs
        |
  TradingEngine / HoldingMapper / StockSplitHandler
        |
  +--- Transaction protocol ---+
  |                            |
  v                            v
PersistedTransaction      LoggedTransaction
(CoreData - Ledger)       (CoreData - Audit Log)
  |                            |
  +--> HoldingMapper groups by ticker
          |
          v
      Holding (in-memory)
          |
  StockPriceLoader fetches currentPrice
  |
  v
BalanceManager (UserDefaults)  <-->  UI ViewControllers
  |
  v
ProfileSyncCoordinator  -->  Firestore (users/{id})
                         -->  Firestore (transactions/{uuid})
```

---

## 7. API Integrations

### 7.1 Intrinio API (Primary Financial Data)

| Detail | Value |
|--------|-------|
| Base URL (v2) | `https://api-v2.intrinio.com/` |
| Base URL (v1) | `https://api.intrinio.com/` |
| Auth | API key as query parameter |
| Used For | Company search, stock screening, historical financials, batch fundamentals, company news |
| Files | `IntrinioAPI.swift`, `StockSearchService.swift`, `StockFinancialLoader.swift`, `BatchFinancialLoader.swift`, `CompanyNameLoader.swift` |

### 7.2 IEX Cloud API (Market Data)

| Detail | Value |
|--------|-------|
| Production | `https://cloud.iexapis.com/stable/stock/` |
| Sandbox | `https://sandbox.iexapis.com/stable/stock/` |
| Auth | Token as query parameter |
| Used For | Real-time quotes, end-of-day prices, historical price charts (1D-5Y), company descriptions, stock splits |
| Files | `QuoteLoader.swift`, `HistoricalPriceLoader.swift`, `StockDescriptionLoader.swift` |

### 7.3 Stock News API

| Detail | Value |
|--------|-------|
| Token | Defined in `Constants.StockNewsAPI.token` |
| Used By | `NewsLoader` in Home feature |

### 7.4 Firebase / Firestore

| Detail | Value |
|--------|-------|
| Project | `upful-c9f8c` |
| Collections | `popularStocks`, `savedCompanies`, `suggestions`, `screeners`, `engagement`, `users`, `transactions` |
| Dynamic Links | `upful.io` domain |

### 7.5 Mixpanel

| Detail | Value |
|--------|-------|
| Token | Hardcoded in Constants |
| Used For | Event tracking alongside Firebase Analytics |

### 7.6 Apple StoreKit

| Detail | Value |
|--------|-------|
| Validation | Apple production receipt servers |
| Shared Secret | Hardcoded in `IAPService.swift` |

---

## 8. Networking Layer

**File:** `Upful/Services/NetworkingService.swift`

`HTTPClient` provides two methods:
1. `downloadContentWithCache` - 100MB disk `URLCache`, returns cached data if available
2. `downloadContent` - Simple `URLSession.shared` fetch, no caching

### Issues
- Force-unwrapping `response!` and `data!` (crash on nil)
- No centralized error handling or request interceptor
- No retry logic or timeout configuration
- Services bypass `HTTPClient`, using `URLSession.shared.dataTask()` directly
- URL construction via string concatenation (no `URLComponents`)
- API keys appended as raw strings
- Two different error enum types: `NetworkingError` (4 cases) and `NetworkError` (3 cases)
- No Combine or async/await (fully callback-based)

---

## 9. Payment & Subscription System

**Files:** `IAPService.swift`, `UpfulProducts.swift`

**Product:** `com.syanik.Upful.Yanik.MonthlySubscription` ($6.99/month)

**Flow:**
1. `AppDelegate.didFinishLaunching` calls `IAPService().completeTransactions()`
2. `IAPService` handles product retrieval, purchase, restore, verification via SwiftyStoreKit
3. Premium status stored as `UserDefaults` boolean (`isPremium`)
4. Receipt verification via `SwiftyStoreKit.verifyReceipt` against Apple production servers
5. `PermissionManager` gates features based on `isPremium`

---

## 10. Analytics & Tracking

**Files:** `AnalyticsEvents.swift`, `AnalyticsMapper.swift`, `AnalyticsTrackers.swift`

**Architecture:** Dual-tracker with `AnalyticsTracker` protocol. `AnalyticsLogger` singleton dispatches to both `MixPanelAnalytics` and `FirebaseAnayltics` (typo in class name).

Events only fire in `RELEASE` builds; `DEBUG` prints to console. Users can toggle analytics via UserDefaults flag.

**22 Tracked Events:**
`performServerUpdate`, `signUpForPremiumPresented`, `signUpAttempt` (typo: "attempty"), `selectedPremium`, `castedSuggestionVote`, `pushNotificationSelected`, `selectedNewsArticle`, `screenForStocks`, `selectedAnalysis`, `selectedCompareTicker`, `selectedStock`, `selectedCompanyFiling`, `preferencesSet`, `suggestion`, `issue`, `noteSaved`, `savedScreener`, `savedTicker`, `submitPromotorScore`, `performedTransaction`

---

## 11. User Profile & Sync

### UserProfile
Singleton managing identity via UUID-based `profileID` in UserDefaults. `isNewUser` tracked via boolean flag. Public `init()` inconsistent with singleton usage.

### ProfileDataManager
CoreData `User` entity CRUD. Calculates user score via logarithmic formula based on performance and weeks since first trade.

### ProfileSyncCoordinator
Singleton syncing to Firestore on background queue: holdings array, performance %, score, first trade date, last sync timestamp. Performance = `((equityBalance / 25000) - 1) * 100`.

---

## 12. Permission Management

**File:** `PermissionManager.swift`

Singleton managing freemium gating:

| Permission | Free Limit | Premium |
|-----------|------------|---------|
| Saved stocks | 3 | Unlimited |
| Saved screeners | 2 | Unlimited |
| Daily screener navigations | 6/day | Unlimited |

Uses UserDefaults for premium status and daily counter. Resets daily at start of new day. Schedules local notifications when screening limit hit.

---

## 13. UI Component Library

### Buttons
- `CustomButton` - 40pt height, rounded corners, teal text
- `CustomRoundButton` - 50x50 circular with SF Symbol icon, touch animations
- `SmallRoundButton` - 20x20 variant
- `MultilineButton` - 55x55 with icon + text label

### Views
- `AuxiliaryActionView` - Horizontal button stack with adaptive dark/light backgrounds
- `PercentChangeView` - Color-coded P/L display (green/red/gray)
- `NavigationHeaderView` - 44pt custom navigation header
- `LoadingViewController` - Centered activity indicator child VC
- `Animator` - Pop-in/fade-out animation utility
- `MenuContainerViewController` - Horizontal-paging tab interface with scroll-driven tab indicator

---

## 14. Extensions & Utilities

| Extension | Key Functionality |
|-----------|------------------|
| `Array+Extensions` | `moveItem(from:to:)`, `removeDuplicates()` |
| `Date+Extensions` | Calendar accessors, `isToday`, date math |
| `Double+Extensions` | `convertToPercent()`, `twoDecimal()` (misnamed, uses 1 decimal), `withCommas()` |
| `Int+Extensions` | `formatUsingAbbreviation()` (K/M/B/T), `withCommas()` |
| `String+Extensions` | `formatDate()` - parses date to year |
| `UIColor+Extensions` | Semantic palette: `backgroundColor`, `positive`, `negative`, `appAccent` (yellow), `appAccent3-5` (greens) |
| `UIFont+Extensions` | Semantic styles: `sectionHeader` (12pt), `viewHeader` (15pt), `details1-4` (13-15pt) |
| `UIImage+Extensions` | Async loading with NSCache, aspect-fit resize |
| `UITableView+Extensions` | `contentHeight()`, empty state views, auto-layout headers/footers |
| `UIView+Extensions` | Comprehensive auto-layout DSL: `anchor()`, `fillSuperview()`, `centerInSuperview()`, chainable anchors, shadows, corner rounding |
| `UIViewController+Extensions` | Child VC containment, keyboard dismissal |
| `UserDefaults+Extensions` | `firstAppOpen`, `toggleBool()` |

### Utility Classes
- `Vibration` - Haptic feedback wrapper (error, success, warning, light, medium, heavy, selection)
- `VersionManager` (in `ColorManager.swift`) - Dark/light mode colors, nav/tab bar appearance
- `DateTransformer` - Multi-format date parsing (force-unwraps)
- `AsyncOperation` - Thread-safe Operation subclass for async work

---

## 15. Third-Party Dependencies

| Pod | Purpose | Status |
|-----|---------|--------|
| `SwiftyStoreKit` | In-app purchase management | Active |
| `Firebase/Analytics` | Analytics tracking | Active |
| `Firebase/Core` | Firebase core SDK | Active |
| `Firebase/Crashlytics` | Crash reporting | Active |
| `Firebase/DynamicLinks` | Deep linking | Active (handling disabled) |
| `Firebase/Firestore` | Cloud database | Active |
| `Mixpanel-swift` | Analytics tracking | Active |
| `Charts` | Stock/financial charts | Active |
| `Firebase/AdMob` | Advertising | Commented out |
| `Google-Mobile-Ads-SDK` | Mobile ads | Commented out |

**All pods are unpinned** (no version constraints), risking breaking changes on `pod update`.

---

## 16. Known Issues & Technical Debt

### Critical Security

| # | Issue | Impact |
|---|-------|--------|
| S1 | API keys hardcoded in source code (Intrinio, IEX Cloud, Mixpanel, Stock News, IAP shared secret) | Keys exposed to anyone with repo access |
| S2 | Hardcoded API key in `StockDescriptionLoader.swift` URL string | Key visible in network logs |
| S3 | IAP shared secret in `IAPService.swift` | Receipt validation compromise risk |

### Crash Risks

| # | Issue | Location |
|---|-------|----------|
| C1 | Force-unwrap `response!`, `data!` | `NetworkingService.swift` |
| C2 | `fatalError("No Product with that Identifier found")` | `UpfulProductViewModel` |
| C3 | `fatalError` on CoreData save failure | `PersistenceService.saveContext()` |
| C4 | `try!` on CoreData fetch | `LocalTransactionLedgerLoader.loadFiltering()` |
| C5 | Force-unwrap in `DateTransformer.convertStringToDate` | `UserProfile.swift` |
| C6 | Force-unwrap `components.queryItems!` | Various API services |

### Data Integrity

| # | Issue | Impact |
|---|-------|--------|
| D1 | Balance stored in UserDefaults only (not derived from transactions) | Unrecoverable if UserDefaults cleared |
| D2 | Destructive reorder persistence (delete-all, re-save) | Data loss on crash during reorder |
| D3 | `LedgerManager.delete()` has empty body | Transaction deletion broken |
| D4 | `TransactionLedgerPersistence.delete()` deletes ALL records | Deletes everything instead of target |
| D5 | 12-hour time format (`hh` not `HH`) without AM/PM | 1 PM and 1 AM produce identical strings |
| D6 | Orphaned `TransactionLog` xcdatamodel with wrong class mappings | Potential CoreData conflicts |
| D7 | Schema/code mismatch: `SavedScreenerParameter` relationship defined in code but not in schema | Runtime relationship errors |
| D8 | No uniqueness constraints on transaction entities | Duplicate entries on crash |

### Structural

| # | Issue |
|---|-------|
| T1 | Duplicate model files: `CompanyCalculations.swift` and `IntrinioLookup.swift` contain identical code |
| T2 | Duplicate file versions: "2" and "3" copies of Stock Detail files |
| T3 | Two versions of `HistoricPerformanceMapper` with overlapping but different implementations |
| T4 | Corrupted `BackgroundRefreshManager.swift` (macOS alias/bookmark file) |
| T5 | Duplicate search: `IntrinioAPI.searchByName()` and `StockSearchService.search()` identical |
| T6 | "New Group" folder for StockTrade (Xcode default never renamed) |
| T7 | `VersionManager` struct in `ColorManager.swift` (misleading name) |
| T8 | Test file in wrong directory (`SavedStocksViewModelTest.swift` in Extensions) |
| T9 | Deep link handling entirely commented out in AppDelegate |
| T10 | Hardcoded date ranges in API queries (stale: `2020-01-01` to `2021-01-01`) |
| T11 | Semaphore misuse in HistoricPerformanceManager |
| T12 | NSCache local to each call in `UIImageView.loadImage` (defeats caching purpose) |
| T13 | `Double.twoDecimal()` uses 1 fraction digit (misnamed) |
| T14 | No SceneDelegate (older AppDelegate-only lifecycle) |
| T15 | `@UIApplicationMain` instead of `@main` |
| T16 | Tracking opt-out gated behind paywall |
| T17 | NPS survey triggers App Store review for detractors |
| T18 | Unlimited suggestion voting without rate limiting |

---

# PART 2: MODERNIZATION RECOMMENDATIONS (Feb 2026)

The Upful app was built starting August 2019, making it approximately 6.5 years old. Since then, Swift and iOS have undergone significant evolution. This section outlines what should be modernized to align with current (Feb 2026) best practices.

---

## 17. Swift Language & Concurrency

### 17.1 Adopt Swift Concurrency (async/await)

**Current state:** Entire codebase uses completion handler callbacks, creating deep nesting and error-prone patterns.

**Recommendation:** Migrate to structured concurrency:

- Replace all `completionHandler` closures with `async throws` functions
- Replace `DispatchGroup` usage in `StockOverviewViewModel`, `HoldingMapper`, and `StockSplitHandler` with `TaskGroup`
- Replace `DispatchSemaphore` usage with async/await
- Use `@MainActor` for UI-bound code instead of `DispatchQueue.main.async`
- Adopt `AsyncSequence` for streaming data (e.g., real-time price updates)
- Replace the custom `CompletionHandler<T>` observer pattern with `AsyncStream` or Combine publishers

### 17.2 Adopt Swift 6 Strict Concurrency

- Enable strict concurrency checking (`-strict-concurrency=complete`)
- Mark shared mutable state with `@Sendable` and proper isolation
- Convert singletons to use actors: `TradingEngine` -> `actor TradingEngine`
- Address data races in `BalanceManager` (concurrent UserDefaults access)

### 17.3 Modern Swift Features

- Replace `class` protocol constraint with `AnyObject`
- Use `if let` shorthand (Swift 5.7+)
- Adopt `some` and `any` for protocol types
- Use `guard let self` shorthand in closures
- Leverage `Regex` builder for date parsing instead of `DateFormatter`
- Use `Duration` and `Clock` APIs for timing instead of raw `TimeInterval`

---

## 18. Architecture Modernization

### 18.1 Adopt Clean Architecture (MVVM + Coordinator)

**Current state:** Hybrid MVC/Coordinator/MVVM applied inconsistently.

**Recommendation:**
- Standardize on **MVVM with Coordinators** for all features
- Each feature module gets: `View` (UIKit or SwiftUI), `ViewModel` (ObservableObject), `Coordinator`, `Repository`
- ViewModels expose state via `@Published` properties (Combine) or `@Observable` (Observation framework)
- Coordinators manage all navigation (remove direct `pushViewController` calls from VCs)

### 18.2 Dependency Injection

**Current state:** Services instantiated directly, heavy singleton usage.

**Recommendation:**
- Introduce a DI container (e.g., Swinject, Factory, or manual composition root)
- Replace singletons with injected protocols
- Create protocol-based abstractions for all services
- Enable unit testing through mock injection

### 18.3 Modularization

**Current state:** Single monolithic target.

**Recommendation:** Break into Swift Packages:
- `UpfulCore` - Models, protocols, extensions
- `UpfulNetworking` - API clients, request/response handling
- `UpfulTrading` - Trading engine, balance, ledger
- `UpfulPersistence` - CoreData stack, repositories
- `UpfulUI` - Reusable UI components
- `UpfulFeatures` - Feature modules (or individual feature packages)

Benefits: faster build times, enforced boundaries, reusable across targets (e.g., widgets).

---

## 19. UI Framework Migration

### 19.1 SwiftUI Integration Strategy

**Recommendation:** Incremental adoption, not full rewrite.

- New features (Leaderboard, Chat, Notifications, Profile) should be built in SwiftUI
- Wrap SwiftUI views in `UIHostingController` for integration with existing UIKit navigation
- Migrate existing features screen-by-screen, starting with simpler ones (Settings, Preferences, Recommendations)
- Use `UIViewControllerRepresentable` to wrap remaining UIKit components (Charts, drag views)

### 19.2 Modern UIKit Patterns (for features remaining in UIKit)

- Adopt `UICollectionView` compositional layouts and diffable data sources
- Replace manual `UITableView` cell registration with modern cell registration API
- Use `UIContentConfiguration` for cell content instead of direct subview manipulation
- Adopt `UISheetPresentationController` for bottom sheets (replace YSDraggy)

### 19.3 Design System

- Create a unified design token system for colors, fonts, spacing, corner radii
- Use `Color.accentColor` and semantic system colors in SwiftUI
- Adopt SF Symbols 5+ consistently
- Implement Dynamic Type support throughout
- Consider building a design system Swift Package

---

## 20. Data Layer Modernization

### 20.1 SwiftData Migration

**Current state:** CoreData with 3 separate models, no versioning, no migration strategy.

**Option A - SwiftData (Recommended for new features):**
- Use `@Model` macro for data models
- Leverage automatic schema migration
- Use `ModelContainer` and `ModelContext`
- SwiftData integrates naturally with SwiftUI via `@Query`

**Option B - CoreData Modernization (if staying with CoreData):**
- Consolidate 3 data models into 1
- Add proper relationships between entities
- Implement lightweight migration with versioned models
- Use `NSPersistentCloudKitContainer` for iCloud sync
- Replace `fatalError` save handling with proper error propagation
- Add uniqueness constraints on transaction entities

### 20.2 Remove UserDefaults for Business Data

- Move balance from UserDefaults to CoreData/SwiftData
- Derive balance from transaction history (single source of truth)
- Keep UserDefaults only for preferences and flags
- Implement balance reconciliation on app launch

### 20.3 Fix Data Integrity Issues

- Fix 12-hour time format bug (`hh` -> `HH`)
- Remove orphaned `TransactionLog` data model
- Fix schema/code mismatch for `SavedScreenerParameter`
- Add uniqueness constraints on transactions
- Implement safe reorder persistence (use `order` field instead of delete-all/re-save)

---

## 21. Networking Overhaul

### 21.1 Modern Networking Stack

**Replace current `HTTPClient` with:**

- `URLSession` with `async/await` APIs (native since iOS 15)
- `URLComponents` for URL construction (replace string concatenation)
- Centralized request interceptor for authentication headers
- Proper error handling with typed errors (no force-unwraps)
- Retry logic with exponential backoff
- Request/response logging for debugging

### 21.2 API Client Architecture

- Define `APIEndpoint` protocol with base URL, path, parameters, headers
- Create type-safe endpoint definitions per API (Intrinio, IEX Cloud, etc.)
- Use `JSONDecoder` with custom date decoding strategies
- Implement request caching with `URLCache` configuration
- Add connectivity monitoring via `NWPathMonitor`
- Consider a lightweight networking library or build a minimal one

### 21.3 Consolidate Duplicate Code

- Merge `IntrinioAPI.searchByName()` and `StockSearchService.search()`
- Unify `NetworkingError` and `NetworkError` into one type
- Ensure all services route through the centralized client

---

## 22. Dependency Management & StoreKit

### 22.1 Migrate to Swift Package Manager

**Current state:** CocoaPods with no version pinning.

**Recommendation:**
- Replace CocoaPods with SPM for all dependencies
- Pin dependency versions for reproducible builds
- Evaluate alternatives for deprecated/unmaintained pods

### 22.2 Dependency Replacements

| Current | Replacement | Reason |
|---------|------------|--------|
| `SwiftyStoreKit` | **StoreKit 2** (native) | SwiftyStoreKit is unmaintained; StoreKit 2 has async/await, `Transaction.updates`, `Product.SubscriptionInfo` |
| `Charts` | **Swift Charts** (native, iOS 16+) | Apple's native charting framework, SwiftUI-native |
| `Firebase/DynamicLinks` | **Universal Links** (native) | Firebase Dynamic Links deprecated as of 2025 |
| `Firebase/Firestore` | Keep or migrate to **CloudKit** | Depends on backend strategy |
| `Mixpanel-swift` | Evaluate consolidation with Firebase Analytics | Reduce dual-tracking overhead |
| `YSDraggy` | `UISheetPresentationController` (native) | Native bottom sheet support since iOS 15 |

### 22.3 StoreKit 2 Migration

- Replace SwiftyStoreKit with native StoreKit 2 APIs
- Use `Product.products(for:)` instead of SKProductsRequest
- Use `Product.purchase()` with async/await
- Listen to `Transaction.updates` for real-time transaction state
- Server-side receipt validation via App Store Server API v2
- Support for subscription offer codes and promotional offers
- Remove hardcoded shared secret (no longer needed with StoreKit 2)

---

## 23. Security Remediation

### 23.1 API Key Management

**Priority: CRITICAL**

- Remove ALL hardcoded API keys from source code immediately
- Options:
  1. **Server-side proxy** (recommended): Route API calls through your own backend that holds keys
  2. **Encrypted configuration** with build-time injection via CI/CD environment variables
  3. **Keychain storage** with first-run server fetch
- Add `.gitignore` rules for any configuration files containing secrets
- Rotate all compromised keys that are currently in source control

### 23.2 Code-Level Security

- Replace all `fatalError` calls with proper error handling
- Replace all force-unwraps with `guard let` / `if let`
- Replace `try!` with `do-catch` blocks
- Validate all URL construction
- Implement certificate pinning for API connections
- Add App Transport Security exceptions review
- Implement jailbreak detection if handling financial data

### 23.3 Data Security

- Store premium status in Keychain (not UserDefaults, which is easily modifiable)
- Encrypt CoreData store using `NSPersistentStoreDescription.setOption(_:forKey:)` with `NSPersistentStoreFileProtectionKey`
- Remove the IAP shared secret from client code entirely
- Implement proper receipt validation server-side

---

## 24. Testing & CI/CD

### 24.1 Testing Infrastructure

**Current state:** Minimal to no tests (one misplaced test file found in Extensions directory).

**Recommendation:**
- Establish minimum 70% code coverage target
- Unit tests for all ViewModels, services, and business logic
- Integration tests for CoreData operations
- UI tests for critical flows (trading, subscription, onboarding)
- Snapshot tests for UI components
- Use XCTest with `async` test methods
- Mock all network calls using protocol abstractions

### 24.2 CI/CD Pipeline

- Set up GitHub Actions or Fastlane for automated builds
- Run tests on every PR
- Automated App Store Connect upload
- SwiftLint for code style enforcement
- Danger for PR review automation

---

## 25. Accessibility & Localization

### 25.1 Accessibility

**Current state:** No accessibility support observed.

**Recommendation:**
- Add `accessibilityLabel`, `accessibilityHint`, and `accessibilityTraits` to all interactive elements
- Support VoiceOver navigation through all screens
- Adopt Dynamic Type throughout (use `UIFont.preferredFont(forTextStyle:)`)
- Ensure sufficient color contrast ratios
- Support Bold Text, Reduce Motion, Increase Contrast settings
- Test with Accessibility Inspector and VoiceOver

### 25.2 Localization

- Extract all user-facing strings to `.strings` files
- Use `NSLocalizedString` (or `String(localized:)` in Swift 5.7+)
- Support right-to-left layouts
- Start with English, plan for Spanish, French, Chinese (per TAM from pitch deck)

---

## 26. Performance & Modern APIs

### 26.1 Performance Improvements

- Replace 15-second polling timer with push-based updates (WebSocket or Server-Sent Events)
- Implement batch API calls instead of per-stock individual requests
- Add prefetching for table view cells (`UITableViewDataSourcePrefetching`)
- Optimize CoreData fetches with proper predicates and fetch limits
- Use `NSFetchedResultsController` for real-time CoreData -> UI updates
- Profile with Instruments (Time Profiler, Allocations, Core Data)

### 26.2 Modern iOS APIs to Adopt

| API | Use Case |
|-----|----------|
| `WidgetKit` | Portfolio widget for home screen |
| `App Intents` | Siri shortcuts for checking portfolio |
| `ActivityKit` / Live Activities | Real-time stock price updates on Lock Screen |
| `BackgroundTasks` | Portfolio refresh in background |
| `UserNotifications` | Price alerts, competition updates |
| `CloudKit` | Cross-device portfolio sync |
| `PassKit` | Apple Pay for in-app purchases |
| `AuthenticationServices` | Sign in with Apple |
| `TipKit` | Feature discovery tips |

### 26.3 App Lifecycle

- Migrate from `@UIApplicationMain` to `@main` with `UIScene` lifecycle
- Implement `SceneDelegate` for multi-window support
- Support state restoration via `NSUserActivity`

---

# PART 3: NEW DESIGN VISION

## 27. Vision Overview: Paper Trading to Gamified Competition

### 27.1 The Transformation

The Figma designs and PDF documents (Features Guide + Pitch Deck) reveal a fundamental transformation of the Upful app:

| Dimension | Current App | New Vision |
|-----------|-------------|------------|
| **Identity** | Upful: Simple Paper Trading | Jyanik: Learn, Compete, Win |
| **Core Loop** | Trade virtual stocks, track performance | Compete against other traders for real cash prizes |
| **Monetization** | $6.99/month for premium features | $6.99/month entry to prize competitions + $2.99 IAP for additional virtual cash |
| **Social** | None (single-player) | Group chat, leaderboard, mentorship |
| **Engagement** | Self-motivated portfolio building | Daily/weekly/monthly competitions with cash prizes |
| **Navigation** | 4 tabs (Home, Explore, Saved, Settings) | 5 tabs (Home, Search, Favorites, Leaderboard/Charts, Profile/Settings) |
| **Onboarding** | Subscription prompt on first launch | Subscribe & Win with PayPal registration for prize payouts |

### 27.2 What It Achieves

1. **Gamification as Growth Engine:** Transforms passive portfolio tracking into an active competition platform. Daily/weekly/monthly prize pools ($15,103/month total) create recurring engagement loops that drive retention and subscription conversion.

2. **Social Network Effect:** The chat feature, leaderboard, and mentorship system create network effects where each additional user increases platform value for existing users.

3. **Revenue Diversification:** Moves from single subscription revenue to four streams: subscriptions ($6.99/month), group fees ($20), advertising, and in-app purchases ($2.99 for additional virtual cash).

4. **Market Expansion:** By targeting risk-averse populations (Gen-Z, millennials, lower income), the app addresses a $1.025B TAM across the US, Canada, UK, China, and Japan.

5. **Data Moat:** User trading behavior data creates a future revenue stream through machine learning insights for brokerage firms and independent brokers.

### 27.3 The Rebrand: Upful to Jyanik

The pitch deck presents a full rebrand from "Upful" to "Jyanik" with the tagline "Learn and compete with virtual money to win real money." The mission is "Democratization of Wealth Management."

---

## 28. New Screen-by-Screen Analysis

### 28.1 Subscribe & Win (Onboarding - 2 Steps)

**What it replaces:** Current `SubscriptionViewController` modal

**New flow:**
1. **Step 1 - Value Proposition:** Subscription pitch at $6.99/week with benefits listed: daily/weekly/monthly competitions, unlimited screeners, unlimited saves, platform growth
2. **Step 2 - Registration:** Username input, PayPal email (for prize payouts), T&Cs checkbox, Submit button

**What's new:**
- PayPal email collection (required for prize distribution)
- Username system (currently UUID-based anonymous)
- Explicit competition benefits framing (vs. current feature-gating pitch)
- Two-step onboarding flow

**Implementation requires:**
- User authentication system (username/password or Sign in with Apple)
- PayPal email storage and validation
- Server-side user registration endpoint
- T&Cs and Privacy Policy documents for competition/gambling compliance

---

### 28.2 Thank You (Post-Subscription Confirmation)

**What it replaces:** Currently no confirmation screen

**Design:** Thumbs-up graphic with "Thank You for Subscribing" message and "See Leaderboard" CTA

**Implementation:** Simple confirmation screen with navigation to leaderboard

---

### 28.3 $25,000 Welcome / Monthly Reset

**What it replaces:** Currently the starting balance is silently initialized

**Design:** Explicit screen showing "$25,000 virtual money" with two options:
1. "Build New Portfolio" - Fresh start with $25K
2. "Keep Old Portfolio" - Carry over current holdings

**What's new:**
- Monthly competition reset mechanic
- User choice on portfolio reset vs. continuation
- Competition cycle awareness

**Implementation requires:**
- Monthly reset scheduler (server-side cron job)
- Portfolio snapshot/archival before reset
- Two code paths: full reset ($25K fresh) vs. carry-over (keep positions, reset growth %)
- Competition period tracking in data model

---

### 28.4 Leaderboard

**Entirely new feature**

**Design:**
- Tabs: Top / Selected / Best time periods
- Ranked list with user avatars, portfolio values, percentage growth, prize amounts
- Two sub-tabs: "Subscribed" and "Free"
- Top 100 users per timeframe
- Time filters: Daily, Weekly, Monthly, Quarterly, 6-month

**What it achieves:**
- Creates competitive engagement loop
- Shows free users what they "could have won" (conversion tactic)
- Privacy-preserving (shows growth % and total value, not individual holdings)

**Implementation requires:**
- Server-side leaderboard calculation engine
- Real-time ranking across multiple time periods (5 different windows)
- User profile system with avatars
- Prize assignment logic per competition tier
- Efficient sorting/pagination for top-100 across potentially millions of users
- API endpoints: `GET /leaderboard?period=daily&tab=subscribed&page=1`

---

### 28.5 My History

**Entirely new feature**

**Design:**
- User's historic record of positions in each competition
- Time filters: Daily, Weekly, Monthly, Quarterly, 6-month
- Shows: rank position, percentage change, dollar value per day
- Two sub-tabs: Free and Subscribed

**Implementation requires:**
- Historical position snapshots stored per user per day
- Database schema for competition history
- Time-series data retrieval API

---

### 28.6 Updated Portfolio (Home)

**Modifies existing Home screen**

**Additions:**
- Current monthly competition position displayed (e.g., "#26")
- Messages icon (top right) -> Chat
- Notifications icon (top right) -> Notifications
- Notification badge showing competition positions

**Retained:** Total balance, cash balance, holdings list, equity breakdown, last updated timestamp

**Implementation requires:**
- Real-time competition position calculation
- Badge system for unread notifications
- Navigation routing to new Chat and Notifications screens

---

### 28.7 Notifications

**Entirely new feature**

**Design:**
- Prize notifications: "You won $100 for making most profit in Feb"
- Withdrawal notifications: "Selected for withdrawal"
- Time-filtered totals: Day, Week, Month, 3 months, 6 months
- Free user version shows "What you missed out on" (upsell)

**Implementation requires:**
- Push notification infrastructure (APNs)
- Prize calculation and distribution system
- Notification center/feed backend API
- Local notification storage and display
- Withdrawal processing integration (Stripe/PayPal)
- Free vs. paid notification content differentiation

---

### 28.8 Chat / Social Hub

**Entirely new feature (Premium only)**

**Design:**
- Group conversation with all platform traders
- Text messages and photo attachments
- 3-month chat history
- Ticker-based filtering (e.g., filter by "AAPL" mentions)

**Implementation requires:**
- Real-time messaging infrastructure (WebSocket, Firebase Realtime Database, or third-party like Stream/SendBird)
- Message persistence with 3-month retention policy
- Photo upload and CDN storage
- Ticker symbol detection and tagging in messages
- Filter/search by ticker
- Moderation system (content filtering, reporting)
- Premium gating middleware
- Scalable architecture for potentially millions of concurrent users

---

### 28.9 Screeners (Updated)

**Modifies existing screener screens**

**Design:** Largely unchanged with Pre-built/Custom tabs. Same categories visible: Money Makers, Grow Baby Grow, Dividend Growth, Software, etc.

**Implementation:** Minimal changes to existing screener infrastructure.

---

### 28.10 Profile

**Entirely new feature (replaces Settings partially)**

**Design:**
- User avatar/photo upload
- Username and email fields
- Available Screeners section with toggleable list
- Save Changes button

**Implementation requires:**
- User profile CRUD API
- Avatar upload with image processing
- Profile edit validation
- Screener preferences management

---

### 28.11 Portfolio Donut Chart (Enhanced)

**Modifies existing pie chart**

**Additions:**
- "Stocks You May Like" recommendation section below chart
- Each suggestion shows: ticker, market cap, P/E ratio, current price, percent change
- Add (+) button for quick stock addition

**Implementation requires:**
- Recommendation engine (could leverage existing preference-based suggestions)
- Enhanced UI below chart section

---

### 28.12 Out of Budget

**Entirely new feature**

**Design:**
- Modal triggered when portfolio drops below $10,000
- "You are now Out of budget" messaging
- Upsell: "Buy $25K Now" for $2.99

**Implementation requires:**
- Balance monitoring trigger at $10,000 threshold
- In-app purchase product for $2.99 virtual cash
- Balance top-up logic in TradingEngine
- Competition fairness rules (how does buying more cash affect rankings?)

---

### 28.13 Buy $25K (Payment)

**Entirely new feature**

**Design:**
- Card payment form: Card Number, MM/YY, CVV
- "Pay Now" button
- Alternative methods: Apple Pay, Google Pay, PayPal

**Implementation requires:**
- Payment processing integration (Stripe recommended per pitch deck)
- Apple Pay integration via PassKit
- Google Pay integration (if Android version planned)
- PCI compliance for card data handling
- StoreKit IAP as alternative to direct card processing
- Note: Apple's App Store guidelines may require using IAP instead of custom payment processing for digital goods

---

## 29. Business Model Transformation

### 29.1 Revenue Streams

| Stream | Current | New |
|--------|---------|-----|
| Subscription | $6.99/month (feature unlock) | $6.99/month (competition entry + features) |
| In-App Purchase | None | $2.99 for additional $25K virtual cash |
| Group Fees | None | $20 per group |
| Advertising | Disabled | Planned revenue stream |
| Data/AI | None | Future: ML insights for brokerage firms |
| Portfolio Sales | None | Future: curated portfolios from top performers |

### 29.2 Competition Prize Structure

**Monthly total payout: $15,103**

| Competition | Prize Range | Winners |
|-------------|------------|---------|
| Daily | $1-$5/person | Top 100 |
| Weekly | $2-$10/person | Top 100 |
| Monthly | $10-$2,000/person | Top 100 |

### 29.3 Financial Projections (from Pitch Deck)

| Metric | Year 1 | Years 2-3 |
|--------|--------|-----------|
| Revenue | $290,101 | $3,784,089 |
| Expenses | $637,939 | $1,907,598 |
| Net Income | -$347,838 | +$1,714,058 |
| Net Margin | -120% | +45% |
| Target Users | 260-2,000 | Scaling to 500K+ |

### 29.4 Fundraising

- Seed round: $555,000 (Marketing $158K, Salary $180K, Monthly Payout $136K, API/Cloud $29.5K, Accounting $60K, Legal $10K)
- Series A target: $5M at $24M valuation, requiring $200K/month revenue

---

## 30. Implementation Requirements

### 30.1 New Backend Infrastructure

The current app is largely client-side with Firebase as a lightweight backend. The new vision requires a proper backend:

| Component | Requirement |
|-----------|------------|
| **User Authentication** | Registration, login, profile management, password reset |
| **Leaderboard Engine** | Real-time ranking across 5 time periods for all users |
| **Competition Manager** | Monthly resets, prize calculations, winner determination |
| **Payment Processing** | Stripe integration for prize payouts, PayPal for user payouts |
| **Chat Infrastructure** | Real-time messaging, history, moderation, ticker filtering |
| **Notification Service** | Push notifications, in-app notification feed |
| **Prize Distribution** | Automated payout calculations and Stripe/PayPal transfers |
| **Admin Dashboard** | Competition management, user management, content moderation |

### 30.2 New Data Models Required

| Entity | Key Fields |
|--------|-----------|
| `UserAccount` | id, username, email, paypalEmail, avatarURL, subscriptionStatus, createdAt |
| `Competition` | id, type (daily/weekly/monthly), startDate, endDate, status |
| `CompetitionEntry` | userId, competitionId, startingBalance, endingBalance, growthPercent, rank |
| `LeaderboardSnapshot` | competitionId, period, rankings (JSON), calculatedAt |
| `Prize` | id, competitionId, userId, amount, status (pending/paid/failed) |
| `ChatMessage` | id, userId, content, imageURL, tickers[], timestamp |
| `Notification` | id, userId, type, title, body, amount, isRead, createdAt |
| `PayoutHistory` | userId, amount, method (paypal/stripe), status, processedAt |
| `MonthlyReset` | userId, month, choice (new/keep), previousBalance |

### 30.3 New API Endpoints Required

```
Authentication:
  POST   /auth/register
  POST   /auth/login
  POST   /auth/logout
  GET    /auth/profile
  PUT    /auth/profile

Leaderboard:
  GET    /leaderboard?period=daily|weekly|monthly|quarterly|6month&tab=subscribed|free&page=1
  GET    /leaderboard/my-history?period=daily
  GET    /leaderboard/my-position

Competitions:
  GET    /competitions/current
  POST   /competitions/reset (monthly reset choice)
  GET    /competitions/history

Chat:
  GET    /chat/messages?ticker=AAPL&before=timestamp&limit=50
  POST   /chat/messages
  POST   /chat/messages/{id}/report

Notifications:
  GET    /notifications?period=day|week|month
  PUT    /notifications/{id}/read

Payments:
  POST   /payments/purchase-cash ($2.99 IAP)
  GET    /payments/payout-history
  POST   /payments/request-withdrawal
```

### 30.4 Legal & Compliance Considerations

| Area | Requirement |
|------|------------|
| **Gambling Regulations** | Cash prize competitions may be classified as gambling in certain jurisdictions. Legal review required for US, Canada, UK, China, Japan markets. |
| **App Store Guidelines** | Apple prohibits real-money gambling apps without specific licensing. The "skill-based competition" classification needs careful legal positioning. |
| **Financial Regulations** | Even simulated trading with real payouts may trigger financial services regulations (SEC, FINRA in US, FCA in UK). |
| **Payment Processing** | PCI DSS compliance for card data. Money transmitter licenses may be required for prize payouts. |
| **Privacy (GDPR/CCPA)** | User data collection (PayPal, trading behavior) requires privacy policy updates, consent mechanisms, data deletion capabilities. |
| **Age Verification** | Financial competitions typically require 18+ age verification. |
| **Chat Moderation** | Real-time chat requires content moderation policies and CSAM reporting obligations. |

---

## 31. Technical Implementation Roadmap

### Phase 1: Foundation (Weeks 1-4)
- Clean up codebase: remove duplicates, fix corrupted files, resolve schema mismatches
- Security remediation: extract all hardcoded API keys
- Migrate to SPM from CocoaPods
- Set up CI/CD pipeline
- Establish testing infrastructure
- Begin async/await migration for networking layer

### Phase 2: Architecture (Weeks 5-8)
- Standardize MVVM + Coordinator architecture
- Implement dependency injection
- Consolidate CoreData into single model with proper schema
- Migrate balance from UserDefaults to CoreData
- Replace SwiftyStoreKit with StoreKit 2
- Set up backend infrastructure (authentication, API)

### Phase 3: Core New Features (Weeks 9-14)
- User registration and authentication system
- Profile screen (new)
- Leaderboard backend and UI
- Competition engine (daily/weekly/monthly)
- Monthly reset flow
- Updated Home screen with competition position and notification badges

### Phase 4: Social & Engagement (Weeks 15-20)
- Chat infrastructure and UI
- Notification system (push + in-app feed)
- My History screen
- Prize calculation and distribution system
- PayPal/Stripe payout integration

### Phase 5: Monetization & Polish (Weeks 21-24)
- Out of Budget trigger and $2.99 IAP
- Payment screen
- Enhanced portfolio donut with recommendations
- Subscription flow update (Subscribe & Win)
- Free vs. Paid experience differentiation (upsell messaging)

### Phase 6: Launch Preparation (Weeks 25-28)
- Legal compliance review
- Performance optimization and profiling
- Accessibility audit
- Beta testing program
- App Store submission preparation
- Marketing materials and rebrand assets

---

## Appendices

### A. File Structure Overview

```
upful-ios/
├── Upful/
│   ├── Supporting Files/
│   │   ├── AppDelegate.swift
│   │   ├── MainCoordinator.swift
│   │   └── Constants.swift
│   ├── Features/
│   │   ├── Home/ (23 files)
│   │   ├── Stock Detail/ (8+ files)
│   │   ├── Screener Selection/ (7 files)
│   │   ├── Search Results/ (3 files)
│   │   ├── SaveView/ (8 files)
│   │   ├── Subscription/ (5 files)
│   │   ├── Explore Feed/ (2 files)
│   │   ├── Stock Comparison/ (2 files)
│   │   ├── StockTrade/ (coordinator)
│   │   ├── New Group/ (StockTradeViewController - misnamed)
│   │   ├── Recommendations/ (1 file)
│   │   ├── Reports/ (2 files)
│   │   ├── Suggestions/ (2 files)
│   │   ├── Settings/ (1 file)
│   │   ├── Preferences/ (3 files)
│   │   ├── Splash Screen Module/ (1 file + storyboard)
│   │   ├── WebNavigation/ (1 file)
│   │   └── Archive/ (deprecated)
│   ├── Services/
│   │   ├── Intrinio/ (IntrinioAPI, StockSearchService)
│   │   ├── Quote Loader/ (QuoteLoader)
│   │   ├── Historical Price Loader/
│   │   ├── Stock Financial Loader/
│   │   ├── CompanyNameLoader/
│   │   ├── Payment/ (IAPService, UpfulProducts)
│   │   ├── Analytics/ (3 files)
│   │   ├── Permissions/ (PermissionManager)
│   │   ├── Background Tasks/ (corrupted)
│   │   ├── NetworkingService.swift
│   │   ├── FirestoreService.swift
│   │   ├── ColorManager.swift
│   │   └── Vibration.swift
│   ├── Custom APIs/
│   │   ├── Trading Engine/ (15+ files)
│   │   ├── Profile/ (UserProfile, ProfileSyncCoordinator)
│   │   ├── CompletionHandler.swift
│   │   └── Presenters/
│   ├── Models/ (6 files)
│   ├── Extensions/ (13 files)
│   └── Reusable Views/ (6+ files)
├── design/
│   ├── Upful Features Guide.pdf
│   ├── Jyanik Pitch Deck Feb 1.pdf
│   ├── screen-summary.txt
│   ├── figma-export-code.swift
│   └── *.png (Figma screenshots)
├── research/
│   ├── 01-architecture-analysis.txt
│   ├── 02-features-ui-analysis.txt
│   ├── 03-pdf-analysis.txt
│   └── 04-trading-data-analysis.txt
├── Podfile
├── StockDataModel.xcdatamodeld/
├── TransactionDataModel.xcdatamodeld/
└── TransactionLog.xcdatamodeld/ (legacy)
```

### B. API Key Locations (for Security Remediation)

| Key | Location | Type |
|-----|----------|------|
| Intrinio API Key | `Constants.swift` | Financial data |
| IEX Cloud Production Token | `Constants.swift` | Market data |
| IEX Cloud Sandbox Token | `Constants.swift` | Market data (test) |
| IEX Cloud Key (duplicate) | `StockDescriptionLoader.swift` (hardcoded in URL) | Market data |
| Mixpanel Token | `Constants.swift` | Analytics |
| Stock News API Token | `Constants.swift` | News data |
| IAP Shared Secret | `IAPService.swift` | Receipt validation |
| Firebase Config | `GoogleService-Info.plist` | Firebase services |

### C. Feature Comparison: Current vs. New Design

| Feature | Current | New Design | Status |
|---------|---------|------------|--------|
| Portfolio Dashboard | Yes | Enhanced (competition position, badges) | Modify |
| Stock Detail | Yes | Unchanged | Keep |
| Screener (Prebuilt) | Yes | Unchanged | Keep |
| Screener (Manual) | Yes | Unchanged | Keep |
| Search Results | Yes | Unchanged | Keep |
| Saved Stocks/Screeners | Yes | Unchanged | Keep |
| Explore/Discovery | Yes | Unchanged | Keep |
| Stock Comparison | Yes | Unchanged | Keep |
| Stock Trade | Yes | Unchanged | Keep |
| Subscription | Yes | Redesigned (Subscribe & Win) | Rebuild |
| Settings | Yes | Partially replaced by Profile | Modify |
| Preferences | Yes | Moved under Profile | Move |
| NPS Survey | Yes | TBD | Evaluate |
| Suggestions Feed | Yes | TBD | Evaluate |
| Leaderboard | No | New | Build |
| My History | No | New | Build |
| Chat | No | New | Build |
| Notifications | No | New | Build |
| Profile | No | New | Build |
| Monthly Reset | No | New | Build |
| Out of Budget | No | New | Build |
| Payment ($2.99) | No | New | Build |
| Thank You Screen | No | New | Build |
| $25K Welcome | No | New | Build |

---

*Document compiled from 4 parallel research analyses totaling 2,420 lines across architecture, features/UI, PDF documents, and trading engine/data layer investigations.*
