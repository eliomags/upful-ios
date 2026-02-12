//
//  User.swift
//  Jyanik
//
//  SwiftData model for user account information.
//  Conforms to Codable for JSON deserialization from the API.
//

import Foundation
import SwiftData

@Model
final class User: Codable {
    @Attribute(.unique) var id: String
    var email: String
    var username: String
    var displayName: String?
    var avatarUrl: String?
    var tier: String
    var bio: String?
    var totalCompetitionsEntered: Int
    var bestFinish: Int?
    var currentStreak: Int
    var joinedAt: String
    var updatedAt: String

    init(
        id: String = UUID().uuidString,
        email: String = "",
        username: String = "",
        displayName: String? = nil,
        avatarUrl: String? = nil,
        tier: String = "free",
        bio: String? = nil,
        totalCompetitionsEntered: Int = 0,
        bestFinish: Int? = nil,
        currentStreak: Int = 0,
        joinedAt: String = "",
        updatedAt: String = ""
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.tier = tier
        self.bio = bio
        self.totalCompetitionsEntered = totalCompetitionsEntered
        self.bestFinish = bestFinish
        self.currentStreak = currentStreak
        self.joinedAt = joinedAt
        self.updatedAt = updatedAt
    }

    // MARK: - Computed Properties

    var isPremium: Bool {
        tier == "premium" || tier == "pro"
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case displayName
        case avatarUrl
        case tier
        case bio
        case totalCompetitionsEntered
        case bestFinish
        case currentStreak
        case joinedAt
        case updatedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        username = try container.decode(String.self, forKey: .username)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        tier = try container.decodeIfPresent(String.self, forKey: .tier) ?? "free"
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        totalCompetitionsEntered = try container.decodeIfPresent(Int.self, forKey: .totalCompetitionsEntered) ?? 0
        bestFinish = try container.decodeIfPresent(Int.self, forKey: .bestFinish)
        currentStreak = try container.decodeIfPresent(Int.self, forKey: .currentStreak) ?? 0
        joinedAt = try container.decodeIfPresent(String.self, forKey: .joinedAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(username, forKey: .username)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(avatarUrl, forKey: .avatarUrl)
        try container.encode(tier, forKey: .tier)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encode(totalCompetitionsEntered, forKey: .totalCompetitionsEntered)
        try container.encodeIfPresent(bestFinish, forKey: .bestFinish)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(joinedAt, forKey: .joinedAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
