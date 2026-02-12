//
//  Portfolio.swift
//  Jyanik
//
//  SwiftData model for a user's trading portfolio.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class Portfolio: Codable {
    @Attribute(.unique) var id: String
    var userId: String
    var cashBalance: Double
    var totalEquity: Double
    var isActive: Bool
    var competitionMonth: String
    var holdingsValue: Double
    var totalPnl: Double
    var totalPnlPct: Double
    var createdAt: String
    var updatedAt: String

    @Relationship(deleteRule: .cascade) var positions: [Position]

    init(
        id: String = UUID().uuidString,
        userId: String = "",
        cashBalance: Double = 0,
        totalEquity: Double = 0,
        isActive: Bool = true,
        competitionMonth: String = "",
        holdingsValue: Double = 0,
        totalPnl: Double = 0,
        totalPnlPct: Double = 0,
        createdAt: String = "",
        updatedAt: String = "",
        positions: [Position] = []
    ) {
        self.id = id
        self.userId = userId
        self.cashBalance = cashBalance
        self.totalEquity = totalEquity
        self.isActive = isActive
        self.competitionMonth = competitionMonth
        self.holdingsValue = holdingsValue
        self.totalPnl = totalPnl
        self.totalPnlPct = totalPnlPct
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.positions = positions
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case cashBalance
        case totalEquity
        case isActive
        case competitionMonth
        case holdingsValue
        case totalPnl
        case totalPnlPct
        case createdAt
        case updatedAt
        case positions
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        cashBalance = try container.decodeIfPresent(Double.self, forKey: .cashBalance) ?? 0
        totalEquity = try container.decodeIfPresent(Double.self, forKey: .totalEquity) ?? 0
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        competitionMonth = try container.decodeIfPresent(String.self, forKey: .competitionMonth) ?? ""
        holdingsValue = try container.decodeIfPresent(Double.self, forKey: .holdingsValue) ?? 0
        totalPnl = try container.decodeIfPresent(Double.self, forKey: .totalPnl) ?? 0
        totalPnlPct = try container.decodeIfPresent(Double.self, forKey: .totalPnlPct) ?? 0
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        positions = try container.decodeIfPresent([Position].self, forKey: .positions) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(cashBalance, forKey: .cashBalance)
        try container.encode(totalEquity, forKey: .totalEquity)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(competitionMonth, forKey: .competitionMonth)
        try container.encode(holdingsValue, forKey: .holdingsValue)
        try container.encode(totalPnl, forKey: .totalPnl)
        try container.encode(totalPnlPct, forKey: .totalPnlPct)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(positions, forKey: .positions)
    }
}
