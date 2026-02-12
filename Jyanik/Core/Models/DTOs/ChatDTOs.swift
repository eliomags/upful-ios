//
//  ChatDTOs.swift
//  Jyanik
//
//  Network DTOs for chat endpoints
//

import Foundation

// MARK: - Chat Message

struct ChatMessageDTO: Decodable, Identifiable {
    let id: String
    let userId: String
    let username: String
    let content: String?
    let imageKey: String?
    let tickers: [String]?
    let isDeleted: Int?
    let avatarURL: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case username, content
        case imageKey = "image_key"
        case tickers
        case isDeleted = "is_deleted"
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
    }
}

// MARK: - Send Message Request

struct SendMessageRequestBody: Encodable {
    let content: String?
    let imageKey: String?

    enum CodingKeys: String, CodingKey {
        case content
        case imageKey = "image_key"
    }
}

// MARK: - Report Request

struct ReportMessageRequestBody: Encodable {
    let reason: String
}
