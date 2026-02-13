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

struct CompetitionDTO: Decodable, Identifiable {
    let id: String
    let type: String
    let status: String
    let startDate: String
    let endDate: String
    let totalPrizePool: Double
    let participantCount: Int
    let createdAt: String
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

    var stableID: String { id ?? userId ?? "\(rank)" }
}

// MARK: - My Ranking

struct MyRankingDTO: Decodable {
    let rank: Int
    let growthPct: Double
    let totalEquity: Double
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
    let growthPct: Double
    let rank: Int?
    let prizeAmount: Double
    let prizeStatus: String
    let createdAt: String
    let type: String?
    let startDate: String?
    let endDate: String?
}
