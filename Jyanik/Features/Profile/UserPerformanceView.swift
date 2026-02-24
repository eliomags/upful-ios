//
//  UserPerformanceView.swift
//  Jyanik
//
//  Public user profile showing competition history, stats, and performance.
//  Tapped from leaderboard or competition detail.
//

import SwiftUI

struct UserPerformanceView: View {

    // MARK: - Dependencies

    @State private var viewModel: UserPerformanceViewModel
    @Environment(AppRouter.self) private var router

    // MARK: - Init

    init(userId: String) {
        _viewModel = State(initialValue: UserPerformanceViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            JColor.background.ignoresSafeArea()

            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Loading profile...")

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.load() }
                }

            case .loaded:
                profileContent
            }
        }
        .navigationTitle(viewModel.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.loadState == .idle {
                await viewModel.load()
            }
        }
    }

    // MARK: - Profile Content

    private var profileContent: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.md) {
                // User Header
                profileHeader

                // Stats Grid
                statsGrid

                // Competition History
                if viewModel.hasHistory {
                    historySection
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        JCard {
            HStack(spacing: JSpacing.md) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(JColor.primary.opacity(0.15))
                        .frame(width: 64, height: 64)

                    Text(viewModel.initials)
                        .font(JFont.title2)
                        .foregroundStyle(JColor.primary)
                }

                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    HStack(spacing: JSpacing.xxs) {
                        Text(viewModel.displayName)
                            .font(JFont.title3)
                            .foregroundStyle(JColor.textPrimary)

                        if viewModel.isPremium {
                            Image(systemName: "crown.fill")
                                .font(.caption)
                                .foregroundStyle(JColor.warning)
                        }
                    }

                    Text("@\(viewModel.username)")
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)

                    if let memberSince = viewModel.memberSinceFormatted {
                        Text("Member since \(memberSince)")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)
                    }
                }

                Spacer()
            }
        }
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        JCard {
            VStack(spacing: JSpacing.md) {
                Text("Performance")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: JSpacing.md) {
                    statCard(
                        icon: "medal.fill",
                        value: "\(viewModel.stats?.wins ?? 0)",
                        label: "Wins"
                    )

                    statCard(
                        icon: "rosette",
                        value: "\(viewModel.stats?.topThreeFinishes ?? 0)",
                        label: "Top 3"
                    )

                    statCard(
                        icon: "chart.line.uptrend.xyaxis",
                        value: viewModel.formattedAvgGrowth,
                        label: "Avg Growth"
                    )

                    statCard(
                        icon: "number",
                        value: viewModel.formattedBestRank,
                        label: "Best Rank"
                    )

                    statCard(
                        icon: "dollarsign.circle",
                        value: viewModel.formattedTotalPrize,
                        label: "Prize Won"
                    )
                }
            }
        }
    }

    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: JSpacing.xxs) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(JColor.primary)

            Text(value)
                .font(JFont.calloutMedium)
                .foregroundStyle(JColor.textPrimary)

            Text(label)
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - History Section

    private var historySection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Competition History")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)
                .padding(.horizontal, JSpacing.xxs)

            ForEach(viewModel.history) { entry in
                historyRow(entry)
            }
        }
    }

    private func historyRow(_ entry: CompetitionHistoryEntryDTO) -> some View {
        JCard(style: .bordered) {
            HStack(spacing: JSpacing.sm) {
                // Type icon
                VStack(spacing: JSpacing.xxxs) {
                    Image(systemName: competitionIcon(entry.type ?? ""))
                        .font(.title3)
                        .foregroundStyle(JColor.primary)

                    Text(competitionTypeLabel(entry.type ?? ""))
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
                .frame(width: 50)

                // Details
                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    if let start = entry.startDate, let end = entry.endDate {
                        Text("\(JFormatters.mediumDateString(from: start)) - \(JFormatters.mediumDateString(from: end))")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)
                    }

                    HStack(spacing: JSpacing.sm) {
                        if let rank = entry.rank {
                            HStack(spacing: JSpacing.xxxs) {
                                Image(systemName: rank <= 3 ? "medal.fill" : "number")
                                    .font(.caption2)
                                    .foregroundStyle(rank <= 3 ? medalColor(rank) : JColor.textTertiary)

                                Text("#\(rank)")
                                    .font(JFont.calloutMedium)
                                    .foregroundStyle(JColor.textPrimary)
                            }
                        }

                        JPriceChangeBadge(entry.growthPct ?? 0, style: .percent)
                    }
                }

                Spacer()

                // Equity + prize
                VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                    if let ending = entry.endingEquity {
                        Text(JFormatters.prizePool(ending))
                            .font(JFont.calloutMedium)
                            .foregroundStyle(JColor.textPrimary)
                    }

                    if (entry.prizeAmount ?? 0) > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 9))
                                .foregroundStyle(JColor.warning)
                            Text("+\(JFormatters.prizePool(entry.prizeAmount ?? 0))")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.warning)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func competitionIcon(_ type: String) -> String {
        switch type.lowercased() {
        case "daily": return "sun.max"
        case "weekly": return "calendar"
        case "monthly": return "calendar.badge.clock"
        default: return "trophy"
        }
    }

    private func competitionTypeLabel(_ type: String) -> String {
        switch type.lowercased() {
        case "daily": return "Daily"
        case "weekly": return "Weekly"
        case "monthly": return "Monthly"
        default: return type.capitalized
        }
    }

    private func medalColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return JColor.textTertiary
        }
    }
}

// MARK: - Preview

#Preview("User Performance") {
    NavigationStack {
        UserPerformanceView(userId: "preview-user-id")
    }
    .environment(AppRouter())
}
