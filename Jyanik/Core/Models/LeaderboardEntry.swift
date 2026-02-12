//
//  LeaderboardEntry.swift
//  Jyanik
//
//  Codable API model for a leaderboard ranking entry.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct LeaderboardEntry: Codable, Identifiable {
    let rank: Int
    let userId: String
    let username: String
    let displayName: String?
    let avatarUrl: String?
    let portfolioValue: Double
    let growthPercent: Double

    var id: String { userId }

    // MARK: - Computed Properties

    var isTopThree: Bool {
        rank <= 3
    }

    var formattedGrowth: String {
        let sign = growthPercent >= 0 ? "+" : ""
        return String(format: "%@%.2f%%", sign, growthPercent)
    }
}
