//
//  CachedNotification.swift
//  Jyanik
//
//  SwiftData model for locally cached push/in-app notifications.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class CachedNotification: Codable {
    @Attribute(.unique) var id: String
    var type: String
    var title: String
    var body: String
    var amount: Double?
    var metadata: String?
    var isRead: Bool
    var createdAt: String

    init(
        id: String = UUID().uuidString,
        type: String = "",
        title: String = "",
        body: String = "",
        amount: Double? = nil,
        metadata: String? = nil,
        isRead: Bool = false,
        createdAt: String = ""
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.amount = amount
        self.metadata = metadata
        self.isRead = isRead
        self.createdAt = createdAt
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case body
        case amount
        case metadata
        case isRead
        case createdAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        metadata = try container.decodeIfPresent(String.self, forKey: .metadata)
        isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encode(isRead, forKey: .isRead)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
