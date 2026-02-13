//
//  NotificationsView.swift
//  Jyanik
//
//  Notification center displaying grouped notifications with read/unread state
//

import SwiftUI

struct NotificationsView: View {

    // MARK: - Dependencies

    @Environment(AppState.self) private var appState
    @State private var viewModel = NotificationsViewModel()

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Loading notifications...")

            case .loaded:
                if viewModel.notifications.isEmpty {
                    emptyState
                } else {
                    notificationList
                }

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.load() }
                }
            }
        }
        .navigationTitle("Notifications")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.hasUnread {
                    Button {
                        viewModel.markAllAsRead()
                    } label: {
                        Text("Mark All Read")
                            .font(JFont.subheadlineMedium)
                            .foregroundStyle(JColor.primary)
                    }
                }
            }
        }
        .background(JColor.background)
        .task {
            if viewModel.loadState == .idle && !appState.isGuest {
                await viewModel.load()
            }
        }
    }
}

// MARK: - Notification List

private extension NotificationsView {

    var notificationList: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.notifications) { notification in
                        notificationRow(notification)
                            .listRowInsets(EdgeInsets(
                                top: JSpacing.xs,
                                leading: JSpacing.md,
                                bottom: JSpacing.xs,
                                trailing: JSpacing.md
                            ))
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if !notification.isRead {
                                    Button {
                                        viewModel.markAsRead(id: notification.id)
                                    } label: {
                                        Label("Read", systemImage: "envelope.open")
                                    }
                                    .tint(JColor.primary)
                                }
                            }
                    }
                } header: {
                    Text(section.title)
                        .font(JFont.footnoteSemibold)
                        .foregroundStyle(JColor.textSecondary)
                        .textCase(nil)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refresh()
        }
    }
}

// MARK: - Notification Row

private extension NotificationsView {

    func notificationRow(_ notification: NotificationItem) -> some View {
        HStack(alignment: .top, spacing: JSpacing.sm) {
            // Icon
            notificationIcon(notification)

            // Content
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                HStack {
                    Text(notification.title)
                        .font(notification.isRead ? JFont.subheadline : JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    Text(notification.relativeTimestamp)
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }

                Text(notification.body)
                    .font(JFont.footnote)
                    .foregroundStyle(JColor.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Unread indicator
            if !notification.isRead {
                Circle()
                    .fill(JColor.primary)
                    .frame(width: 8, height: 8)
                    .padding(.top, JSpacing.xxs)
            }
        }
        .padding(JSpacing.sm)
        .background(
            notification.isRead
                ? Color.clear
                : JColor.primary.opacity(0.04)
        )
        .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
        .contentShape(Rectangle())
        .onTapGesture {
            if !notification.isRead {
                viewModel.markAsRead(id: notification.id)
            }
        }
    }

    func notificationIcon(_ notification: NotificationItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: JRadius.small)
                .fill(iconColor(for: notification).opacity(0.15))
                .frame(width: 36, height: 36)

            Image(systemName: notification.iconName)
                .font(.callout)
                .foregroundStyle(iconColor(for: notification))
        }
    }

    func iconColor(for notification: NotificationItem) -> Color {
        switch notification.iconColor {
        case "primary": return JColor.primary
        case "success": return JColor.success
        case "info": return JColor.info
        case "accent": return JColor.accent
        case "warning": return JColor.warning
        case "secondary": return JColor.secondary
        default: return JColor.textSecondary
        }
    }
}

// MARK: - Empty State

private extension NotificationsView {

    var emptyState: some View {
        JEmptyState(
            icon: "bell.slash",
            title: "No Notifications Yet",
            description: "When you receive notifications about trades, competitions, and updates, they will appear here."
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationsView()
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
    .environment(AppRouter())
}
