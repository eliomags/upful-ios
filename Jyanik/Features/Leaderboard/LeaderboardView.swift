//
//  LeaderboardView.swift
//  Jyanik
//
//  Full leaderboard screen with ranking, period/tab pickers, top-3 podium, and scrollable list
//

import SwiftUI

struct LeaderboardView: View {

    @Environment(AppRouter.self) private var router

    @State private var viewModel: LeaderboardViewModel

    init(competitionService: CompetitionService = CompetitionService()) {
        _viewModel = State(initialValue: LeaderboardViewModel(competitionService: competitionService))
    }

    var body: some View {
        ZStack {
            JColor.background.ignoresSafeArea()

            switch viewModel.loadState {
            case .idle where !viewModel.hasEntries,
                 .loading where !viewModel.hasEntries:
                JLoadingView("Loading leaderboard...")

            case .error(let message) where !viewModel.hasEntries:
                JErrorView(message) {
                    Task { await viewModel.refresh() }
                }

            default:
                leaderboardContent
            }
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if viewModel.loadState == .idle {
                await viewModel.load()
            }
        }
    }

    // MARK: - Main Content

    private var leaderboardContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // My Ranking Card
                myRankingCard
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.md)

                // Period Picker
                periodPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Tab Picker
                tabPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.md)

                // Top 3 Podium
                if viewModel.topThree.count >= 3 {
                    TopThreeView(entries: viewModel.topThree) { userId in
                        router.navigate(to: .userProfile(id: userId))
                    }
                    .padding(.bottom, JSpacing.md)
                }

                // Remaining entries divider
                if !viewModel.remaining.isEmpty {
                    sectionHeader
                        .padding(.horizontal, JSpacing.md)
                        .padding(.bottom, JSpacing.xs)
                }

                // Scrollable list of rank 4+
                ForEach(viewModel.remaining, id: \.stableID) { entry in
                    VStack(spacing: 0) {
                        LeaderboardRowView(entry: entry) {
                            if let userId = entry.userId {
                                router.navigate(to: .userProfile(id: userId))
                            }
                        }

                        if entry.stableID != viewModel.remaining.last?.stableID {
                            Divider()
                                .foregroundStyle(JColor.divider)
                                .padding(.leading, 60)
                        }
                    }
                }

                // Empty state when filters yield no results
                if viewModel.entries.isEmpty && viewModel.loadState == .loaded {
                    JEmptyState(
                        icon: "trophy",
                        title: "No Rankings Yet",
                        description: "There are no rankings available for this period and category."
                    )
                    .padding(.top, JSpacing.xl)
                }
            }
            .padding(.top, JSpacing.sm)
            .padding(.bottom, JSpacing.xxl)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - My Ranking Card

    private var myRankingCard: some View {
        JCard {
            VStack(spacing: JSpacing.sm) {
                HStack {
                    Text("My Ranking")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    if viewModel.myRanking != nil {
                        JTextBadge(viewModel.formattedRank, color: JColor.primary, style: .tinted)
                    }
                }

                if let ranking = viewModel.myRanking {
                    HStack(spacing: JSpacing.lg) {
                        // Equity
                        VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                            Text("Total Equity")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)

                            Text(viewModel.formattedEquity)
                                .font(JFont.price)
                                .foregroundStyle(JColor.textPrimary)
                        }

                        Spacer()

                        // Growth
                        VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                            Text("Growth")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)

                            JPriceChangeBadge(ranking.growthPct, style: .percent)
                        }
                    }
                } else {
                    HStack {
                        Text("Join a competition to see your ranking")
                            .font(JFont.subheadline)
                            .foregroundStyle(JColor.textSecondary)

                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Period Picker

    private var periodPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: JSpacing.xs) {
                ForEach(allPeriods, id: \.self) { period in
                    periodButton(period)
                }
            }
        }
    }

    private func periodButton(_ period: LeaderboardPeriod) -> some View {
        let isSelected = viewModel.selectedPeriod == period

        return Button {
            Task { await viewModel.changePeriod(period) }
        } label: {
            Text(periodLabel(period))
                .font(isSelected ? JFont.subheadlineMedium : JFont.subheadline)
                .foregroundStyle(isSelected ? .white : JColor.textSecondary)
                .padding(.horizontal, JSpacing.md)
                .padding(.vertical, JSpacing.xs)
                .background(
                    isSelected ? JColor.primary : JColor.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(allTabs, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .background(JColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: JRadius.small))
    }

    private func tabButton(_ tab: LeaderboardTab) -> some View {
        let isSelected = viewModel.selectedTab == tab

        return Button {
            Task { await viewModel.changeTab(tab) }
        } label: {
            Text(tabLabel(tab))
                .font(isSelected ? JFont.captionMedium : JFont.caption)
                .foregroundStyle(isSelected ? JColor.textPrimary : JColor.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, JSpacing.xs)
                .background(
                    isSelected ? JColor.surface : Color.clear,
                    in: RoundedRectangle(cornerRadius: JRadius.small)
                )
                .shadow(color: isSelected ? .black.opacity(0.06) : .clear, radius: 2, y: 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section Header

    private var sectionHeader: some View {
        HStack {
            Text("Rankings")
                .font(JFont.footnoteSemibold)
                .foregroundStyle(JColor.textSecondary)

            Spacer()

            Text("\(viewModel.entries.count) traders")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
    }

    // MARK: - Data & Labels

    private var allPeriods: [LeaderboardPeriod] {
        [.daily, .weekly, .monthly, .allTime]
    }

    private var allTabs: [LeaderboardTab] {
        [.topGainers, .topLosers, .mostActive]
    }

    private func periodLabel(_ period: LeaderboardPeriod) -> String {
        switch period {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .allTime: return "All Time"
        }
    }

    private func tabLabel(_ tab: LeaderboardTab) -> String {
        switch tab {
        case .topGainers: return "Top Gainers"
        case .topLosers: return "Top Losers"
        case .mostActive: return "Most Active"
        }
    }
}

// MARK: - Preview

#Preview("Leaderboard") {
    NavigationStack {
        LeaderboardView()
            .environment(AppRouter())
    }
}
