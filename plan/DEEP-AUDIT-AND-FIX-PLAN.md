# Deep Audit & Fix Plan
## Upful iOS App - Complete Gap Analysis & Fix Plan
### Date: 2026-02-13

---

## Executive Summary

After deep analysis of the entire codebase (119 Swift files, 26 backend files), the original prod branch app, design folder, and all research/planning docs, this document identifies every gap between what was designed/requested and what currently exists.

**Key Findings:**
- **Trading from Stock Detail = "Coming Soon" placeholder** (CRITICAL - original app had full trading)
- **Search returns no results** (backend field name mismatch: `ticker` vs `symbol`)
- **Competition shows nothing for guests** (no mock data, no stats viewable without joining)
- **No way to login as seeded test users** (auth flow doesn't connect to running backend properly)
- **Original app's local trading engine was fully removed** with no equivalent offline capability
- **Design shows 5 tabs** (Home, Search, Heart/Favorites, Chart, Settings) but **app has 5 different tabs** (Home, Markets, Trade, Compete, Profile)

---

## CRITICAL Issues (App Broken)

### 1. StockDetailView Buy/Sell Shows "Coming Soon" Placeholder
**File:** `Jyanik/Features/Markets/StockDetailView.swift:358-392`
**Problem:** When user taps Buy/Sell from a stock detail page, a `TradeSheetPlaceholder` is shown instead of the actual `TradeView`. Line 374: `Text("Trading functionality coming soon")`.
**Root Cause:** The StockDetailView was built in Phase 3 before TradeView existed (Phase 4). It was never updated to use the real TradeView.
**Impact:** Users cannot trade from stock detail — the primary trading flow from browsing stocks.
**Fix:** Replace `TradeSheetPlaceholder` with actual `TradeView` initialized with the selected ticker and side.

```swift
// REPLACE line 47:
.sheet(item: $tradeSheet) { item in
    TradeSheetPlaceholder(ticker: item.ticker, side: item.side)
}
// WITH:
.sheet(item: $tradeSheet) { item in
    NavigationStack {
        TradeView(initialTicker: item.ticker, initialSide: item.side)
    }
}
```

**Also needed:** TradeView needs an init that accepts `initialTicker` and `initialSide` parameters. Currently TradeViewModel already has these in its init — just need to expose them from TradeView.

---

### 2. Search Returns No Results (Field Name Mismatch)
**Files:**
- Backend: `backend/src/services/market-data/yahoo-finance.ts:152-157`
- iOS: `Jyanik/Core/Models/DTOs/MarketDataDTOs.swift:13-21`

**Problem:** Backend search returns objects with field `ticker`, but iOS `SearchResultDTO` expects field `symbol`.

**Backend returns:**
```json
{ "results": [{ "ticker": "AAPL", "name": "Apple Inc.", "type": "EQUITY", "exchange": "NASDAQ" }] }
```

**iOS expects:**
```swift
struct SearchResultDTO: Decodable {
    let symbol: String  // ← expects "symbol" key
    let name: String
    let exchange: String?
    let type: String?
    let score: Double?
}
```

**Fix (Option A - Fix backend, preferred):** Change `yahoo-finance.ts` line 152 from `ticker:` to `symbol:`:
```typescript
return data.quotes.map((quote) => ({
    symbol: quote.symbol,  // was "ticker"
    name: quote.longname || quote.shortname || quote.symbol,
    type: quote.quoteType || 'EQUITY',
    exchange: quote.exchDisp || 'Unknown',
}));
```

**Fix (Option B - Fix iOS):** Add CodingKeys to SearchResultDTO:
```swift
struct SearchResultDTO: Decodable, Identifiable {
    let symbol: String
    let name: String
    let exchange: String?
    let type: String?
    let score: Double?

    var id: String { symbol }

    enum CodingKeys: String, CodingKey {
        case symbol = "ticker"
        case name, exchange, type, score
    }
}
```

---

### 3. Cannot Login as Seeded Test Users
**Problem:** The seed migration (`backend/src/migrations/0007_seed_data.sql`) creates 30 users with bcrypt-hashed passwords, but:
- Users don't know the password for seeded accounts
- Guest mode bypasses auth entirely — no way to test authenticated features
- The auth flow requires backend to be running locally

**Seeded user passwords:** All seeded users have password hash `$2a$10$...` but the actual plaintext password is unknown.

**Fix:**
1. Document the test user credentials (re-seed with known password like `Test1234!`)
2. Add a "Dev Login" button in debug builds that auto-fills a test user
3. Update seed migration to use a documented password

---

### 4. Guest Mode Shows Empty Everything
**Problem:** When in guest mode, CompeteView (line 43-45), HomeView, MarketsView, etc. skip API calls but show empty/loading states with no mock data. User sees:
- Empty competitions list
- Empty portfolio/holdings
- No trending stocks
- Cannot see competition stats at all

**Fix:** Add mock/sample data for guest mode in each ViewModel:
- `HomeViewModel`: Sample portfolio with 5 holdings, trending stocks
- `CompeteViewModel`: Sample weekly/monthly competitions with sample leaderboard
- `MarketsViewModel`: Sample market movers, trending stocks
- `TradeViewModel`: Sample portfolio with $25,000 cash balance
- `LeaderboardViewModel`: Sample leaderboard with 10 entries

---

## HIGH Priority Issues

### 5. Competition Design Gap: Free vs Subscribed Not Implemented
**Design spec (from screen-summary.txt & pitch deck):**
- **Free users:** Compete in free competitions, win virtual money (extra paper money)
- **Subscribed users ($6.99/week):** Compete in premium competitions, win real cash prizes
- **Both users:** Can VIEW stats for both competition types

**Current implementation:**
- `CompeteView` shows one flat list with no free/subscribed distinction
- `CompetitionDTO` has no `isPremium`/`competitionTier` field
- No visual distinction between free and premium competitions
- Feature gating exists (`FeatureGateView`) but not connected to competitions
- Users can't view stats without joining

**Fix:**
- Add `tier: "free" | "premium"` field to CompetitionDTO and backend competition model
- Split CompeteView into sections: "Free Competitions" and "Premium Competitions"
- Show lock icon on premium competitions for free users
- Allow all users to VIEW competition stats/leaderboard (tap to see, not just join)
- Only gate JOINING premium competitions behind subscription
- Add a CompetitionDetailView that shows full stats, leaderboard, rules

### 6. No Competition Detail/Stats View
**Design spec:** Leaderboard screen with tabs (Top/Selected/Best), user history
**Current:** `CompeteView` shows cards but tapping navigates to `Route.competitionDetail(id:)` which likely has no destination view.

**Fix:** Create `CompetitionDetailView` with:
- Competition info header (name, dates, prize pool, participants)
- Leaderboard tab (ranked list of participants)
- Your rank/performance section
- Rules and prizes breakdown
- Join/Leave button

### 7. No History Screen
**Design spec (screen 6):** "My History" with tabs Selected/Best showing past ranking history
**Current:** No history view exists anywhere.

**Fix:** Create `CompetitionHistoryView` showing:
- Past competitions the user participated in
- Rank achieved in each
- Performance metrics over time

### 8. Missing Chat Feature
**Design spec (screen 9):** Chat screen with stock ticker, real-time messages
**Current:** Backend has `chat.ts` route but iOS has no ChatView.
**Backend status:** `chat.ts` likely has basic routes but no WebSocket implementation.

**Fix:** Lower priority — can be Phase 2 post-launch.

### 9. Portfolio Donut Chart Missing
**Design spec (screen 12):** Visual donut chart showing portfolio allocation with color-coded segments
**Current:** HomeView shows holdings as a list, no pie/donut chart visualization.

**Fix:** Add a portfolio breakdown donut chart component to HomeView.

### 10. "Stocks You May Like" / Recommendations Missing
**Design spec (screen 12):** Below donut chart, shows recommended stocks
**Original app:** Had `SuggestionFeedViewController`, `RecommendationViewController`
**Current:** No recommendation/suggestion feature.

**Fix:** Add a recommendations section to HomeView using market data service.

---

## MEDIUM Priority Issues

### 11. Tab Bar Mismatch with Design
**Design:** Home, Search, Heart/Favorites, Chart, Settings
**Current:** Home, Markets, Trade, Compete, Profile

**Assessment:** The current tabs are arguably better for the app's purpose (paper trading competition). The design tabs may have been an earlier iteration. **Keep current tabs** but ensure all design features are accessible within them.

### 12. Out of Budget Flow Not Triggered
**Design spec (screen 13):** Modal when user runs out of $25K budget with upsell to buy more
**Current:** `OutOfBudgetView` exists but is never presented. No logic detects when cash balance hits $0.

**Fix:** Add balance check after each trade in TradeViewModel — if cash < threshold, show OutOfBudgetView.

### 13. Monthly Reset Flow Not Connected
**Design spec (screen 4):** "New month starts with 25K virtual money" — Build New Portfolio or Keep Old Ratios
**Current:** `MonthlyResetView` and `MonthlyResetViewModel` exist but are never triggered.

**Fix:** Add monthly reset detection logic to AppState or HomeViewModel.

### 14. Backend Response Shape Mismatches
Several backend routes return shapes that don't match iOS DTOs:

| Endpoint | Backend Returns | iOS Expects | Issue |
|----------|----------------|-------------|-------|
| `/market/search` | `{ results: [{ticker, ...}] }` | `{ results: [{symbol, ...}] }` | `ticker` vs `symbol` |
| `/market/quote/:symbol` | Flat object | Direct decode | Needs verification |
| `/market/chart/:symbol` | `{ symbol, range, data: [...] }` | ChartResponseDTO | Needs verification |
| `/market/news` | `{ news: [] }` | `{ news: [...] }` | Always empty (placeholder) |

### 15. News Always Empty
**Backend:** `market.ts` line 155-157 — news endpoint returns empty array (placeholder)
**Fix:** Integrate a free news API (e.g., NewsAPI.org, Alpha Vantage news, or Finnhub news)

### 16. Screener Returns "Coming Soon"
**Backend:** `market.ts` line 191 — screener endpoint returns `{ message: 'Screener coming soon' }`
**Original app:** Had full screener with prebuilt and custom screeners
**Fix:** Build screener logic using market data from D1 or external API

---

## Backend Issues

### 17. Placeholder Database IDs
**File:** `backend/wrangler.toml` — All D1/KV/R2 IDs are `"placeholder-replace-after-creation"`
**Impact:** Backend won't work with remote Cloudflare — only works locally with `wrangler dev`

### 18. Queue/Cron Handlers Are Stubs
**File:** `backend/src/index.ts:104-181`
- Queue consumer: All message types are TODO stubs
- Cron triggers: All are TODO stubs (leaderboard refresh, competition roll, portfolio snapshot)

### 19. Missing Backend Services
- Email (Resend): Not implemented — password reset, notifications won't send
- Push notifications (APNs): Not implemented
- Leaderboard calculation: Not implemented
- Payout processing: Not implemented
- Portfolio snapshots: Not implemented

---

## Original App Features Missing in New App

| Original Feature | Original File | New App Status |
|-----------------|---------------|----------------|
| **Local Trading Engine** | `TradingEngine.swift` (CoreData, buy/sell/validate) | Replaced with API-based trading (requires backend) |
| **Stock Search** | `StockSearchViewController.swift` (Intrinio API) | API-based (Yahoo Finance) but field name bug |
| **Balance Manager** | `BalanceManager.swift` (UserDefaults) | API-based only — no offline |
| **Transaction Ledger** | `LedgerManager.swift` (CoreData) | Backend D1 only — no local storage |
| **Holdings Mapper** | `HoldingMapper.swift` | Backend returns positions |
| **Stock Screening** | Full screener flow (5+ controllers) | Placeholder "coming soon" |
| **Stock Suggestions** | `SuggestionFeedViewController.swift` | Not implemented |
| **Stock Comparison** | `StockComparisonViewController.swift` | `ComparisonView` exists but API-dependent |
| **Saved Stocks/Screeners** | CoreData-based `SavedStocksViewController` | `SavedView` exists but API-dependent |
| **Subscription/IAP** | `IAPService.swift`, `SubscriptionViewController` | `SubscriptionView` + StoreKit 2 exists |
| **Analytics** | `AnalyticsEvents.swift`, Mixpanel | Not yet integrated |
| **Deep Link** | `UpfulDeepLinkManager.swift` | Not implemented |
| **Background Refresh** | `BackgroundRefreshManager.swift` | Not implemented |
| **Pie Chart** | `PieChartView.swift` (Holdings breakdown) | Not implemented |
| **News/Sentiment** | `SentimentView.swift`, `NewsLogicController` | Backend returns empty array |
| **Preferences/Onboarding** | Full preference selection flow | Simplified onboarding |

---

## Fix Priority Order

### Phase A: Critical Fixes (Do First)
1. **Fix StockDetailView trade placeholder** → Replace with real TradeView (30 min)
2. **Fix search field name mismatch** → Backend `ticker` → `symbol` (5 min)
3. **Add guest mode mock data** to all ViewModels (2 hrs)
4. **Fix test user login** → Known password in seed data + dev login button (1 hr)

### Phase B: Competition Overhaul
5. **Add free/premium competition tiers** to backend + iOS
6. **Create CompetitionDetailView** with stats, leaderboard, rules
7. **Allow viewing stats without joining** — separate view from join action
8. **Create CompetitionHistoryView** — past results

### Phase C: Missing Features
9. **Portfolio donut chart** component
10. **Stock recommendations** section in HomeView
11. **Monthly reset detection** and trigger
12. **Out of budget detection** and modal trigger
13. **News API integration** (replace placeholder)
14. **Screener API integration** (replace placeholder)

### Phase D: Backend Completion
15. **Leaderboard calculation** cron implementation
16. **Competition roll** (daily/weekly/monthly) cron implementation
17. **Portfolio snapshots** cron implementation
18. **Email integration** (Resend) for notifications

### Phase E: Polish
19. **Analytics integration** (Mixpanel/PostHog)
20. **Deep linking** support
21. **Background refresh** for portfolio updates
22. **Chat feature** (WebSocket)

---

## Immediate Action Items

### Fix 1: StockDetailView — Replace Trade Placeholder with Real TradeView
```
File: Jyanik/Features/Markets/StockDetailView.swift
- Remove TradeSheetPlaceholder struct (lines 358-392)
- Update sheet presentation to use TradeView
- Add TradeView init parameters for ticker and side
File: Jyanik/Features/Trade/TradeView.swift
- Add convenience init accepting initialTicker and initialSide
```

### Fix 2: Search Field Name — Backend ticker → symbol
```
File: backend/src/services/market-data/yahoo-finance.ts
- Line 152: Change "ticker:" to "symbol:"
```

### Fix 3: Guest Mode Mock Data
```
Files: All ViewModels
- HomeViewModel: Add loadGuestData() with sample portfolio
- CompeteViewModel: Add loadGuestData() with sample competitions
- MarketsViewModel: Add loadGuestData() with sample market data
- TradeViewModel: Set guest cash balance to $25,000
- LeaderboardViewModel: Add sample entries
```

### Fix 4: Test User Login
```
File: backend/src/migrations/0007_seed_data.sql
- Update seed with documented password (e.g., "TestUser123!")
File: Jyanik/Features/Auth/LoginView.swift
- Add #if DEBUG dev login shortcut
```
