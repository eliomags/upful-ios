//
//  Position.swift
//  Jyanik
//
//  SwiftData model for a stock position within a portfolio.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class Position: Codable {
    @Attribute(.unique) var id: String
    var portfolioId: String
    var ticker: String
    var companyName: String?
    var quantity: Double
    var averageCost: Double
    var marketValue: Double
    var unrealizedPnl: Double
    var unrealizedPnlPct: Double
    var side: String
    var openedAt: String
    var updatedAt: String

    init(
        id: String = UUID().uuidString,
        portfolioId: String = "",
        ticker: String = "",
        companyName: String? = nil,
        quantity: Double = 0,
        averageCost: Double = 0,
        marketValue: Double = 0,
        unrealizedPnl: Double = 0,
        unrealizedPnlPct: Double = 0,
        side: String = "long",
        openedAt: String = "",
        updatedAt: String = ""
    ) {
        self.id = id
        self.portfolioId = portfolioId
        self.ticker = ticker
        self.companyName = companyName
        self.quantity = quantity
        self.averageCost = averageCost
        self.marketValue = marketValue
        self.unrealizedPnl = unrealizedPnl
        self.unrealizedPnlPct = unrealizedPnlPct
        self.side = side
        self.openedAt = openedAt
        self.updatedAt = updatedAt
    }

    // MARK: - Computed Properties

    var currentPrice: Double {
        guard quantity != 0 else { return 0 }
        return marketValue / quantity
    }

    var isProfit: Bool {
        unrealizedPnl >= 0
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioId
        case ticker
        case companyName
        case quantity
        case averageCost
        case marketValue
        case unrealizedPnl
        case unrealizedPnlPct
        case side
        case openedAt
        case updatedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        portfolioId = try container.decodeIfPresent(String.self, forKey: .portfolioId) ?? ""
        ticker = try container.decode(String.self, forKey: .ticker)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        quantity = try container.decodeIfPresent(Double.self, forKey: .quantity) ?? 0
        averageCost = try container.decodeIfPresent(Double.self, forKey: .averageCost) ?? 0
        marketValue = try container.decodeIfPresent(Double.self, forKey: .marketValue) ?? 0
        unrealizedPnl = try container.decodeIfPresent(Double.self, forKey: .unrealizedPnl) ?? 0
        unrealizedPnlPct = try container.decodeIfPresent(Double.self, forKey: .unrealizedPnlPct) ?? 0
        side = try container.decodeIfPresent(String.self, forKey: .side) ?? "long"
        openedAt = try container.decodeIfPresent(String.self, forKey: .openedAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(portfolioId, forKey: .portfolioId)
        try container.encode(ticker, forKey: .ticker)
        try container.encodeIfPresent(companyName, forKey: .companyName)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(averageCost, forKey: .averageCost)
        try container.encode(marketValue, forKey: .marketValue)
        try container.encode(unrealizedPnl, forKey: .unrealizedPnl)
        try container.encode(unrealizedPnlPct, forKey: .unrealizedPnlPct)
        try container.encode(side, forKey: .side)
        try container.encode(openedAt, forKey: .openedAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
