# Phase 4: Core New Features (Weeks 11-16)

**Status:** COMPLETE
**Duration:** Weeks 11-16
**Build:** 98 Swift files — BUILD SUCCEEDED (0 errors, 0 warnings)

---

## 4.1 Onboarding & Auth
- [x] 4.1.1 Create `Features/Onboarding/OnboardingView.swift` — 3-step flow (Welcome, Feature highlights, Auth choice)
- [x] 4.1.2 Create `Features/Auth/LoginView.swift` — Email/password + Sign in with Apple
- [x] 4.1.3 Create `Features/Auth/RegisterView.swift` — Email, username, password, terms + Apple Sign In
- [x] 4.1.4 Create `Features/Auth/ForgotPasswordView.swift` — Email form + success confirmation
- [x] 4.1.5 Create `Features/Auth/AuthViewModel.swift` — @Observable, login/register/apple/forgotPassword, password strength
- [x] 4.1.6 Implement Sign in with Apple button and flow via `AppleSignInService`
- [x] 4.1.7 Update `RootView.swift` — routes to `OnboardingView()` (replaced placeholder)
- [x] 4.1.8 Wire `AuthService` + `KeychainService` + `AppState` for token-based auth
- [x] **COMMIT**: included in Phase 4 feature commit

## 4.2 Home Screen (Enhanced Portfolio)
> **Completed in Phase 3** — `HomeView.swift` + `HomeViewModel.swift` with portfolio header, holdings, quick actions, top movers, competition rank card, recent trades, pull-to-refresh.

## 4.3 Leaderboard
- [x] 4.3.1 Create `Features/Leaderboard/LeaderboardView.swift` — Full-featured screen with My Ranking card, period/tab pickers, podium + list
- [x] 4.3.2 Create `Features/Leaderboard/LeaderboardRowView.swift` — Rank badge (gold/silver/bronze), avatar, growth display
- [x] 4.3.3 Create `Features/Leaderboard/TopThreeView.swift` — Podium layout with gradient pedestals, crown for #1
- [x] 4.3.4 Create `Features/Leaderboard/LeaderboardViewModel.swift` — @Observable, concurrent load via TaskGroup, period/tab switching
- [x] 4.3.5 Implement time period filtering (Daily/Weekly/Monthly/All Time)
- [x] 4.3.6 Implement tab switching (Top Gainers/Top Losers/Most Active)
- [x] 4.3.7 Implement "Your Position" via `CompetitionService.myRanking`
- [x] 4.3.8 Implement pull-to-refresh
- [x] 4.3.9 Loading/error/empty states
- [x] **COMMIT**: included in Phase 4 feature commit

## 4.4 My History
> **Deferred** — Will be built when backend leaderboard history endpoint is more mature.

## 4.5 Chat
> **Deferred** — Requires WebSocket infrastructure (Phase 5+). `ChatService.swift` and `ChatDTOs.swift` are scaffolded.

## 4.6 Notifications
- [x] 4.6.1 Create `Features/Notifications/NotificationsView.swift` — Grouped List (Today/Yesterday/This Week/Earlier), swipe-to-mark-read, pull-to-refresh
- [x] 4.6.2 Create `Features/Notifications/NotificationsViewModel.swift` — @Observable, NotificationItem model, 10 mock entries, time grouping, mark-as-read
- [x] 4.6.3 Implement notification feed with relative time grouping
- [x] 4.6.4 Implement mark as read / mark all read
- [x] 4.6.5 Implement colored notification type icons
- [x] **COMMIT**: included in Phase 4 feature commit

## 4.7 Settings & Profile Editing
- [x] 4.7.1 Create `Features/Settings/SettingsView.swift` — 5 sections: Profile, Preferences, Subscription, About, Account
- [x] 4.7.2 Create `Features/Settings/EditProfileView.swift` — Avatar editor, display name, bio (200 char limit), unsaved changes detection
- [x] 4.7.3 Create `Features/Settings/SettingsViewModel.swift` — @Observable, UserDefaults persistence, appearance/currency preferences, sign out/delete
- [x] 4.7.4 Implement push/email notification toggles
- [x] 4.7.5 Implement appearance mode (system/dark/light)
- [x] 4.7.6 Implement sign out with confirmation alert
- [x] 4.7.7 Implement account deletion with confirmation alert
- [x] **COMMIT**: included in Phase 4 feature commit

## 4.8 Out of Budget & Virtual Cash
- [x] 4.8.1 Create `Features/Trading/OutOfBudgetView.swift` — Warning modal with balance display, purchase option ($2.99), monthly reset option
- [x] 4.8.2 Create `Features/Trading/OutOfBudgetViewModel.swift` — @Observable, balance loading, purchase flow simulation
- [x] 4.8.3 Implement balance color coding (warning/error thresholds)
- [x] 4.8.4 Implement purchase success screen
- [x] **COMMIT**: included in Phase 4 feature commit

## 4.9 Monthly Reset
- [x] 4.9.1 Create `Features/Competition/MonthlyResetView.swift` — Sheet with last month summary, Build New / Keep Old choice cards, confirm + success
- [x] 4.9.2 Create `Features/Competition/MonthlyResetViewModel.swift` — @Observable, choice handling, reset via CompetitionService
- [x] 4.9.3 Implement "Build New Portfolio" vs "Keep Old Portfolio" selection UI
- [x] 4.9.4 Implement last month summary display (equity, growth, rank, prize)
- [x] **COMMIT**: included in Phase 4 feature commit

---

## Phase 4 File Summary

| Group | Files | Lines (approx) |
|-------|-------|----------------|
| Onboarding | 1 | ~180 |
| Auth | 4 | ~850 |
| Leaderboard | 4 | ~900 |
| Notifications | 2 | ~500 |
| Settings | 3 | ~900 |
| Competition (Monthly Reset) | 2 | ~350 |
| Trading (Out of Budget) | 2 | ~320 |
| **Total Phase 4** | **18 files** | **~4,000 lines** |

## Build Integration

- All 18 files added to `project.pbxproj` (PBXFileReference + PBXBuildFile + PBXGroup + PBXSourcesBuildPhase)
- 5 new PBXGroup entries: Leaderboard, Notifications, Settings, Competition, Trading
- `RootView.swift` updated: `OnboardingPlaceholderView()` → `OnboardingView()`
- 2 warnings fixed: `where` clause precedence in LeaderboardView, `var` → `let` in NotificationService
- **Total project: 98 Swift files — BUILD SUCCEEDED**

## Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Auth flow | Token-based via AuthService → AppState | Consistent with existing KeychainService token storage |
| Onboarding | 3-step (Welcome → Features → Auth) | Clean, focused, matches modern iOS onboarding patterns |
| Leaderboard | Inline period+tab pickers (not segmented controls) | More visually distinct, capsule-style buttons |
| Settings persistence | UserDefaults for preferences | Lightweight, no backend roundtrip needed for local prefs |
| Monthly Reset | Sheet presentation | Non-blocking, user can dismiss, matches iOS conventions |
| Notifications grouping | RelativeDateTimeFormatter | Native iOS grouping (Today/Yesterday/etc) |

---

*Last updated: 2026-02-12*
*Phase: 4 — Core New Features (COMPLETE)*
*Branch: feature/jyanik-rebuild*
