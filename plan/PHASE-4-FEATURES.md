# Phase 4: Core New Features (Weeks 11-16)

**Status:** IN PROGRESS (Next up)
**Duration:** Weeks 11-16

---

## 4.1 Onboarding
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

## 4.2 Home Screen (Enhanced Portfolio)
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

## 4.3 Leaderboard
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

## 4.4 My History
- [ ] 4.4.1 Create Features/Leaderboard/Views/MyHistoryView.swift
- [ ] 4.4.2 Create Features/Leaderboard/Views/HistoryDayRow.swift
- [ ] 4.4.3 Create Features/Leaderboard/ViewModels/HistoryViewModel.swift
- [ ] 4.4.4 Implement time period filtering
- [ ] 4.4.5 Implement Free/Subscribed tabs
- [ ] 4.4.6 **COMMIT**: "feat: implement my history"

## 4.5 Chat
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

## 4.6 Notifications
- [ ] 4.6.1 Create Features/Notifications/Views/NotificationsView.swift
- [ ] 4.6.2 Create Features/Notifications/Views/NotificationRowView.swift
- [ ] 4.6.3 Create Features/Notifications/ViewModels/NotificationsViewModel.swift
- [ ] 4.6.4 Implement notification feed with time grouping
- [ ] 4.6.5 Implement time period totals
- [ ] 4.6.6 Implement "What you missed" for free users
- [ ] 4.6.7 Implement push notification handling
- [ ] 4.6.8 Implement mark as read
- [ ] 4.6.9 **COMMIT**: "feat: implement notifications"

## 4.7 Profile
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

## 4.8 Out of Budget & Virtual Cash
- [ ] 4.8.1 Create Features/Trading/Views/OutOfBudgetView.swift (modal)
- [ ] 4.8.2 Create Features/Trading/Views/BuyVirtualCashView.swift
- [ ] 4.8.3 Implement balance monitoring ($10K threshold)
- [ ] 4.8.4 Implement $2.99 IAP purchase flow
- [ ] 4.8.5 Implement balance top-up after purchase
- [ ] 4.8.6 **COMMIT**: "feat: implement out of budget and virtual cash purchase"

## 4.9 Monthly Reset
- [ ] 4.9.1 Create Features/Competition/Views/MonthlyResetView.swift
- [ ] 4.9.2 Create Features/Competition/ViewModels/ResetViewModel.swift
- [ ] 4.9.3 Implement choice: "Build New Portfolio" vs "Keep Old Portfolio"
- [ ] 4.9.4 Implement portfolio reset logic
- [ ] 4.9.5 Implement growth % reset
- [ ] 4.9.6 **COMMIT**: "feat: implement monthly competition reset"
- [ ] 4.9.7 **PUSH all Phase 4 commits**
