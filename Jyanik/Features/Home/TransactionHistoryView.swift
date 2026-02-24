//
//  TransactionHistoryView.swift
//  Jyanik
//
//  Full paginated list of all trades for the user's portfolio.
//

import SwiftUI

struct TransactionHistoryView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = TransactionHistoryViewModel()

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                loadingContent

            case .loaded:
                if viewModel.isEmpty {
                    emptyContent
                } else {
                    transactionList
                }

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.load() }
                }
            }
        }
        .navigationTitle("Transaction History")
        .navigationBarTitleDisplayMode(.large)
        .background(JColor.background)
        .task {
            if case .idle = viewModel.loadState {
                if appState.isGuest {
                    viewModel.loadGuestData()
                } else {
                    await viewModel.load()
                }
            }
        }
    }

    // MARK: - Transaction List

    private var transactionList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.transactions.enumerated()), id: \.element.id) { index, transaction in
                    HistoryTradeRow(trade: transaction)
                        .padding(.horizontal, JSpacing.md)
                        .padding(.vertical, JSpacing.sm)

                    if index < viewModel.transactions.count - 1 {
                        Divider()
                            .padding(.leading, JSpacing.md + 44) // align with text after icon
                    }
                }

                // Load more trigger
                if viewModel.hasMore {
                    ProgressView()
                        .padding(.vertical, JSpacing.lg)
                        .task {
                            await viewModel.loadMore()
                        }
                }
            }
            .padding(.vertical, JSpacing.xs)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Loading

    private var loadingContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { _ in
                    JSkeletonStockRow()
                }
            }
            .padding(.horizontal, JSpacing.md)
        }
    }

    // MARK: - Empty

    private var emptyContent: some View {
        JEmptyState(
            icon: "arrow.left.arrow.right.circle",
            title: "No Transactions",
            description: "Your trade history will appear here once you make your first trade."
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - History Trade Row

private struct HistoryTradeRow: View {
    let trade: TransactionDTO

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            // Side icon
            Image(systemName: isBuy ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.title2)
                .foregroundStyle(isBuy ? JColor.gainPositive : JColor.gainNegative)
                .frame(width: 36)

            // Details
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

            // Total + date
            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                Text(formattedTotal)
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                Text(formattedDate)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
        .contentShape(Rectangle())
    }

    // MARK: - Helpers

    private var isBuy: Bool { trade.side == "buy" }

    private var formattedQuantityAndPrice: String {
        let qty = trade.quantity == trade.quantity.rounded()
            ? String(format: "%.0f", trade.quantity)
            : String(format: "%.2f", trade.quantity)
        return "\(qty) shares @ $\(trade.price.formatted(.number.precision(.fractionLength(2))))"
    }

    private var formattedTotal: String {
        "$\(trade.totalValue.formatted(.number.precision(.fractionLength(2))))"
    }

    private var formattedDate: String {
        if let date = Self.isoFormatterFractional.date(from: trade.executedAt) {
            return Self.dateFormatter.string(from: date)
        }
        if let date = Self.isoFormatterBasic.date(from: trade.executedAt) {
            return Self.dateFormatter.string(from: date)
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

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy • h:mm a"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter
    }()
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TransactionHistoryView()
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
