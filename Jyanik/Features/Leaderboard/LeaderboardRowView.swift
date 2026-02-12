//
//  LeaderboardRowView.swift
//  Jyanik
//
//  Reusable row for a single leaderboard entry
//

import SwiftUI

struct LeaderboardRowView: View {

    let entry: LeaderboardEntryDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: JSpacing.sm) {
                // Rank badge
                rankBadge

                // Avatar
                JAvatar(
                    urlString: entry.avatarURL,
                    initials: initials(for: entry),
                    size: .small
                )

                // Name stack
                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    HStack(spacing: JSpacing.xxs) {
                        Text(entry.displayName ?? entry.username)
                            .font(JFont.subheadlineMedium)
                            .foregroundStyle(JColor.textPrimary)
                            .lineLimit(1)

                        if isPremium {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(JColor.accent)
                        }
                    }

                    Text("@\(entry.username)")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                // Growth and equity
                VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                    JPriceChangeBadge(entry.growthPct, style: .percent)

                    Text(formattedEquity)
                        .font(JFont.priceSmall)
                        .foregroundStyle(JColor.textSecondary)
                }
            }
            .padding(.vertical, JSpacing.xs)
            .padding(.horizontal, JSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Rank Badge

    private var rankBadge: some View {
        ZStack {
            if entry.rank <= 3 {
                Circle()
                    .fill(medalColor.opacity(0.15))
                    .frame(width: 32, height: 32)

                Image(systemName: "medal.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(medalColor)
            } else {
                Circle()
                    .fill(JColor.surfaceSecondary)
                    .frame(width: 32, height: 32)

                Text("\(entry.rank)")
                    .font(JFont.captionMedium)
                    .foregroundStyle(JColor.textSecondary)
            }
        }
        .frame(width: 32, height: 32)
    }

    // MARK: - Computed

    private var medalColor: Color {
        switch entry.rank {
        case 1: return Color.yellow
        case 2: return Color.gray
        case 3: return Color.orange
        default: return JColor.textSecondary
        }
    }

    private var isPremium: Bool {
        guard let tier = entry.subscriptionTier?.lowercased() else { return false }
        return tier == "pro" || tier == "premium" || tier == "elite"
    }

    private var formattedEquity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: entry.totalEquity))
            ?? "$\(Int(entry.totalEquity))"
    }

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

#Preview("Leaderboard Rows") {
    VStack(spacing: 0) {
        LeaderboardRowView(
            entry: LeaderboardEntryDTO(
                id: "1", userId: "u1", rank: 1,
                username: "traderpro", displayName: "Alex Morgan",
                avatarURL: nil, totalEquity: 125_400, growthPct: 24.5,
                subscriptionTier: "pro"
            ),
            onTap: {}
        )
        Divider().padding(.leading, 60)
        LeaderboardRowView(
            entry: LeaderboardEntryDTO(
                id: "2", userId: "u2", rank: 2,
                username: "stockwhiz", displayName: "Jamie Lee",
                avatarURL: nil, totalEquity: 118_200, growthPct: 19.3,
                subscriptionTier: nil
            ),
            onTap: {}
        )
        Divider().padding(.leading, 60)
        LeaderboardRowView(
            entry: LeaderboardEntryDTO(
                id: "5", userId: "u5", rank: 5,
                username: "newtrader", displayName: "Sam Rivera",
                avatarURL: nil, totalEquity: 98_750, growthPct: -2.1,
                subscriptionTier: nil
            ),
            onTap: {}
        )
    }
    .background(JColor.background)
}
