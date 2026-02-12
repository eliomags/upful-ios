//
//  PayoutHistoryView.swift
//  Jyanik
//
//  Displays payout history and balance with request payout option
//

import SwiftUI

// MARK: - Payout History View

struct PayoutHistoryView: View {
    @State private var viewModel = PayoutViewModel()
    @State private var showingRequestSheet = false
    @State private var isRefreshing = false

    var body: some View {
        Group {
            switch viewModel.historyLoadState {
            case .idle, .loading:
                JLoadingView("Loading earnings...")
            case .loaded:
                if viewModel.history.isEmpty {
                    emptyState
                } else {
                    contentView
                }
            case .error(let message):
                JErrorView(message) {
                    Task { await loadData() }
                }
            }
        }
        .navigationTitle("Earnings & Payouts")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingRequestSheet) {
            RequestPayoutView(viewModel: viewModel)
        }
        .task {
            if viewModel.historyLoadState == .idle {
                await loadData()
            }
        }
    }

    // MARK: - Content View

    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.lg) {
                balanceCard

                requestPayoutButton

                historyList
            }
            .padding(JSpacing.md)
        }
        .refreshable {
            await refreshData()
        }
    }

    // MARK: - Balance Card

    private var balanceCard: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.md) {
                Text("Available Balance")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)

                if let balance = viewModel.balance {
                    Text(viewModel.formatCurrency(balance.availableBalance))
                        .font(JFont.priceLarge)
                        .foregroundStyle(JColor.textPrimary)

                    Divider()
                        .background(JColor.divider)

                    HStack {
                        VStack(alignment: .leading, spacing: JSpacing.xxs) {
                            Text("Pending")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)
                            Text(viewModel.formatCurrency(balance.pendingBalance))
                                .font(JFont.calloutMedium)
                                .foregroundStyle(JColor.textPrimary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: JSpacing.xxs) {
                            Text("Total Earned")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textSecondary)
                            Text(viewModel.formatCurrency(balance.totalEarned))
                                .font(JFont.calloutMedium)
                                .foregroundStyle(JColor.success)
                        }
                    }
                } else {
                    JLoadingView("Loading balance...")
                        .frame(height: 100)
                }
            }
        }
    }

    // MARK: - Request Payout Button

    private var requestPayoutButton: some View {
        JButton(
            "Request Payout",
            style: .primary,
            isDisabled: !viewModel.canRequestPayout
        ) {
            showingRequestSheet = true
        }
    }

    // MARK: - History List

    private var historyList: some View {
        LazyVStack(alignment: .leading, spacing: JSpacing.md) {
            Text("Payout History")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            ForEach(viewModel.groupedHistory, id: \.month) { group in
                VStack(alignment: .leading, spacing: JSpacing.sm) {
                    Text(group.month)
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textSecondary)
                        .padding(.top, JSpacing.xs)

                    ForEach(group.items) { item in
                        historyRow(item)
                    }
                }
            }
        }
    }

    // MARK: - History Row

    private func historyRow(_ item: PayoutHistoryItemDTO) -> some View {
        JCard {
            HStack(spacing: JSpacing.sm) {
                // Method Icon
                Image(systemName: payoutMethodIcon(item.method))
                    .font(.system(size: 20))
                    .foregroundStyle(JColor.primary)
                    .frame(width: 40, height: 40)
                    .background(JColor.primary.opacity(0.1))
                    .clipShape(Circle())

                // Info
                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    HStack {
                        Text(viewModel.formatCurrency(item.amount))
                            .font(JFont.bodyBold)
                            .foregroundStyle(JColor.textPrimary)

                        Spacer()

                        JTextBadge(
                            item.statusDisplayText,
                            color: badgeColor(for: item.status)
                        )
                    }

                    HStack {
                        Text(payoutMethodName(item.method))
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)

                        Text("•")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(viewModel.formatDate(item.requestedAt))
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        JEmptyState(
            icon: "dollarsign.circle",
            title: "No Payouts Yet",
            description: "Your payout history will appear here once you request your first payout."
        )
    }

    // MARK: - Helpers

    private func payoutMethodIcon(_ method: String) -> String {
        PayoutMethod(rawValue: method.lowercased())?.icon ?? "questionmark.circle.fill"
    }

    private func payoutMethodName(_ method: String) -> String {
        PayoutMethod(rawValue: method.lowercased())?.displayName ?? method.capitalized
    }

    private func badgeColor(for status: String) -> Color {
        switch status.lowercased() {
        case "completed":
            return JColor.success
        case "pending":
            return JColor.warning
        case "failed":
            return JColor.error
        default:
            return JColor.textSecondary
        }
    }

    private func loadData() async {
        async let balanceTask: () = viewModel.loadBalance()
        async let historyTask: () = viewModel.loadHistory()

        await balanceTask
        await historyTask
    }

    private func refreshData() async {
        isRefreshing = true
        await loadData()
        isRefreshing = false
    }
}

// MARK: - Preview

#Preview("With Data") {
    NavigationStack {
        PayoutHistoryView()
    }
}

#Preview("Empty State") {
    NavigationStack {
        PayoutHistoryView()
    }
}
