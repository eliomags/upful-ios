//
//  MainTabView.swift
//  Jyanik
//
//  Main tab bar with 5 tabs: Home, Markets, Trade, Compete, Profile
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var router = AppRouter()

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                tab.destination
                    .tabItem {
                        tab.label
                    }
                    .tag(tab)
            }
        }
        .tint(JColor.primary)
        .environment(router)
    }
}

// MARK: - Tab Definition

extension MainTabView {
    enum Tab: String, CaseIterable, Identifiable {
        case home
        case markets
        case trade
        case compete
        case profile

        var id: String { rawValue }

        var title: String {
            switch self {
            case .home: return "Home"
            case .markets: return "Markets"
            case .trade: return "Trade"
            case .compete: return "Compete"
            case .profile: return "Profile"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house"
            case .markets: return "chart.line.uptrend.xyaxis"
            case .trade: return "plus.circle.fill"
            case .compete: return "trophy"
            case .profile: return "person"
            }
        }

        @ViewBuilder
        var label: some View {
            Label(title, systemImage: icon)
        }

        @ViewBuilder
        var destination: some View {
            NavigationStack {
                switch self {
                case .home:
                    HomeView()
                case .markets:
                    MarketsView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .stockDetail(let ticker):
                                StockDetailView(ticker: ticker)
                            default:
                                EmptyView()
                            }
                        }
                case .trade:
                    TradeView()
                case .compete:
                    CompeteView()
                case .profile:
                    ProfileView()
                }
            }
        }
    }
}

// MARK: - Tab Placeholder Views

private struct MarketsPlaceholder: View {
    var body: some View {
        TabPlaceholder(
            icon: "chart.line.uptrend.xyaxis",
            title: "Markets",
            subtitle: "Search stocks and view market data"
        )
        .navigationTitle("Markets")
    }
}

private struct TradePlaceholder: View {
    var body: some View {
        TabPlaceholder(
            icon: "arrow.left.arrow.right",
            title: "Trade",
            subtitle: "Buy and sell stocks in your competitions"
        )
        .navigationTitle("Trade")
    }
}

private struct CompetePlaceholder: View {
    var body: some View {
        TabPlaceholder(
            icon: "trophy.fill",
            title: "Compete",
            subtitle: "Join competitions and climb the leaderboard"
        )
        .navigationTitle("Compete")
    }
}

private struct ProfilePlaceholder: View {
    var body: some View {
        TabPlaceholder(
            icon: "person.fill",
            title: "Profile",
            subtitle: "Your stats, settings, and achievements"
        )
        .navigationTitle("Profile")
    }
}

// MARK: - Generic Tab Placeholder

private struct TabPlaceholder: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        JEmptyState(
            icon: icon,
            title: title,
            description: subtitle
        )
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
