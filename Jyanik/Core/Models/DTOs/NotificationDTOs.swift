//
//  NotificationDTOs.swift
//  Jyanik
//
//  Network DTOs for notification endpoints
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
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

    var read: Bool { isRead != 0 }
}

// MARK: - Notifications Response

struct NotificationsResponseDTO: Decodable {
    let data: [AppNotificationDTO]
    let unreadCount: Int
    let pagination: PaginationDTO
}

// MARK: - Device Registration (Encodable — keeps CodingKeys for encoder)

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
