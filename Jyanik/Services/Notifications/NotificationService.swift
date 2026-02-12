//
//  NotificationService.swift
//  Jyanik
//
//  Manages in-app notifications and push notification registration
//

import Foundation
import Observation
import UserNotifications
import UIKit
import OSLog

@Observable
final class NotificationService {

    // MARK: - State

    private(set) var notifications: [AppNotificationDTO] = []
    private(set) var unreadCount: Int = 0
    private(set) var isLoading = false

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "NotificationService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Fetch Notifications

    /// Fetches paginated notifications from the server.
    func fetchNotifications(page: Int = 1, limit: Int = 20) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = SocialEndpoints.getNotifications(page: page, limit: limit)
        let response: NotificationsResponseDTO = try await apiClient.request(endpoint)

        if page == 1 {
            notifications = response.data
        } else {
            notifications.append(contentsOf: response.data)
        }

        unreadCount = response.unreadCount

        logger.info("[Notifications] Fetched \(response.data.count) notifications (unread: \(response.unreadCount))")
    }

    // MARK: - Mark as Read

    /// Marks a single notification as read.
    func markAsRead(id: String) async throws {
        let endpoint = SocialEndpoints.markNotificationRead(id: id)
        try await apiClient.requestNoContent(endpoint)

        // Update local state
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            // Since DTOs are structs, we need to handle immutability
            let updated = notifications[index]
            // We can't mutate the DTO directly, so mark it in a local tracking set
            // For simplicity, re-fetch or use a local read tracking mechanism
            notifications[index] = AppNotificationDTO(
                id: updated.id,
                userId: updated.userId,
                type: updated.type,
                title: updated.title,
                body: updated.body,
                amount: updated.amount,
                metadata: updated.metadata,
                isRead: 1,
                createdAt: updated.createdAt
            )
            unreadCount = max(0, unreadCount - 1)
        }

        logger.info("[Notifications] Marked notification as read: \(id)")
    }

    // MARK: - Mark All as Read

    /// Marks all notifications as read.
    func markAllAsRead() async throws {
        let endpoint = SocialEndpoints.markAllNotificationsRead()
        try await apiClient.requestNoContent(endpoint)

        // Update local state
        notifications = notifications.map { notif in
            AppNotificationDTO(
                id: notif.id,
                userId: notif.userId,
                type: notif.type,
                title: notif.title,
                body: notif.body,
                amount: notif.amount,
                metadata: notif.metadata,
                isRead: 1,
                createdAt: notif.createdAt
            )
        }
        unreadCount = 0

        logger.info("[Notifications] Marked all notifications as read")
    }

    // MARK: - Push Notification Registration

    /// Registers the device token with the backend for push notifications.
    func registerForPushNotifications() async {
        guard let token = await requestDeviceToken() else {
            logger.warning("[Notifications] No device token available")
            return
        }

        do {
            let endpoint = DeviceEndpoints.registerDevice(token: token, platform: .ios)
            try await apiClient.requestNoContent(endpoint)
            logger.info("[Notifications] Device registered for push notifications")
        } catch {
            logger.error("[Notifications] Failed to register device: \(error.localizedDescription)")
        }
    }

    // MARK: - Permission Request

    /// Requests notification permission from the user.
    /// Returns `true` if granted.
    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                logger.info("[Notifications] Permission granted")
            } else {
                logger.info("[Notifications] Permission denied")
            }
            return granted
        } catch {
            logger.error("[Notifications] Permission request failed: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Private Helpers

    /// Retrieves the current push notification device token.
    private func requestDeviceToken() async -> String? {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .authorized else {
            return nil
        }

        // The device token is typically set via AppDelegate and stored
        // For now, return the stored token from UserDefaults
        return UserDefaults.standard.string(forKey: "devicePushToken")
    }
}
