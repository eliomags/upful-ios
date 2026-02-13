//
//  ChatDTOs.swift
//  Jyanik
//
//  Network DTOs for chat endpoints
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
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
    let avatarUrl: String?
    let createdAt: String
}

// MARK: - Send Message Request (Encodable — keeps CodingKeys for encoder)

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
