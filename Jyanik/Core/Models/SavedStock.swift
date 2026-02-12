//
//  SavedStock.swift
//  Jyanik
//
//  SwiftData model for a user's watchlist item.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class SavedStock: Codable {
    @Attribute(.unique) var id: String
    var ticker: String
    var companyName: String?
    var sortOrder: Int
    var addedAt: String

    init(
        id: String = UUID().uuidString,
        ticker: String = "",
        companyName: String? = nil,
        sortOrder: Int = 0,
        addedAt: String = ""
    ) {
        self.id = id
        self.ticker = ticker
        self.companyName = companyName
        self.sortOrder = sortOrder
        self.addedAt = addedAt
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case ticker
        case companyName
        case sortOrder
        case addedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        ticker = try container.decode(String.self, forKey: .ticker)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        addedAt = try container.decodeIfPresent(String.self, forKey: .addedAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ticker, forKey: .ticker)
        try container.encodeIfPresent(companyName, forKey: .companyName)
        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(addedAt, forKey: .addedAt)
    }
}
