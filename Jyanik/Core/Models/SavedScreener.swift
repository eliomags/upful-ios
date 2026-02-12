//
//  SavedScreener.swift
//  Jyanik
//
//  SwiftData model for saved stock screener configurations.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class SavedScreener: Codable {
    @Attribute(.unique) var id: String
    var name: String
    var filters: String
    var createdAt: String
    var updatedAt: String

    init(
        id: String = UUID().uuidString,
        name: String = "",
        filters: String = "{}",
        createdAt: String = "",
        updatedAt: String = ""
    ) {
        self.id = id
        self.name = name
        self.filters = filters
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case filters
        case createdAt
        case updatedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        filters = try container.decodeIfPresent(String.self, forKey: .filters) ?? "{}"
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(filters, forKey: .filters)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
