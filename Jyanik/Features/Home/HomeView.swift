//
//  HomeView.swift
//  Jyanik
//
//  Home screen = User's full portfolio.
//  Shows total balance, returns, cash balance, full holdings list,
//  active competitions, and recent trades — all from DB.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router
    @State private var viewModel = HomeViewModel()

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Loading your portfolio...")

            case .loaded:
                portfolioContent

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.loadAll() }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(JColor.background)
        .task {
            if case .idle = viewModel.loadState {
                if appState.isGuest {
                    viewModel.loadGuestData()
                } else {
                    await viewModel.loadAll()
                }
            }
        }
    }

    // MARK: - Portfolio Content

    private var portfolioContent: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.md) {
                if appState.isGuest {
                    guestBanner
                }
                portfolioHeader
                holdingsSection
                competitionsSection
                recentTradesSection
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .refreshable {
            if !appState.isGuest {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Guest Banner

    private var guestBanner: some View {
        JCard(style: .bordered) {
            VStack(spacing: JSpacing.sm) {
                HStack(spacing: JSpacing.xs) {
                    Image(systemName: "person.badge.plus")
                        .font(.title3)
                        .foregroundStyle(JColor.primary)

                    Text("Welcome to Upful")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()
                }

                Text("Sign up to start paper trading with $25,000, compete in tournaments, and win real prizes.")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    appState.logout()
                } label: {
                    Text("Create Account")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, JSpacing.xs)
                        .background(JColor.primary, in: RoundedRectangle(cornerRadius: JRadius.small))
                }
            }
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Portfolio Header (Total Balance + Returns + Cash)

    private var portfolioHeader: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            // Total Balance label
            Text("TOTAL BALANCE")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)

            // Total equity — large, bold
            Text(formattedCurrency(viewModel.totalEquity))
                .font(.system(size: 34, weight: .black))
                .foregroundStyle(JColor.textPrimary)

            // Dollar + Percent return
            HStack(spacing: JSpacing.xs) {
                Text(formattedSignedCurrency(viewModel.totalPnl))
                    .font(JFont.calloutMedium)
                    .foregroundStyle(pnlColor)

                Text("  \(formattedPercent(viewModel.totalPnlPct))")
                    .font(JFont.calloutMedium)
                    .foregroundStyle(pnlColor)
            }

            // Last Updated
            Text("Last Updated, \(formattedUpdateTime)")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
                .padding(.top, JSpacing.xxxs)

            // Cash Balance card
            HStack {
                Text("CASH BALANCE:")
                    .font(JFont.calloutMedium)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                Text(formattedCurrency(viewModel.cashBalance))
                    .font(JFont.body)
                    .foregroundStyle(JColor.textPrimary)
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
            .background(JColor.surface, in: RoundedRectangle(cornerRadius: JRadius.small))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, JSpacing.sm)
    }

    // MARK: - Holdings Section

    private var holdingsSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            // Section header
            HStack {
                Text("Holdings")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                if viewModel.hasRecentTrades {
                    Button {
                        router.navigate(to: .transactionHistory)
                    } label: {
                        Text("See History")
                            .font(JFont.subheadlineMedium)
                            .foregroundStyle(JColor.primary)
                    }
                }
            }

            if viewModel.hasPositions {
                JCard(padding: 0) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.positions.enumerated()), id: \.element.id) { index, position in
                            Button {
                                router.navigate(to: .stockDetail(ticker: position.ticker))
                            } label: {
                                HoldingRow(position: position)
                                    .padding(.horizontal, JSpacing.md)
                                    .padding(.vertical, JSpacing.sm)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    router.navigate(to: .stockDetail(ticker: position.ticker))
                                } label: {
                                    Label("View Details", systemImage: "magnifyingglass")
                                }
                                Button {
                                    router.selectedTab = .trade
                                } label: {
                                    Label("Trade", systemImage: "arrow.up.arrow.down")
                                }
                            }

                            if index < viewModel.positions.count - 1 {
                                Divider()
                                    .padding(.leading, JSpacing.md)
                            }
                        }
                    }
                }
            } else {
                // Empty holdings state
                JCardBordered {
                    VStack(spacing: JSpacing.sm) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 36))
                            .foregroundStyle(JColor.textTertiary)

                        Text("No Holdings Yet")
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        Text("Search for stocks and make your first trade to see your holdings here.")
                            .font(JFont.subheadline)
                            .foregroundStyle(JColor.textSecondary)
                            .multilineTextAlignment(.center)

                        Button {
                            router.selectedTab = .markets
                        } label: {
                            Text("Find Stocks")
                                .font(JFont.calloutMedium)
                                .foregroundStyle(JColor.primary)
                        }
                        .padding(.top, JSpacing.xxs)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, JSpacing.md)
                }
            }
        }
    }

    // MARK: - Competitions Section

    @ViewBuilder
    private var competitionsSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            HStack(spacing: JSpacing.xs) {
                Image(systemName: "trophy.fill")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.primary)

                Text("Competitions")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                Button {
                    router.selectedTab = .compete
                } label: {
                    Text("View All")
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.primary)
                }
            }
            .padding(.top, JSpacing.xs)

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
            HStack(spacing: JSpacing.xs) {
                Image(systemName: "clock.fill")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.primary)

                Text("Recent Trades")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()
            }
            .padding(.top, JSpacing.xs)

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

    // MARK: - Helpers

    private var pnlColor: Color {
        if viewModel.totalPnl > 0 { return JColor.gainPositive }
        if viewModel.totalPnl < 0 { return JColor.gainNegative }
        return JColor.textSecondary
    }

    private var formattedUpdateTime: String {
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        return "\(df.string(from: Date())) EST"
    }

    private func formattedCurrency(_ value: Double) -> String {
        Self.currencyFormatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func formattedSignedCurrency(_ value: Double) -> String {
        let prefix = value >= 0 ? "+" : ""
        return "\(prefix)\(formattedCurrency(value))"
    }

    private func formattedPercent(_ value: Double) -> String {
        let prefix = value >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.2f", value))%"
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

// MARK: - Holding Row

private struct HoldingRow: View {
    let position: PositionDTO

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            // Ticker + shares
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(position.ticker)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Text("\(formattedQuantity) shares")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()

            // Current price + avg cost
            VStack(alignment: .center, spacing: JSpacing.xxxs) {
                Text("$\((position.currentPrice ?? 0).formatted(.number.precision(.fractionLength(2))))")
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                Text("$\(position.averageCost.formatted(.number.precision(.fractionLength(2))))")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }

            // PnL
            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                JPriceChangeView(position.unrealizedPnlPct ?? 0, style: .percent)

                Text(formattedPnl)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }
            .frame(minWidth: 80, alignment: .trailing)
        }
        .contentShape(Rectangle())
    }

    private var formattedQuantity: String {
        if position.quantity == position.quantity.rounded() {
            return String(format: "%.0f", position.quantity)
        }
        return String(format: "%.2f", position.quantity)
    }

    private var formattedPnl: String {
        let prefix = position.unrealizedPnl >= 0 ? "+" : ""
        return "\(prefix)$\(abs(position.unrealizedPnl).formatted(.number.precision(.fractionLength(2))))"
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
        case 3: return Color(hex: 0xCD7F32)
        default: return JColor.textPrimary
        }
    }
}

// MARK: - Trade Row

private struct TradeRow: View {
    let trade: TransactionDTO

    var body: some View {
        HStack(spacing: JSpacing.sm) {
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

    private var isBuy: Bool { trade.side == "buy" }

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
        if let date = Self.isoFormatterFractional.date(from: trade.executedAt) {
            return Self.relativeFormatter.localizedString(for: date, relativeTo: Date())
        }
        if let date = Self.isoFormatterBasic.date(from: trade.executedAt) {
            return Self.relativeFormatter.localizedString(for: date, relativeTo: Date())
        }
        return trade.executedAt
    }

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
    .environment(AppRouter())
}
