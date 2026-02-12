//
//  JEmptyState.swift
//  Jyanik
//
//  Empty state view with icon, title, description, and optional action
//

import SwiftUI

struct JEmptyState: View {
    let icon: String
    let title: String
    let description: String
    var actionTitle: String?
    var action: (() -> Void)?

    init(
        icon: String,
        title: String,
        description: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: JSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(JColor.textTertiary)

            VStack(spacing: JSpacing.xs) {
                Text(title)
                    .font(JFont.title3)
                    .foregroundStyle(JColor.textPrimary)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }

            if let actionTitle, let action {
                JButton(actionTitle, style: .primary, size: .medium, action: action)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.top, JSpacing.xs)
            }
        }
        .padding(JSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Previews

#Preview("Empty Watchlist") {
    JEmptyState(
        icon: "star",
        title: "No Saved Stocks",
        description: "Add stocks to your watchlist to track them here.",
        actionTitle: "Browse Markets"
    ) {
        // action
    }
}

#Preview("Empty Competition") {
    JEmptyState(
        icon: "trophy",
        title: "No Active Competitions",
        description: "Join a competition to start trading against other players."
    )
}

#Preview("No Results") {
    JEmptyState(
        icon: "magnifyingglass",
        title: "No Results",
        description: "Try a different search term."
    )
}
