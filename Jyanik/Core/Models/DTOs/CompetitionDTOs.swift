//
//  CompetitionDTOs.swift
//  Jyanik
//
//  Network DTOs for competition and leaderboard endpoints
//  Note: ResetChoice is defined in CompetitionEndpoints.swift
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
//

import Foundation

// MARK: - Competition

struct CompetitionDTO: Decodable, Identifiable, Hashable {
    let id: String
    let type: String
    let status: String
    let startDate: String
    let endDate: String
    let totalPrizePool: Double
    let participantCount: Int
    let createdAt: String
    let tier: String?
    let description: String?
    let rules: String?
    let isJoined: Bool?

    /// Whether this is a premium (cash-prize) competition.
    var isPremium: Bool { (tier ?? "free") == "premium" }

    /// Display-friendly tier label.
    var tierLabel: String { isPremium ? "Premium" : "Free" }

    /// Whether the current user has joined this competition.
    var joined: Bool { isJoined ?? false }
}

// MARK: - Leaderboard

struct LeaderboardEntryDTO: Decodable, Identifiable {
    let id: String?
    let userId: String?
    let rank: Int
    let username: String
    let displayName: String?
    let avatarUrl: String?
    let totalEquity: Double
    let growthPct: Double
    let subscriptionTier: String?
    let prizeAmount: Double?

    var stableID: String { id ?? userId ?? "\(rank)" }
}

// MARK: - My Ranking

struct MyRankingDTO: Decodable {
    let rank: Int
    let growthPct: Double
    let totalEquity: Double
    let prizeAmount: Double?
}

// MARK: - Reset Response

struct ResetResponseDTO: Decodable {
    let choice: String
    let portfolio: PortfolioDTO?
    let message: String
}

// MARK: - Competition History Entry

struct CompetitionHistoryEntryDTO: Decodable, Identifiable {
    let id: String
    let competitionId: String
    let startingEquity: Double
    let endingEquity: Double?
    let growthPct: Double?
    let rank: Int?
    let prizeAmount: Double?
    let prizeStatus: String?
    let createdAt: String
    let type: String?
    let startDate: String?
    let endDate: String?
    let totalPrizePool: Double?
    let participantCount: Int?
    let subscriptionTier: String?
}

// MARK: - Past Competition Result (with winners)

struct PastCompetitionResultDTO: Decodable, Identifiable {
    let id: String
    let type: String
    let status: String
    let startDate: String
    let endDate: String
    let totalPrizePool: Double
    let participantCount: Int
    let tier: String?
    let winners: [CompetitionWinnerDTO]

    var isPremium: Bool { (tier ?? "free") == "premium" }
}

struct CompetitionWinnerDTO: Decodable, Identifiable {
    let userId: String
    let username: String
    let displayName: String?
    let avatarUrl: String?
    let subscriptionTier: String?
    let rank: Int
    let growthPct: Double
    let prizeAmount: Double?
    let endingEquity: Double?

    var id: String { userId }
}

// MARK: - User Performance

struct UserPerformanceResponseDTO: Decodable {
    let user: UserPerformanceProfileDTO
    let stats: UserPerformanceStatsDTO
    let history: [CompetitionHistoryEntryDTO]
}

struct UserPerformanceProfileDTO: Decodable {
    let id: String
    let username: String
    let displayName: String?
    let avatarUrl: String?
    let subscriptionTier: String?
    let memberSince: String?
}

struct UserPerformanceStatsDTO: Decodable {
    let totalCompetitions: Int
    let wins: Int
    let topThreeFinishes: Int
    let bestRank: Int?
    let avgGrowthPct: Double
    let totalPrizeWon: Double
}
