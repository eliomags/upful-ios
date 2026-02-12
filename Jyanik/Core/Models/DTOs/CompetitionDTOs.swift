//
//  CompetitionDTOs.swift
//  Jyanik
//
//  Network DTOs for competition and leaderboard endpoints
//  Note: ResetChoice is defined in CompetitionEndpoints.swift
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

    enum CodingKeys: String, CodingKey {
        case id, type, status
        case startDate = "start_date"
        case endDate = "end_date"
        case totalPrizePool = "total_prize_pool"
        case participantCount = "participant_count"
        case createdAt = "created_at"
    }
}

// MARK: - Leaderboard

struct LeaderboardEntryDTO: Decodable, Identifiable {
    let id: String?
    let userId: String?
    let rank: Int
    let username: String
    let displayName: String?
    let avatarURL: String?
    let totalEquity: Double
    let growthPct: Double
    let subscriptionTier: String?

    var stableID: String { id ?? userId ?? "\(rank)" }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case rank, username
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case totalEquity = "total_equity"
        case growthPct = "growth_pct"
        case subscriptionTier = "subscription_tier"
    }
}

// MARK: - My Ranking

struct MyRankingDTO: Decodable {
    let rank: Int
    let growthPct: Double
    let totalEquity: Double

    enum CodingKeys: String, CodingKey {
        case rank
        case growthPct = "growth_pct"
        case totalEquity = "total_equity"
    }
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

    enum CodingKeys: String, CodingKey {
        case id
        case competitionId = "competition_id"
        case startingEquity = "starting_equity"
        case endingEquity = "ending_equity"
        case growthPct = "growth_pct"
        case rank
        case prizeAmount = "prize_amount"
        case prizeStatus = "prize_status"
        case createdAt = "created_at"
        case type
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
