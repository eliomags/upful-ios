//
//  AppRouter.swift
//  Jyanik
//
//  Centralized navigation coordinator managing tab-specific navigation stacks and sheets
//

import Foundation
import Observation
import SwiftUI

// MARK: - Tab

enum AppTab: Int, CaseIterable, Hashable {
    case home = 0
    case market
    case compete
    case chat
    case profile
}

// MARK: - App Router

@Observable
final class AppRouter {

    // MARK: - State

    /// The currently selected tab.
    var selectedTab: AppTab = .home

    /// Navigation path per tab.
    var homePath = NavigationPath()
    var marketPath = NavigationPath()
    var competePath = NavigationPath()
    var chatPath = NavigationPath()
    var profilePath = NavigationPath()

    /// Currently presented sheet (shared across all tabs).
    var presentedSheet: AppSheet?

    /// Full-screen cover (e.g., onboarding, trade confirmation).
    var presentedFullScreen: AppSheet?

    // MARK: - Navigation

    /// Pushes a route onto the current tab's navigation stack.
    func navigate(to route: Route) {
        switch selectedTab {
        case .home:
            homePath.append(route)
        case .market:
            marketPath.append(route)
        case .compete:
            competePath.append(route)
        case .chat:
            chatPath.append(route)
        case .profile:
            profilePath.append(route)
        }
    }

    /// Pushes a route onto a specific tab's navigation stack and switches to that tab.
    func navigate(to route: Route, in tab: AppTab) {
        selectedTab = tab
        switch tab {
        case .home:
            homePath.append(route)
        case .market:
            marketPath.append(route)
        case .compete:
            competePath.append(route)
        case .chat:
            chatPath.append(route)
        case .profile:
            profilePath.append(route)
        }
    }

    /// Pops the top route from the current tab's navigation stack.
    func pop() {
        switch selectedTab {
        case .home:
            guard !homePath.isEmpty else { return }
            homePath.removeLast()
        case .market:
            guard !marketPath.isEmpty else { return }
            marketPath.removeLast()
        case .compete:
            guard !competePath.isEmpty else { return }
            competePath.removeLast()
        case .chat:
            guard !chatPath.isEmpty else { return }
            chatPath.removeLast()
        case .profile:
            guard !profilePath.isEmpty else { return }
            profilePath.removeLast()
        }
    }

    /// Pops to the root of the current tab's navigation stack.
    func popToRoot() {
        switch selectedTab {
        case .home:
            homePath = NavigationPath()
        case .market:
            marketPath = NavigationPath()
        case .compete:
            competePath = NavigationPath()
        case .chat:
            chatPath = NavigationPath()
        case .profile:
            profilePath = NavigationPath()
        }
    }

    /// Pops all tabs to their root. Useful when logging out.
    func resetAll() {
        homePath = NavigationPath()
        marketPath = NavigationPath()
        competePath = NavigationPath()
        chatPath = NavigationPath()
        profilePath = NavigationPath()
        presentedSheet = nil
        presentedFullScreen = nil
        selectedTab = .home
    }

    // MARK: - Sheets

    /// Presents a sheet modally.
    func presentSheet(_ sheet: AppSheet) {
        presentedSheet = sheet
    }

    /// Dismisses the currently presented sheet.
    func dismissSheet() {
        presentedSheet = nil
    }

    /// Presents a full-screen cover.
    func presentFullScreen(_ sheet: AppSheet) {
        presentedFullScreen = sheet
    }

    /// Dismisses the full-screen cover.
    func dismissFullScreen() {
        presentedFullScreen = nil
    }

    // MARK: - Binding Helpers

    /// Returns the NavigationPath binding for the current tab.
    func pathBinding(for tab: AppTab) -> Binding<NavigationPath> {
        switch tab {
        case .home:
            return Binding(get: { self.homePath }, set: { self.homePath = $0 })
        case .market:
            return Binding(get: { self.marketPath }, set: { self.marketPath = $0 })
        case .compete:
            return Binding(get: { self.competePath }, set: { self.competePath = $0 })
        case .chat:
            return Binding(get: { self.chatPath }, set: { self.chatPath = $0 })
        case .profile:
            return Binding(get: { self.profilePath }, set: { self.profilePath = $0 })
        }
    }

    // MARK: - Deep Linking

    /// Handles a deep link URL and navigates to the appropriate route.
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else { return }

        switch host {
        case "stock":
            if let ticker = components.queryItems?.first(where: { $0.name == "ticker" })?.value {
                navigate(to: .stockDetail(ticker: ticker), in: .market)
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
