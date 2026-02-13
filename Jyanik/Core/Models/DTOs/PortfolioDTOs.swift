//
//  PortfolioDTOs.swift
//  Jyanik
//
//  Network DTOs for portfolio endpoints
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
//

import Foundation

// MARK: - Portfolio

struct PortfolioDTO: Decodable {
    let id: String
    let userId: String
    let cashBalance: Double
    let totalEquity: Double
    let isActive: Int
    let competitionMonth: String?
    let holdingsValue: Double?
    let totalPnl: Double?
    let totalPnlPct: Double?
    let positions: [PositionDTO]?
    let createdAt: String
    let updatedAt: String
}

// MARK: - Position

struct PositionDTO: Decodable {
    let id: String
    let portfolioId: String
    let ticker: String
    let assetType: String
    let quantity: Double
    let averageCost: Double
    let currentPrice: Double?
    let marketValue: Double
    let unrealizedPnl: Double
    let unrealizedPnlPct: Double?
    let updatedAt: String?
    let createdAt: String?
}

// MARK: - Transaction

struct TransactionDTO: Decodable {
    let id: String
    let portfolioId: String
    let ticker: String
    let assetType: String
    let side: String
    let quantity: Double
    let price: Double
    let totalValue: Double
    let executedAt: String
}

// MARK: - Portfolio Snapshot

struct PortfolioSnapshotDTO: Decodable {
    let id: String
    let portfolioId: String
    let snapshotDate: String
    let cashBalance: Double
    let holdingsValue: Double
    let totalEquity: Double
    let dailyPnl: Double
    let dailyPnlPct: Double
    let totalPnl: Double
    let totalPnlPct: Double
}

// MARK: - Paginated Transactions Response

struct TransactionsPageDTO: Decodable {
    let data: [TransactionDTO]
    let pagination: PaginationDTO
}

struct PaginationDTO: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int?
    let hasMore: Bool?
}

// MARK: - Positions Response

struct PositionsResponseDTO: Decodable {
    let positions: [PositionDTO]
}

// MARK: - Snapshots Response

struct SnapshotsResponseDTO: Decodable {
    let snapshots: [PortfolioSnapshotDTO]
}
