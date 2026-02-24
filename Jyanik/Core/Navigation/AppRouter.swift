//
//  AppRouter.swift
//  Jyanik
//
//  Centralized navigation coordinator managing tab-specific navigation stacks and sheets
//

import Foundation
import Observation
import SwiftUI

// MARK: - App Router

@Observable
final class AppRouter {

    // MARK: - Tab (single source of truth for all tabs)

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
    }

    // MARK: - State

    /// The currently selected tab.
    var selectedTab: Tab = .home

    /// Navigation path per tab.
    var homePath = NavigationPath()
    var marketsPath = NavigationPath()
    var tradePath = NavigationPath()
    var competePath = NavigationPath()
    var profilePath = NavigationPath()

    /// Currently presented sheet (shared across all tabs).
    var presentedSheet: AppSheet?

    /// Full-screen cover (e.g., onboarding, trade confirmation).
    var presentedFullScreen: AppSheet?

    // MARK: - Navigation

    /// Pushes a route onto the current tab's navigation stack.
    func navigate(to route: Route) {
        switch selectedTab {
        case .home: homePath.append(route)
        case .markets: marketsPath.append(route)
        case .trade: tradePath.append(route)
        case .compete: competePath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    /// Pushes a route onto a specific tab's navigation stack and switches to that tab.
    func navigate(to route: Route, in tab: Tab) {
        selectedTab = tab
        switch tab {
        case .home: homePath.append(route)
        case .markets: marketsPath.append(route)
        case .trade: tradePath.append(route)
        case .compete: competePath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    /// Pops the top route from the current tab's navigation stack.
    func pop() {
        switch selectedTab {
        case .home:
            guard !homePath.isEmpty else { return }
            homePath.removeLast()
        case .markets:
            guard !marketsPath.isEmpty else { return }
            marketsPath.removeLast()
        case .trade:
            guard !tradePath.isEmpty else { return }
            tradePath.removeLast()
        case .compete:
            guard !competePath.isEmpty else { return }
            competePath.removeLast()
        case .profile:
            guard !profilePath.isEmpty else { return }
            profilePath.removeLast()
        }
    }

    /// Pops to the root of the current tab's navigation stack.
    func popToRoot() {
        switch selectedTab {
        case .home: homePath = NavigationPath()
        case .markets: marketsPath = NavigationPath()
        case .trade: tradePath = NavigationPath()
        case .compete: competePath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }

    /// Pops all tabs to their root. Useful when logging out.
    func resetAll() {
        homePath = NavigationPath()
        marketsPath = NavigationPath()
        tradePath = NavigationPath()
        competePath = NavigationPath()
        profilePath = NavigationPath()
        presentedSheet = nil
        presentedFullScreen = nil
        selectedTab = .home
    }

    // MARK: - Sheets

    func presentSheet(_ sheet: AppSheet) {
        presentedSheet = sheet
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func presentFullScreen(_ sheet: AppSheet) {
        presentedFullScreen = sheet
    }

    func dismissFullScreen() {
        presentedFullScreen = nil
    }

    // MARK: - Path Binding

    /// Returns a binding to the NavigationPath for the given tab.
    func pathBinding(for tab: Tab) -> Binding<NavigationPath> {
        switch tab {
        case .home:
            return Binding(get: { self.homePath }, set: { self.homePath = $0 })
        case .markets:
            return Binding(get: { self.marketsPath }, set: { self.marketsPath = $0 })
        case .trade:
            return Binding(get: { self.tradePath }, set: { self.tradePath = $0 })
        case .compete:
            return Binding(get: { self.competePath }, set: { self.competePath = $0 })
        case .profile:
            return Binding(get: { self.profilePath }, set: { self.profilePath = $0 })
        }
    }

    // MARK: - Deep Linking

    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else { return }

        switch host {
        case "stock":
            if let ticker = components.queryItems?.first(where: { $0.name == "ticker" })?.value {
                navigate(to: .stockDetail(ticker: ticker), in: .markets)
            }
        case "portfolio":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value {
                navigate(to: .portfolio(id: id), in: .home)
            }
        case "competition":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value {
                navigate(to: .competitionDetail(id: id), in: .compete)
            }
        case "leaderboard":
            navigate(to: .leaderboardFull, in: .compete)
        case "profile":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value {
                navigate(to: .userProfile(id: id), in: .profile)
            }
        case "notifications":
            navigate(to: .notificationList, in: .profile)
        default:
            break
        }
    }
}
