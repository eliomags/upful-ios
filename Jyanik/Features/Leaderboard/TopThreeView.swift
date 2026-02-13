//
//  TopThreeView.swift
//  Jyanik
//
//  Podium-style visual for the top 3 leaderboard players
//

import SwiftUI

struct TopThreeView: View {

    let entries: [LeaderboardEntryDTO]
    let onTapUser: (String) -> Void

    @ViewBuilder
    var body: some View {
        if !entries.isEmpty {
            HStack(alignment: .bottom, spacing: JSpacing.sm) {
                // 2nd place - left
                if entries.count > 1 {
                    podiumItem(entry: entries[1], rank: 2, pedestalHeight: 60)
                }

                // 1st place - center, tallest
                podiumItem(entry: entries[0], rank: 1, pedestalHeight: 80)

                // 3rd place - right
                if entries.count > 2 {
                    podiumItem(entry: entries[2], rank: 3, pedestalHeight: 44)
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.top, JSpacing.md)
            .padding(.bottom, JSpacing.xs)
        }
    }

    // MARK: - Podium Item

    @ViewBuilder
    private func podiumItem(entry: LeaderboardEntryDTO, rank: Int, pedestalHeight: CGFloat) -> some View {
        let userId = entry.userId ?? entry.stableID

        Button {
            onTapUser(userId)
        } label: {
            VStack(spacing: 0) {
                // Avatar with crown for first place
                ZStack(alignment: .top) {
                    JAvatar(
                        urlString: entry.avatarUrl,
                        initials: initials(for: entry),
                        size: rank == 1 ? .large : .medium
                    )
                    .overlay(alignment: .bottom) {
                        // Medal circle at the bottom of avatar
                        medalIcon(rank: rank)
                            .offset(y: 10)
                    }

                    if rank == 1 {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.yellow)
                            .offset(y: -12)
                    }
                }
                .padding(.bottom, JSpacing.sm)

                // Username
                Text(entry.displayName ?? entry.username)
                    .font(rank == 1 ? JFont.subheadlineMedium : JFont.caption)
                    .foregroundStyle(JColor.textPrimary)
                    .lineLimit(1)

                // Growth percentage
                JPriceChangeView(entry.growthPct, style: .percent)
                    .padding(.top, JSpacing.xxxs)

                // Pedestal
                pedestal(rank: rank, height: pedestalHeight)
                    .padding(.top, JSpacing.xs)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Medal Icon

    private func medalIcon(rank: Int) -> some View {
        ZStack {
            Circle()
                .fill(medalColor(for: rank))
                .frame(width: 22, height: 22)

            Text("\(rank)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    // MARK: - Pedestal

    private func pedestal(rank: Int, height: CGFloat) -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: JRadius.small,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: JRadius.small
        )
        .fill(pedestalGradient(rank: rank))
        .frame(height: height)
        .overlay(alignment: .top) {
            UnevenRoundedRectangle(
                topLeadingRadius: JRadius.small,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: JRadius.small
            )
            .strokeBorder(medalColor(for: rank).opacity(0.3), lineWidth: 1)
        }
    }

    // MARK: - Colors

    private func medalColor(for rank: Int) -> Color {
        switch rank {
        case 1: return Color.yellow
        case 2: return Color.gray
        case 3: return Color.orange
        default: return JColor.textSecondary
        }
    }

    private func pedestalGradient(rank: Int) -> LinearGradient {
        let base = medalColor(for: rank)
        return LinearGradient(
            colors: [base.opacity(0.2), base.opacity(0.08)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Helpers

    private func initials(for entry: LeaderboardEntryDTO) -> String {
        if let displayName = entry.displayName, !displayName.isEmpty {
            let parts = displayName.split(separator: " ")
            if parts.count >= 2 {
                return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
            }
            return String(displayName.prefix(2))
        }
        return String(entry.username.prefix(2))
    }
}

// MARK: - Preview

#Preview("Top Three Podium") {
    TopThreeView(
        entries: [
            LeaderboardEntryDTO(
                id: "1", userId: "u1", rank: 1,
                username: "traderpro", displayName: "Alex Morgan",
                avatarUrl: nil, totalEquity: 125_400, growthPct: 24.5,
                subscriptionTier: "pro"
            ),
            LeaderboardEntryDTO(
                id: "2", userId: "u2", rank: 2,
                username: "stockwhiz", displayName: "Jamie Lee",
                avatarUrl: nil, totalEquity: 118_200, growthPct: 19.3,
                subscriptionTier: nil
            ),
            LeaderboardEntryDTO(
                id: "3", userId: "u3", rank: 3,
                username: "bullrunner", displayName: "Taylor Kim",
                avatarUrl: nil, totalEquity: 112_800, growthPct: 15.7,
                subscriptionTier: nil
            ),
        ],
        onTapUser: { _ in }
    )
    .background(JColor.background)
}
