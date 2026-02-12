//
//  HomeView.swift
//  Jyanik
//
//  Home dashboard showing portfolio summary, quick actions,
//  top movers, active competitions, and recent trades
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = HomeViewModel()

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Loading your dashboard...")

            case .loaded:
                dashboardContent

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.loadAll() }
                }
            }
        }
        .navigationTitle("Home")
        .background(JColor.background)
        .task {
            if case .idle = viewModel.loadState {
                await viewModel.loadAll()
            }
        }
    }

    // MARK: - Dashboard Content

    private var dashboardContent: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.md) {
                greetingHeader
                portfolioSummaryCard
                quickActionsRow
                topMoversSection
                activeCompetitionsSection
                recentTradesSection
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Greeting Header

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(greetingText)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)

                Text(displayName)
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)
            }

            Spacer()

            JAvatar(
                urlString: appState.currentUser?.avatarUrl,
                initials: userInitials,
                size: .medium
            )
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Portfolio Summary Card

    private var portfolioSummaryCard: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                Text("Portfolio Value")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)

                Text(formattedCurrency(viewModel.totalEquity))
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)

                HStack(spacing: JSpacing.md) {
                    JPriceChangeBadge(viewModel.totalPnlPct, style: .percent)

                    Spacer()

                    VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                        Text("Cash")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(formattedCurrency(viewModel.cashBalance))
                            .font(JFont.priceSmall)
                            .foregroundStyle(JColor.textSecondary)
                    }

                    VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                        Text("Holdings")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(formattedCurrency(viewModel.holdingsValue))
                            .font(JFont.priceSmall)
                            .foregroundStyle(JColor.textSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Quick Actions

    private var quickActionsRow: some View {
        HStack(spacing: JSpacing.sm) {
            QuickActionButton(
                icon: "cart.fill",
                title: "Buy",
                color: JColor.gainPositive
            ) {
                // Navigate to search/trade flow for buying
            }

            QuickActionButton(
                icon: "arrow.down.circle.fill",
                title: "Sell",
                color: JColor.gainNegative
            ) {
                // Navigate to portfolio positions for selling
            }

            QuickActionButton(
                icon: "star.fill",
                title: "Watchlist",
                color: JColor.accent
            ) {
                // Navigate to watchlist
            }

            QuickActionButton(
                icon: "magnifyingglass",
                title: "Search",
                color: JColor.info
            ) {
                // Open search sheet
            }
        }
    }

    // MARK: - Top Movers Section

    @ViewBuilder
    private var topMoversSection: some View {
        if viewModel.hasPositions {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                sectionHeader(title: "Top Movers", icon: "flame.fill")

                JCard(padding: 0) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.topMovers.enumerated()), id: \.element.id) { index, position in
                            TopMoverRow(position: position)
                                .padding(.horizontal, JSpacing.md)
                                .padding(.vertical, JSpacing.xs)

                            if index < viewModel.topMovers.count - 1 {
                                Divider()
                                    .padding(.leading, JSpacing.md)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Active Competitions Section

    @ViewBuilder
    private var activeCompetitionsSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            sectionHeader(title: "Competitions", icon: "trophy.fill")

            if viewModel.hasCompetitions {
                ForEach(viewModel.competitions) { competition in
                    CompetitionCard(
                        competition: competition,
                        ranking: viewModel.myRanking
                    )
                }
            } else {
                JCardBordered {
                    HStack(spacing: JSpacing.sm) {
                        Image(systemName: "trophy")
                            .font(.title2)
                            .foregroundStyle(JColor.textTertiary)

                        VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                            Text("No Active Competitions")
                                .font(JFont.headline)
                                .foregroundStyle(JColor.textPrimary)

                            Text("Join a competition to start trading against others")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - Recent Trades Section

    @ViewBuilder
    private var recentTradesSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            sectionHeader(title: "Recent Trades", icon: "clock.fill")

            if viewModel.hasRecentTrades {
                JCard(padding: 0) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.recentTrades.enumerated()), id: \.element.id) { index, trade in
                            TradeRow(trade: trade)
                                .padding(.horizontal, JSpacing.md)
                                .padding(.vertical, JSpacing.xs)

                            if index < viewModel.recentTrades.count - 1 {
                                Divider()
                                    .padding(.leading, JSpacing.md)
                            }
                        }
                    }
                }
            } else {
                JCardBordered {
                    HStack(spacing: JSpacing.sm) {
                        Image(systemName: "arrow.left.arrow.right.circle")
                            .font(.title2)
                            .foregroundStyle(JColor.textTertiary)

                        VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                            Text("No Trades Yet")
                                .font(JFont.headline)
                                .foregroundStyle(JColor.textPrimary)

                            Text("Make your first trade to see activity here")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: JSpacing.xs) {
            Image(systemName: icon)
                .font(JFont.subheadline)
                .foregroundStyle(JColor.primary)

            Text(title)
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            Spacer()
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Helpers

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    private var displayName: String {
        appState.currentUser?.displayName
            ?? appState.currentUser?.username
            ?? "Trader"
    }

    private var userInitials: String {
        let name = appState.currentUser?.displayName
            ?? appState.currentUser?.username
            ?? ""
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1)) + String(parts[1].prefix(1))
        }
        return String(name.prefix(2))
    }

    private func formattedCurrency(_ value: Double) -> String {
        Self.currencyFormatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    // MARK: - Cached Formatters

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}

// MARK: - Quick Action Button

private struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: JSpacing.xs) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12), in: Circle())

                Text(title)
                    .font(JFont.captionMedium)
                    .foregroundStyle(JColor.textPrimary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Top Mover Row

private struct TopMoverRow: View {
    let position: PositionDTO

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(position.ticker)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Text("\(formattedQuantity) shares")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                Text(formattedMarketValue)
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                JPriceChangeView(position.unrealizedPnlPct ?? 0, style: .percent)
            }
        }
        .contentShape(Rectangle())
    }

    private var formattedMarketValue: String {
        "$\(position.marketValue.formatted(.number.precision(.fractionLength(2))))"
    }

    private var formattedQuantity: String {
        if position.quantity == position.quantity.rounded() {
            return String(format: "%.0f", position.quantity)
        }
        return String(format: "%.2f", position.quantity)
    }
}

// MARK: - Competition Card

private struct CompetitionCard: View {
    let competition: CompetitionDTO
    let ranking: LeaderboardEntryDTO?

    var body: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                HStack {
                    JTextBadge(
                        competitionTypeLabel,
                        color: JColor.primary,
                        style: .tinted
                    )

                    JTextBadge(
                        competition.status.capitalized,
                        color: statusColor,
                        style: .filled
                    )

                    Spacer()

                    if let ranking {
                        HStack(spacing: JSpacing.xxs) {
                            Image(systemName: "number")
                                .font(.caption2)
                            Text("\(ranking.rank)")
                                .font(JFont.headline)
                        }
                        .foregroundStyle(rankColor(ranking.rank))
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text("Prize Pool")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(formattedPrize)
                            .font(JFont.price)
                            .foregroundStyle(JColor.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .center, spacing: JSpacing.xxxs) {
                        Text("Participants")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text("\(competition.participantCount)")
                            .font(JFont.price)
                            .foregroundStyle(JColor.textPrimary)
                    }

                    Spacer()

                    if let ranking {
                        VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                            Text("Growth")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textTertiary)

                            JPriceChangeView(ranking.growthPct, style: .percent)
                        }
                    }
                }

                // Time remaining
                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)

                    Text("Ends \(competition.endDate)")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var competitionTypeLabel: String {
        competition.type.replacingOccurrences(of: "_", with: " ").capitalized
    }

    private var statusColor: Color {
        switch competition.status {
        case "active": return JColor.success
        case "upcoming": return JColor.info
        case "ended": return JColor.textTertiary
        default: return JColor.textTertiary
        }
    }

    private var formattedPrize: String {
        Self.prizeFormatter.string(from: NSNumber(value: competition.totalPrizePool)) ?? "$0"
    }

    private static let prizeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return JColor.accent
        case 2: return JColor.textSecondary
        case 3: return Color(hex: 0xCD7F32) // bronze
        default: return JColor.textPrimary
        }
    }
}

// MARK: - Trade Row

private struct TradeRow: View {
    let trade: TransactionDTO

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            // Side indicator
            Image(systemName: isBuy ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.title3)
                .foregroundStyle(isBuy ? JColor.gainPositive : JColor.gainNegative)

            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                HStack(spacing: JSpacing.xxs) {
                    Text(trade.ticker)
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    JTextBadge(
                        isBuy ? "Buy" : "Sell",
                        color: isBuy ? JColor.gainPositive : JColor.gainNegative,
                        style: .tinted
                    )
                }

                Text(formattedQuantityAndPrice)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                Text(formattedTotal)
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                Text(formattedTime)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
        .contentShape(Rectangle())
    }

    private var isBuy: Bool {
        trade.side == "buy"
    }

    private var formattedQuantityAndPrice: String {
        let qty = trade.quantity == trade.quantity.rounded()
            ? String(format: "%.0f", trade.quantity)
            : String(format: "%.2f", trade.quantity)
        return "\(qty) @ $\(trade.price.formatted(.number.precision(.fractionLength(2))))"
    }

    private var formattedTotal: String {
        "$\(trade.totalValue.formatted(.number.precision(.fractionLength(2))))"
    }

    private var formattedTime: String {
        // Parse ISO 8601 date and show relative time
        if let date = Self.isoFormatterFractional.date(from: trade.executedAt) {
            return Self.relativeFormatter.localizedString(for: date, relativeTo: Date())
        }
        // Try without fractional seconds
        if let date = Self.isoFormatterBasic.date(from: trade.executedAt) {
            return Self.relativeFormatter.localizedString(for: date, relativeTo: Date())
        }
        return trade.executedAt
    }

    // MARK: - Cached Formatters

    private static let isoFormatterFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let isoFormatterBasic: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
