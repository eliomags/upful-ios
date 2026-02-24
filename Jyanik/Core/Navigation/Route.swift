//
//  Route.swift
//  Jyanik
//
//  All navigable destinations in the app
//

import Foundation

// MARK: - Route

enum Route: Hashable {
    // Market
    case stockDetail(ticker: String)
    case newsDetail(url: String)
    case watchlist
    case screener
    case screenerDetail(id: String)

    // Portfolio
    case portfolio(id: String)
    case tradeSheet(ticker: String, side: TradeSide)

    // Competition
    case competitionDetail(id: String)
    case leaderboardFull

    // Social
    case userProfile(id: String)

    // Portfolio
    case transactionHistory

    // Settings
    case settings
    case editProfile
    case notificationList
}

// MARK: - Sheet

/// Sheets that can be presented modally from any tab.
enum AppSheet: Identifiable {
    case trade(ticker: String, side: TradeSide)
    case search
    case notifications

    var id: String {
        switch self {
        case .trade(let ticker, let side):
            return "trade_\(ticker)_\(side.rawValue)"
        case .search:
            return "search"
        case .notifications:
            return "notifications"
        }
    }
}
