//
//  NotificationsViewModel.swift
//  Jyanik
//
//  ViewModel for the notification center managing notification data and state
//

import Foundation
import Observation
import OSLog

// MARK: - Notification Item

struct NotificationItem: Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    let body: String
    var isRead: Bool
    let createdAt: Date

    // MARK: - Notification Type

    enum NotificationType: String, CaseIterable {
        case tradeExecuted = "trade_executed"
        case competitionStarted = "competition_started"
        case competitionEnded = "competition_ended"
        case rankChanged = "rank_changed"
        case prizeWon = "prize_won"
        case system = "system"

        init(rawType: String) {
            self = NotificationType(rawValue: rawType) ?? .system
        }
    }

    // MARK: - Computed Properties

    var iconName: String {
        switch type {
        case .tradeExecuted: return "arrow.left.arrow.right.circle.fill"
        case .competitionStarted: return "flag.fill"
        case .competitionEnded: return "flag.checkered"
        case .rankChanged: return "chart.line.uptrend.xyaxis"
        case .prizeWon: return "trophy.fill"
        case .system: return "bell.fill"
        }
    }

    var iconColor: String {
        switch type {
        case .tradeExecuted: return "primary"
        case .competitionStarted: return "success"
        case .competitionEnded: return "info"
        case .rankChanged: return "accent"
        case .prizeWon: return "warning"
        case .system: return "secondary"
        }
    }
}

// MARK: - Notification Section

struct NotificationSection: Identifiable {
    let id: String
    let title: String
    let notifications: [NotificationItem]
}

// MARK: - Load State

enum NotificationLoadState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - ViewModel

@Observable
final class NotificationsViewModel {

    // MARK: - State

    private(set) var notifications: [NotificationItem] = []
    private(set) var loadState: NotificationLoadState = .idle
    private(set) var sections: [NotificationSection] = []

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    var hasUnread: Bool {
        unreadCount > 0
    }

    // MARK: - Dependencies

    private let logger = Logger(subsystem: "com.jyanik", category: "NotificationsViewModel")

    // MARK: - Load

    /// Loads notifications. Currently uses mock data; will integrate with NotificationService later.
    func load() async {
        guard loadState != .loading else { return }

        loadState = .loading

        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(600))

        notifications = Self.generateMockNotifications()
        sections = groupNotifications(notifications)
        loadState = .loaded

        logger.info("[Notifications] Loaded \(self.notifications.count) notifications (\(self.unreadCount) unread)")
    }

    /// Pull-to-refresh handler.
    func refresh() async {
        loadState = .loading

        try? await Task.sleep(for: .milliseconds(400))

        notifications = Self.generateMockNotifications()
        sections = groupNotifications(notifications)
        loadState = .loaded
    }

    // MARK: - Mark As Read

    /// Marks a single notification as read.
    func markAsRead(id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].isRead = true
        sections = groupNotifications(notifications)

        logger.info("[Notifications] Marked as read: \(id)")
    }

    /// Marks all notifications as read.
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        sections = groupNotifications(notifications)

        logger.info("[Notifications] Marked all as read")
    }

    // MARK: - Grouping

    /// Groups notifications into date-based sections: Today, Yesterday, This Week, Earlier.
    private func groupNotifications(_ items: [NotificationItem]) -> [NotificationSection] {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        let startOfWeek = calendar.date(byAdding: .day, value: -7, to: startOfToday)!

        var today: [NotificationItem] = []
        var yesterday: [NotificationItem] = []
        var thisWeek: [NotificationItem] = []
        var earlier: [NotificationItem] = []

        for item in items {
            if item.createdAt >= startOfToday {
                today.append(item)
            } else if item.createdAt >= startOfYesterday {
                yesterday.append(item)
            } else if item.createdAt >= startOfWeek {
                thisWeek.append(item)
            } else {
                earlier.append(item)
            }
        }

        var result: [NotificationSection] = []

        if !today.isEmpty {
            result.append(NotificationSection(id: "today", title: "Today", notifications: today))
        }
        if !yesterday.isEmpty {
            result.append(NotificationSection(id: "yesterday", title: "Yesterday", notifications: yesterday))
        }
        if !thisWeek.isEmpty {
            result.append(NotificationSection(id: "this_week", title: "This Week", notifications: thisWeek))
        }
        if !earlier.isEmpty {
            result.append(NotificationSection(id: "earlier", title: "Earlier", notifications: earlier))
        }

        return result
    }

    // MARK: - Mock Data

    private static func generateMockNotifications() -> [NotificationItem] {
        let calendar = Calendar.current
        let now = Date()

        return [
            NotificationItem(
                id: "notif_001",
                type: .tradeExecuted,
                title: "Trade Executed",
                body: "Your buy order for 10 shares of AAPL at $187.32 has been filled.",
                isRead: false,
                createdAt: calendar.date(byAdding: .minute, value: -25, to: now)!
            ),
            NotificationItem(
                id: "notif_002",
                type: .competitionStarted,
                title: "Competition Started",
                body: "\"Weekly S&P Challenge\" is now live! Start trading to climb the leaderboard.",
                isRead: false,
                createdAt: calendar.date(byAdding: .hour, value: -2, to: now)!
            ),
            NotificationItem(
                id: "notif_003",
                type: .rankChanged,
                title: "Rank Update",
                body: "You moved up to #5 in the \"Tech Titans\" competition. Keep it up!",
                isRead: false,
                createdAt: calendar.date(byAdding: .hour, value: -5, to: now)!
            ),
            NotificationItem(
                id: "notif_004",
                type: .tradeExecuted,
                title: "Trade Executed",
                body: "Your sell order for 5 shares of TSLA at $241.50 has been filled.",
                isRead: true,
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!
            ),
            NotificationItem(
                id: "notif_005",
                type: .prizeWon,
                title: "Prize Awarded",
                body: "Congratulations! You won $500 virtual cash in the \"Blue Chip Blitz\" competition.",
                isRead: true,
                createdAt: calendar.date(byAdding: .hour, value: -28, to: now)!
            ),
            NotificationItem(
                id: "notif_006",
                type: .competitionEnded,
                title: "Competition Ended",
                body: "\"Momentum Masters\" has concluded. You finished in 3rd place out of 128 traders.",
                isRead: false,
                createdAt: calendar.date(byAdding: .day, value: -3, to: now)!
            ),
            NotificationItem(
                id: "notif_007",
                type: .system,
                title: "App Update Available",
                body: "Jyanik v2.1 is available with new charting features and performance improvements.",
                isRead: true,
                createdAt: calendar.date(byAdding: .day, value: -4, to: now)!
            ),
            NotificationItem(
                id: "notif_008",
                type: .rankChanged,
                title: "Rank Update",
                body: "You dropped to #12 in the \"Penny Stock Pros\" competition. Time to make a move!",
                isRead: true,
                createdAt: calendar.date(byAdding: .day, value: -5, to: now)!
            ),
            NotificationItem(
                id: "notif_009",
                type: .tradeExecuted,
                title: "Trade Executed",
                body: "Your buy order for 25 shares of NVDA at $892.10 has been filled.",
                isRead: true,
                createdAt: calendar.date(byAdding: .day, value: -10, to: now)!
            ),
            NotificationItem(
                id: "notif_010",
                type: .competitionStarted,
                title: "New Competition",
                body: "\"Earnings Season Showdown\" starts tomorrow. Register now to secure your spot!",
                isRead: true,
                createdAt: calendar.date(byAdding: .day, value: -12, to: now)!
            ),
        ]
    }
}

// MARK: - Date Formatting

extension NotificationItem {

    /// Relative timestamp string (e.g., "25m ago", "2h ago", "3d ago").
    var relativeTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
