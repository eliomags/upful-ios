# UX Alignment Plan: Restore Original App Experience

## Goal
Align the Jyanik rebuild with the original Upful app's UX patterns while keeping the new architecture (SwiftUI, backend API, competitions). The rebuild added competitions/leaderboard as new features — those stay. But the core experience (auth flow, Home as portfolio, functional actions) must match the original.

---

## Priority Order

### Phase 1: Fix Onboarding/Auth Flow (CRITICAL)
**Problem:** User is forced through 3-step onboarding before seeing the app. Login is buried.

**Plan:**
1. **Redesign OnboardingView** — Show Login + Create Account buttons **on the first screen** alongside Get Started
   - First screen: Logo + tagline + **"Sign In"** button + **"Create Account"** button + "Continue as Guest" link
   - Remove the 3-step forced funnel (Welcome -> Features -> Auth)
   - Feature highlights can be shown AFTER first login as a one-time tooltip/overlay, not as a gate
2. **Update RootView** logic:
   - If user has stored tokens -> go directly to MainTabView (already works)
   - If no tokens -> show simplified OnboardingView with Login/Register/Guest options on ONE screen
3. **Keep the splash animation** simple: Show "Upful" logo briefly (like original's animated text reveal), then transition

**Files to modify:**
- `Jyanik/Features/Onboarding/OnboardingView.swift` — Redesign to single screen with auth options
- `Jyanik/App/RootView.swift` — Keep as-is (routing logic is correct)

---

### Phase 2: Rebuild Home as Portfolio Screen (CRITICAL)
**Problem:** Home is a generic dashboard instead of the user's actual portfolio.

**Plan:**
1. **Restructure HomeView sections** to match original:
   - **Header**: Total Balance (large), Dollar + Percent return, Last Updated timestamp, Cash Balance card
   - **Section 1: "Holdings"** — Full list of all positions (not just "Top Movers")
     - Each row: Ticker, # shares, current price, avg cost, $ change, % change (colored)
     - Section header with "See All" -> full transaction history
     - Empty state when no holdings
     - Tapping a holding -> navigate to stock detail
   - **Section 2: "Competitions"** (NEW — keep this from rebuild, it's a good addition)
     - Active competition cards with ranking
   - **Section 3: "Recent Activity"** — Last few trades
2. **Remove non-functional quick action buttons** (Buy, Sell, Watchlist, Search with empty closures)
   - Replace with actual navigation or remove entirely
3. **Remove hardcoded guest data** — Guest mode should show empty portfolio with "Start Trading" CTA
4. **Add pull-to-refresh** (already exists but verify it works)
5. **Portfolio header should be prominent** — Like original's TradingBalanceView

**Files to modify:**
- `Jyanik/Features/Home/HomeView.swift` — Major restructure
- `Jyanik/Features/Home/HomeViewModel.swift` — Remove hardcoded guest data, ensure all data from API

---

### Phase 3: Make Quick Actions Functional (HIGH)
**Problem:** Buy, Sell, Watchlist, Search buttons do nothing.

**Plan:**
1. **Buy** -> Navigate to Trade tab with buy mode: `router.navigate(to: .trade, in: .trade)` or use router to switch tab
2. **Sell** -> Navigate to Trade tab with sell mode (show positions list)
3. **Watchlist** -> Navigate to Saved tab (or show saved stocks inline)
4. **Search** -> Navigate to Markets tab with search focused
5. **Holdings tap** -> Navigate to stock detail: `router.navigate(to: .stockDetail(ticker: position.ticker))`
6. **Holdings long-press** -> Context menu with View/Trade options (like original)

**Files to modify:**
- `Jyanik/Features/Home/HomeView.swift` — Wire up action closures with router navigation

---

### Phase 4: Add Holdings Detail & Transaction History (MEDIUM)
**Problem:** No way to see full transaction history, holdings are just a subset.

**Plan:**
1. **Show ALL positions in Holdings section** (not just top 5 movers)
2. **Add "See History" header action** -> push to TransactionHistoryView
3. **Create TransactionHistoryView** — Full paginated list of all trades
   - Uses existing `portfolioService.fetchTransactions()` with pagination
   - Filter by ticker, side (buy/sell), date range
4. **Holdings rows should be interactive**:
   - Tap -> Stock detail
   - Context menu (long press) -> View Detail, Trade, (Sell All if applicable)

**Files to create:**
- `Jyanik/Features/Home/TransactionHistoryView.swift`
- `Jyanik/Features/Home/TransactionHistoryViewModel.swift`

**Files to modify:**
- `Jyanik/Features/Home/HomeView.swift` — Replace "Top Movers" with full holdings + "See History"
- `Jyanik/Core/Navigation/Route.swift` — Add `.transactionHistory` route if needed

---

### Phase 5: Portfolio Breakdown Visualization (LOW)
**Problem:** No pie chart showing portfolio allocation.

**Plan:**
1. Add a simple SwiftUI pie/donut chart showing allocation by ticker
2. Show when holdings exist, collapsible like original's breakdown section
3. Use Swift Charts framework (iOS 16+)

**Files to create:**
- `Jyanik/Features/Home/PortfolioBreakdownView.swift`

---

### Phase 6: Clean Up Guest Mode (MEDIUM)
**Problem:** Guest mode shows hardcoded fake portfolio data.

**Plan:**
1. Guest mode should show **empty state** portfolio with CTAs to sign up
2. Remove all hardcoded `PositionDTO`, `CompetitionDTO` from `HomeViewModel.loadGuestData()`
3. Guest can browse Markets and see leaderboards but not trade or have a portfolio
4. Show "Sign up to start trading" prompts where needed

**Files to modify:**
- `Jyanik/Features/Home/HomeViewModel.swift` — Remove `loadGuestData()` hardcoded data
- `Jyanik/Features/Home/HomeView.swift` — Add guest empty states
- `Jyanik/Features/Trade/TradeView.swift` — Show signup prompt for guests

---

## Implementation Notes

- **Keep the 5-tab structure** — Compete tab is a valuable addition not in original
- **Keep the J-Design System** — It's well-structured and consistent
- **Keep the backend architecture** — Cloudflare Workers + D1 is the right approach
- **Keep the competition features** — Leaderboard, My History, Competition Detail are new valuable features
- **All data must come from DB** — No hardcoded data anywhere
- **Follow existing patterns** — @Observable, DTO pattern, .convertFromSnakeCase decoder

## Priority Summary

| Phase | Priority | Effort | Impact |
|-------|----------|--------|--------|
| 1. Fix Auth/Onboarding | CRITICAL | Small | Huge — removes friction |
| 2. Home as Portfolio | CRITICAL | Medium | Huge — core feature restored |
| 3. Functional Actions | HIGH | Small | High — buttons actually work |
| 4. Transaction History | MEDIUM | Medium | Medium — missing feature |
| 5. Portfolio Breakdown | LOW | Small | Low — nice to have |
| 6. Clean Guest Mode | MEDIUM | Small | Medium — no fake data |

---

## Date: 2026-02-24
## Branch: feature/jyanik-rebuild
