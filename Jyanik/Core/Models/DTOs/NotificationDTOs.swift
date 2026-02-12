//
//  NotificationDTOs.swift
//  Jyanik
//
//  Network DTOs for notification endpoints
//

import Foundation

// MARK: - App Notification

struct AppNotificationDTO: Decodable, Identifiable {
    let id: String
    let userId: String
    let type: String
    let title: String
    let body: String
    let amount: Double?
    let metadata: String?
    let isRead: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type, title, body, amount, metadata
        case isRead = "is_read"
        case createdAt = "created_at"
    }

    var read: Bool { isRead != 0 }
}

// MARK: - Notifications Response

struct NotificationsResponseDTO: Decodable {
    let data: [AppNotificationDTO]
    let unreadCount: Int
    let pagination: PaginationDTO

    enum CodingKeys: String, CodingKey {
        case data
        case unreadCount = "unread_count"
        case pagination
    }
}

// MARK: - Device Registration

struct DeviceRegistrationBody: Encodable {
    let deviceToken: String
    let platform: String
    let appVersion: String

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case platform
        case appVersion = "app_version"
    }
}
