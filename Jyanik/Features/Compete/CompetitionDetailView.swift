//
//  CompetitionDetailView.swift
//  Jyanik
//
//  Detail view for a competition showing info, leaderboard, and rules
//

import SwiftUI

struct CompetitionDetailView: View {

    // MARK: - Dependencies

    @State private var viewModel: CompetitionDetailViewModel
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @State private var selectedTab: DetailTab = .leaderboard

    // MARK: - Init

    init(competition: CompetitionDTO) {
        _viewModel = State(initialValue: CompetitionDetailViewModel(competition: competition))
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.md) {
                // Competition header card
                headerCard

                // My ranking (if available)
                if viewModel.myRanking != nil {
                    myRankingCard
                }

                // Tab selector
                tabSelector

                // Tab content
                switch selectedTab {
                case .leaderboard:
                    leaderboardSection
                case .rules:
                    rulesSection
                case .prizes:
                    prizesSection
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
        }
        .background(JColor.background)
        .navigationTitle(competitionDisplayName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if appState.isGuest {
                viewModel.loadGuestData()
            } else {
                await viewModel.loadData()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Tab

    enum DetailTab: String, CaseIterable {
        case leaderboard = "Leaderboard"
        case rules = "Rules"
        case prizes = "Prizes"
    }
}

// MARK: - Header Card

private extension CompetitionDetailView {

    var headerCard: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                // Type + tier badge
                HStack {
                    Text(competitionDisplayName)
                        .font(JFont.title3)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    tierBadge
                }

                // Description
                if let description = viewModel.competition.description {
                    Text(description)
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Divider()
                    .foregroundStyle(JColor.divider)

                // Stats grid
                HStack {
                    statItem(
                        icon: "dollarsign.circle",
                        label: viewModel.competition.isPremium ? "Cash Prize" : "Virtual Prize",
                        value: viewModel.prizePoolFormatted
                    )

                    Spacer()

                    statItem(
                        icon: "person.2",
                        label: "Players",
                        value: "\(viewModel.competition.participantCount)"
                    )

                    Spacer()

                    statItem(
                        icon: "calendar",
                        label: "Ends",
                        value: viewModel.formattedDate(viewModel.competition.endDate)
                    )
                }

                // Date range
                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)

                    Text("\(viewModel.formattedDate(viewModel.competition.startDate)) - \(viewModel.formattedDate(viewModel.competition.endDate))")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                }

                // Join button (if not joined and not guest viewing)
                if !viewModel.isJoined {
                    if viewModel.competition.isPremium && appState.currentUser?.tier != "premium" && appState.currentUser?.tier != "pro" {
                        JButton("Subscribe to Join", style: .secondary, size: .medium) {
                            // Navigate to subscription
                        }
                    } else {
                        JButton("Join Competition", style: .primary, size: .medium, isLoading: viewModel.isJoining) {
                            Task { await viewModel.joinCompetition() }
                        }
                    }
                }
            }
        }
    }

    var tierBadge: some View {
        Group {
            if viewModel.competition.isPremium {
                HStack(spacing: JSpacing.xxxs) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                    Text("Premium")
                        .font(JFont.captionMedium)
                }
                .foregroundStyle(JColor.warning)
                .padding(.horizontal, JSpacing.sm)
                .padding(.vertical, JSpacing.xxxs)
                .background(JColor.warning.opacity(0.15), in: Capsule())
            } else {
                JTextBadge("Free", color: JColor.success, style: .tinted)
            }
        }
    }

    func statItem(icon: String, label: String, value: String) -> some View {
        VStack(spacing: JSpacing.xxxs) {
            HStack(spacing: JSpacing.xxxs) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(JColor.textTertiary)

                Text(label)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }

            Text(value)
                .font(JFont.calloutMedium)
                .foregroundStyle(JColor.textPrimary)
        }
    }
}

// MARK: - My Ranking Card

private extension CompetitionDetailView {

    var myRankingCard: some View {
        JCard {
            HStack(spacing: JSpacing.md) {
                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    Text("Your Ranking")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    Text(viewModel.formattedRank)
                        .font(JFont.title2)
                        .foregroundStyle(JColor.textPrimary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                    Text("Equity")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    Text(viewModel.formattedEquity)
                        .font(JFont.price)
                        .foregroundStyle(JColor.textPrimary)
                }

                VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                    Text("Growth")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    JPriceChangeBadge(viewModel.formattedGrowth, style: .percent)
                }
            }
        }
    }
}

// MARK: - Tab Selector

private extension CompetitionDetailView {

    var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(selectedTab == tab ? JFont.captionMedium : JFont.caption)
                        .foregroundStyle(selectedTab == tab ? JColor.textPrimary : JColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, JSpacing.xs)
                        .background(
                            selectedTab == tab ? JColor.surface : Color.clear,
                            in: RoundedRectangle(cornerRadius: JRadius.small)
                        )
                        .shadow(color: selectedTab == tab ? .black.opacity(0.06) : .clear, radius: 2, y: 1)
                }
                .buttonStyle(.plain)
            }
        }
        .background(JColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: JRadius.small))
    }
}

// MARK: - Leaderboard Section

private extension CompetitionDetailView {

    var leaderboardSection: some View {
        Group {
            if viewModel.isLoading && !viewModel.hasLeaderboard {
                JLoadingView("Loading leaderboard...")
                    .frame(minHeight: 200)
            } else if viewModel.hasLeaderboard {
                VStack(spacing: 0) {
                    // Top 3 podium
                    if viewModel.topThree.count >= 3 {
                        TopThreeView(entries: viewModel.topThree) { userId in
                            router.navigate(to: .userProfile(id: userId))
                        }
                        .padding(.bottom, JSpacing.sm)
                    }

                    // Section header
                    if !viewModel.remaining.isEmpty {
                        HStack {
                            Text("Rankings")
                                .font(JFont.footnoteSemibold)
                                .foregroundStyle(JColor.textSecondary)

                            Spacer()

                            Text("\(viewModel.leaderboard.count) traders")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textTertiary)
                        }
                        .padding(.horizontal, JSpacing.xxs)
                        .padding(.bottom, JSpacing.xs)
                    }

                    // Remaining entries
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
                }
            } else {
                JEmptyState(
                    icon: "trophy",
                    title: "No Rankings Yet",
                    description: "Rankings will appear once the competition starts and traders join."
                )
                .frame(minHeight: 200)
            }
        }
    }
}

// MARK: - Rules Section

private extension CompetitionDetailView {

    var rulesSection: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.md) {
                Text("Competition Rules")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                if let rules = viewModel.competition.rules {
                    Text(rules)
                        .font(JFont.body)
                        .foregroundStyle(JColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Divider()
                    .foregroundStyle(JColor.divider)

                ruleItem(icon: "clock", text: "Duration: \(viewModel.formattedDate(viewModel.competition.startDate)) to \(viewModel.formattedDate(viewModel.competition.endDate))")

                ruleItem(icon: "chart.line.uptrend.xyaxis", text: "Ranked by portfolio growth percentage")

                ruleItem(icon: "dollarsign.circle", text: "Starting balance: $25,000 virtual money")

                if viewModel.competition.isPremium {
                    ruleItem(icon: "star.fill", text: "Requires active subscription")
                    ruleItem(icon: "banknote", text: "Real cash prizes via PayPal")
                } else {
                    ruleItem(icon: "gift", text: "Win extra virtual money for your portfolio")
                    ruleItem(icon: "person.crop.circle.badge.checkmark", text: "Open to all users")
                }
            }
        }
    }

    func ruleItem(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: JSpacing.sm) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(JColor.primary)
                .frame(width: 24)

            Text(text)
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Prizes Section

private extension CompetitionDetailView {

    var prizesSection: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.md) {
                HStack {
                    Text("Prize Breakdown")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    Text(viewModel.prizePoolFormatted)
                        .font(JFont.title3)
                        .foregroundStyle(viewModel.competition.isPremium ? JColor.warning : JColor.success)
                }

                if viewModel.competition.isPremium {
                    prizeRow(rank: "1st", prize: "50% of prize pool", icon: "trophy.fill", color: JColor.warning)
                    prizeRow(rank: "2nd", prize: "30% of prize pool", icon: "trophy.fill", color: .gray)
                    prizeRow(rank: "3rd", prize: "20% of prize pool", icon: "trophy.fill", color: .orange.opacity(0.7))
                } else {
                    prizeRow(rank: "1st-3rd", prize: "Bonus virtual cash", icon: "gift.fill", color: JColor.success)
                    prizeRow(rank: "4th-10th", prize: "Smaller bonus", icon: "gift", color: JColor.info)
                    prizeRow(rank: "All", prize: "Competition badge", icon: "medal", color: JColor.primary)
                }

                Divider()
                    .foregroundStyle(JColor.divider)

                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)

                    Text(viewModel.competition.isPremium
                         ? "Cash prizes are distributed via PayPal within 3 business days."
                         : "Virtual prizes are added to your portfolio balance automatically.")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
            }
        }
    }

    func prizeRow(rank: String, prize: String, icon: String, color: Color) -> some View {
        HStack(spacing: JSpacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(rank)
                    .font(JFont.calloutMedium)
                    .foregroundStyle(JColor.textPrimary)

                Text(prize)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()
        }
        .padding(.vertical, JSpacing.xxs)
    }
}

// MARK: - Helpers

private extension CompetitionDetailView {

    var competitionDisplayName: String {
        let prefix = viewModel.competition.isPremium ? "Premium " : ""
        switch viewModel.competition.type.lowercased() {
        case "weekly": return "\(prefix)Weekly Challenge"
        case "monthly": return "\(prefix)Monthly Championship"
        case "daily": return "\(prefix)Daily Sprint"
        case "special": return "\(prefix)Special Event"
        default: return "\(prefix)\(viewModel.competition.type.capitalized)"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CompetitionDetailView(
            competition: CompetitionDTO(
                id: "preview-1",
                type: "weekly",
                status: "active",
                startDate: "2026-02-16",
                endDate: "2026-02-22",
                totalPrizePool: 500,
                participantCount: 128,
                createdAt: "2026-02-16T00:00:00Z",
                tier: "free",
                description: "Compete for extra virtual money. Top 10 earn bonus paper cash.",
                rules: "Trade any stocks. Ranked by portfolio growth %.",
                isJoined: true
            )
        )
    }
    .environment(AppRouter())
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
