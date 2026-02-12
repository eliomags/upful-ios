//
//  PortfolioDTOs.swift
//  Jyanik
//
//  Network DTOs for portfolio endpoints
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

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case cashBalance = "cash_balance"
        case totalEquity = "total_equity"
        case isActive = "is_active"
        case competitionMonth = "competition_month"
        case holdingsValue = "holdings_value"
        case totalPnl = "total_pnl"
        case totalPnlPct = "total_pnl_pct"
        case positions
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
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

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioId = "portfolio_id"
        case ticker
        case assetType = "asset_type"
        case quantity
        case averageCost = "average_cost"
        case currentPrice = "current_price"
        case marketValue = "market_value"
        case unrealizedPnl = "unrealized_pnl"
        case unrealizedPnlPct = "unrealized_pnl_pct"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
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

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioId = "portfolio_id"
        case ticker
        case assetType = "asset_type"
        case side, quantity, price
        case totalValue = "total_value"
        case executedAt = "executed_at"
    }
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

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioId = "portfolio_id"
        case snapshotDate = "snapshot_date"
        case cashBalance = "cash_balance"
        case holdingsValue = "holdings_value"
        case totalEquity = "total_equity"
        case dailyPnl = "daily_pnl"
        case dailyPnlPct = "daily_pnl_pct"
        case totalPnl = "total_pnl"
        case totalPnlPct = "total_pnl_pct"
    }
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

    enum CodingKeys: String, CodingKey {
        case page, limit, total
        case totalPages = "total_pages"
        case hasMore = "has_more"
    }
}

// MARK: - Positions Response

struct PositionsResponseDTO: Decodable {
    let positions: [PositionDTO]
}

// MARK: - Snapshots Response

struct SnapshotsResponseDTO: Decodable {
    let snapshots: [PortfolioSnapshotDTO]
}
