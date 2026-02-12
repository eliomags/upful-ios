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
        tab: LeaderboardTab = .topGainers,
        page: Int = 1,
        limit: Int = 50
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/leaderboard",
            method: .get,
            queryItems: [
                URLQueryItem(name: "period", value: period.rawValue),
                URLQueryItem(name: "tab", value: tab.rawValue),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func getMyRanking() -> APIEndpoint {
        APIEndpoint(
            path: "/leaderboard/me",
            method: .get
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

enum LeaderboardPeriod: String {
    case daily
    case weekly
    case monthly
    case allTime = "all_time"
}

// MARK: - Leaderboard Tab

enum LeaderboardTab: String {
    case topGainers = "top_gainers"
    case topLosers = "top_losers"
    case mostActive = "most_active"
}
