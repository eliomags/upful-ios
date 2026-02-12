//
//  SocialEndpoints.swift
//  Jyanik
//
//  Chat and notifications API endpoints
//

import Foundation

enum SocialEndpoints {

    // MARK: - Chat

    static func getChatMessages(before: String? = nil, limit: Int = 50) -> APIEndpoint {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        if let before {
            queryItems.append(URLQueryItem(name: "before", value: before))
        }
        return APIEndpoint(
            path: "/chat/messages",
            method: .get,
            queryItems: queryItems
        )
    }

    static func sendChatMessage(
        content: String,
        imageKey: String? = nil,
        tickers: [String]? = nil
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/chat/messages",
            method: .post,
            body: SendMessageBody(
                content: content,
                imageKey: imageKey,
                tickers: tickers
            )
        )
    }

    static func reportMessage(id: String) -> APIEndpoint {
        APIEndpoint(
            path: "/chat/messages/\(id)/report",
            method: .post
        )
    }

    // MARK: - Notifications

    static func getNotifications(page: Int = 1, limit: Int = 20) -> APIEndpoint {
        APIEndpoint(
            path: "/notifications",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func markNotificationRead(id: String) -> APIEndpoint {
        APIEndpoint(
            path: "/notifications/\(id)/read",
            method: .patch
        )
    }

    static func markAllNotificationsRead() -> APIEndpoint {
        APIEndpoint(
            path: "/notifications/read-all",
            method: .post
        )
    }
}

// MARK: - Request Bodies

private struct SendMessageBody: Encodable {
    let content: String
    let imageKey: String?
    let tickers: [String]?
}
