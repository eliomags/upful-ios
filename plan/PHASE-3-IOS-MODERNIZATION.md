# Phase 3: iOS App Modernization (Weeks 7-10)

**Status:** PENDING
**Duration:** Weeks 7-10

---

## 3.1 SwiftUI App Entry
- [ ] 3.1.1 Create JyanikApp.swift with @main and SwiftUI App protocol
- [ ] 3.1.2 Configure SwiftData ModelContainer
- [ ] 3.1.3 Create AppState observable class (auth state, user, subscription)
- [ ] 3.1.4 Create RootView with auth state routing (onboarding vs main)
- [ ] 3.1.5 Create MainTabView (5 tabs per Figma)
- [ ] 3.1.6 Set up environment objects in app entry
- [ ] 3.1.7 **COMMIT**: "feat: create SwiftUI app entry point"

## 3.2 Design System
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

## 3.3 Networking Layer
- [ ] 3.3.1 Create Services/API/APIClient.swift (async/await, generic request)
- [ ] 3.3.2 Create Services/API/APIEndpoint.swift (protocol for typed endpoints)
- [ ] 3.3.3 Create Services/API/APIError.swift (typed error enum)
- [ ] 3.3.4 Create Services/API/AuthInterceptor.swift (JWT injection)
- [ ] 3.3.5 Create Services/API/TokenRefreshMiddleware.swift
- [ ] 3.3.6 Create Services/API/Endpoints/ (one file per domain)
- [ ] 3.3.7 Create NetworkMonitor.swift (NWPathMonitor wrapper)
- [ ] 3.3.8 **COMMIT**: "feat: create networking layer with async/await"

## 3.4 SwiftData Models
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

## 3.5 Service Layer
- [ ] 3.5.1 Create Services/Auth/AuthService.swift
- [ ] 3.5.2 Create Services/Auth/KeychainService.swift (already exists, refine)
- [ ] 3.5.3 Create Services/Auth/AppleSignInService.swift
- [ ] 3.5.4 Create Services/Portfolio/PortfolioService.swift
- [ ] 3.5.5 Create Services/Trading/TradingService.swift
- [ ] 3.5.6 Create Services/MarketData/MarketDataService.swift
- [ ] 3.5.7 Create Services/Competition/CompetitionService.swift
- [ ] 3.5.8 Create Services/Chat/ChatService.swift (WebSocket)
- [ ] 3.5.9 Create Services/Notifications/NotificationService.swift
- [ ] 3.5.10 Create Services/Storage/CacheService.swift
- [ ] 3.5.11 **COMMIT**: "feat: create service layer"

## 3.6 Navigation
- [ ] 3.6.1 Create Core/Navigation/AppRouter.swift
- [ ] 3.6.2 Create Core/Navigation/Route.swift (enum of all destinations)
- [ ] 3.6.3 Implement NavigationStack-based routing per tab
- [ ] 3.6.4 Implement sheet/fullScreenCover presentation
- [ ] 3.6.5 **COMMIT**: "feat: create navigation architecture"

## 3.7 StoreKit 2
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
