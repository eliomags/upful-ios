//
//  CompeteView.swift
//  Jyanik
//
//  Competition hub showing active and available competitions
//

import SwiftUI

struct CompeteView: View {

    // MARK: - Dependencies

    @State private var viewModel: CompeteViewModel
    @Environment(AppRouter.self) private var router

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        _viewModel = State(wrappedValue: CompeteViewModel(competitionService: competitionService))
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.isEmpty {
                JLoadingView("Loading competitions...")
            } else if let error = viewModel.errorMessage, viewModel.isEmpty {
                JErrorView(error) {
                    Task { await viewModel.refresh() }
                }
            } else if viewModel.isEmpty {
                emptyState
            } else {
                competitionsList
            }
        }
        .navigationTitle("Compete")
        .background(JColor.background)
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

// MARK: - Competitions List

private extension CompeteView {

    var competitionsList: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.lg) {
                // Ranking banner
                if let rank = viewModel.formattedRank {
                    rankingBanner(rank: rank)
                }

                // Active Competitions Section
                if viewModel.hasActiveCompetitions {
                    competitionsSection(
                        title: "Active Competitions",
                        competitions: viewModel.activeCompetitions,
                        isActive: true
                    )
                }

                // Available Competitions Section
                if viewModel.hasAvailableCompetitions {
                    competitionsSection(
                        title: "Available Competitions",
                        competitions: viewModel.availableCompetitions,
                        isActive: false
                    )
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
        }
    }
}

// MARK: - Ranking Banner

private extension CompeteView {

    func rankingBanner(rank: String) -> some View {
        JCard {
            HStack(spacing: JSpacing.md) {
                ZStack {
                    Circle()
                        .fill(JColor.accent.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: "trophy.fill")
                        .font(.title3)
                        .foregroundStyle(JColor.accent)
                }

                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    Text("Your Ranking")
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)

                    Text(rank)
                        .font(JFont.title2)
                        .foregroundStyle(JColor.textPrimary)
                }

                Spacer()

                if let ranking = viewModel.myRanking {
                    JPriceChangeBadge(ranking.growthPct, style: .percent)
                }
            }
        }
    }
}

// MARK: - Competitions Section

private extension CompeteView {

    func competitionsSection(
        title: String,
        competitions: [CompetitionDTO],
        isActive: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            HStack {
                Text(title)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                Text("\(competitions.count)")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textTertiary)
            }
            .padding(.horizontal, JSpacing.xxs)

            ForEach(competitions) { competition in
                competitionCard(competition, isActive: isActive)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.navigate(to: .competitionDetail(id: competition.id))
                    }
            }
        }
    }
}

// MARK: - Competition Card

private extension CompeteView {

    func competitionCard(_ competition: CompetitionDTO, isActive: Bool) -> some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                // Header: type + status badge
                HStack {
                    Text(competitionDisplayName(competition.type))
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)
                        .lineLimit(1)

                    Spacer()

                    statusBadge(for: competition.status)
                }

                // Date range
                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)

                    Text("\(viewModel.formattedDate(competition.startDate)) - \(viewModel.formattedDate(competition.endDate))")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                }

                Divider()
                    .foregroundStyle(JColor.divider)

                // Stats row
                HStack {
                    statItem(
                        icon: "dollarsign.circle",
                        label: "Prize Pool",
                        value: viewModel.formattedPrizePool(competition.totalPrizePool)
                    )

                    Spacer()

                    statItem(
                        icon: "person.2",
                        label: "Players",
                        value: "\(competition.participantCount)"
                    )

                    if isActive, let rank = viewModel.formattedRank {
                        Spacer()

                        statItem(
                            icon: "chart.bar",
                            label: "Your Rank",
                            value: rank
                        )
                    }
                }

                // Join button for available competitions
                if !isActive {
                    JButton("Join Competition", style: .primary, size: .medium, isLoading: viewModel.isJoining) {
                        Task {
                            await viewModel.joinCompetition(competition)
                        }
                    }
                    .padding(.top, JSpacing.xxs)
                }
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

    func statusBadge(for status: String) -> some View {
        let badge = viewModel.competitionStatusBadge(status)
        let color: Color = {
            switch badge.color {
            case "success": return JColor.success
            case "info": return JColor.info
            case "accent": return JColor.accent
            default: return JColor.textSecondary
            }
        }()

        return JTextBadge(badge.text, color: color)
    }

    func competitionDisplayName(_ type: String) -> String {
        switch type.lowercased() {
        case "weekly":
            return "Weekly Challenge"
        case "monthly":
            return "Monthly Championship"
        case "daily":
            return "Daily Sprint"
        case "special":
            return "Special Event"
        default:
            return type.capitalized + " Competition"
        }
    }
}

// MARK: - Empty State

private extension CompeteView {

    var emptyState: some View {
        JEmptyState(
            icon: "trophy",
            title: "No Competitions",
            description: "There are no competitions available right now. Check back soon for new challenges!",
            actionTitle: "Refresh"
        ) {
            Task { await viewModel.refresh() }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CompeteView(competitionService: CompetitionService())
    }
    .environment(AppRouter())
}
