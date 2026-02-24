//
//  MainTabView.swift
//  Jyanik
//
//  Main tab bar with 5 tabs: Home, Markets, Trade, Compete, Profile
//  Uses AppRouter.Tab as single source of truth for tab definitions
//

import SwiftUI

struct MainTabView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            ForEach(AppRouter.Tab.allCases) { tab in
                tabDestination(for: tab)
                    .tabItem {
                        tab.label
                    }
                    .tag(tab)
            }
        }
        .tint(JColor.primary)
    }

    // MARK: - Tab Destinations

    @ViewBuilder
    private func tabDestination(for tab: AppRouter.Tab) -> some View {
        NavigationStack(path: router.pathBinding(for: tab)) {
            Group {
                switch tab {
                case .home:
                    HomeView()
                case .markets:
                    MarketsView()
                case .trade:
                    TradeView()
                case .compete:
                    CompeteView()
                case .profile:
                    ProfileView()
                }
            }
            .navigationDestination(for: Route.self) { route in
                routeDestination(for: route)
            }
        }
    }

    @ViewBuilder
    private func routeDestination(for route: Route) -> some View {
        switch route {
        case .stockDetail(let ticker):
            StockDetailView(ticker: ticker)
        case .leaderboardFull:
            LeaderboardView()
        case .userProfile(let id):
            UserPerformanceView(userId: id)
                .id(id) // Force SwiftUI to create a new view for each user ID
        case .competitionDetail:
            EmptyView() // handled by CompeteView's own navigationDestination
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environment(AppRouter())
        .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
