//
//  LeaderboardEndpoints.swift
//  Jyanik
//
//  Leaderboard API endpoints
//

import Foundation

enum LeaderboardEndpoints {

    static func getLeaderboard(
        period: LeaderboardPeriod = .weekly,
        tier: LeaderboardTier = .all,
        sort: LeaderboardSort = .topGainers,
        page: Int = 1,
        limit: Int = 50
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/leaderboard",
            method: .get,
            queryItems: [
                URLQueryItem(name: "period", value: period.rawValue),
                URLQueryItem(name: "tier", value: tier.rawValue),
                URLQueryItem(name: "sort", value: sort.rawValue),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func getMyRanking(period: LeaderboardPeriod = .weekly, tier: LeaderboardTier = .all) -> APIEndpoint {
        APIEndpoint(
            path: "/leaderboard/me",
            method: .get,
            queryItems: [
                URLQueryItem(name: "period", value: period.rawValue),
                URLQueryItem(name: "tier", value: tier.rawValue)
            ]
        )
    }

    static func getLeaderboardHistory() -> APIEndpoint {
        APIEndpoint(
            path: "/leaderboard/history",
            method: .get
        )
    }
}

// MARK: - Leaderboard Period

enum LeaderboardPeriod: String, CaseIterable {
    case daily
    case weekly
    case monthly
    case quarterly
    case semiannual

    var displayName: String {
        switch self {
        case .daily: return "Day"
        case .weekly: return "Week"
        case .monthly: return "Month"
        case .quarterly: return "3 months"
        case .semiannual: return "6 months"
        }
    }
}

// MARK: - Leaderboard Tier

enum LeaderboardTier: String, CaseIterable {
    case all
    case free
    case premium

    var displayName: String {
        switch self {
        case .all: return "All"
        case .free: return "Free"
        case .premium: return "Subscribed"
        }
    }
}

// MARK: - Leaderboard Sort

enum LeaderboardSort: String, CaseIterable {
    case topGainers = "top_gainers"
    case topLosers = "top_losers"
    case mostActive = "most_active"

    var displayName: String {
        switch self {
        case .topGainers: return "Top Gainers"
        case .topLosers: return "Top Losers"
        case .mostActive: return "Most Active"
        }
    }
}
