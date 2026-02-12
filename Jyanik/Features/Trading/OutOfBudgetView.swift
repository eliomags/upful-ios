//
//  OutOfBudgetView.swift
//  Jyanik
//
//  Modal presented when user's cash balance drops below $10,000
//  or when attempting a trade with insufficient funds.
//  Offers virtual cash top-up via IAP or waiting for monthly reset.
//

import SwiftUI

struct OutOfBudgetView: View {

    // MARK: - State

    @State private var viewModel: OutOfBudgetViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(portfolioService: PortfolioService = PortfolioService()) {
        _viewModel = State(wrappedValue: OutOfBudgetViewModel(portfolioService: portfolioService))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                JColor.background
                    .ignoresSafeArea()

                if viewModel.purchaseComplete {
                    purchaseSuccessContent
                } else {
                    mainContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(JColor.textTertiary)
                    }
                }
            }
            .task {
                await viewModel.loadBalance()
            }
            .alert(
                "Purchase Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.dismissError() } }
                )
            ) {
                Button("OK") { viewModel.dismissError() }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

// MARK: - Main Content

private extension OutOfBudgetView {

    var mainContent: some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            warningHeader
            balanceDisplay
            explanationText
            actionButtons
            disclaimer

            Spacer()
        }
        .padding(.horizontal, JSpacing.md)
    }
}

// MARK: - Warning Header

private extension OutOfBudgetView {

    var warningHeader: some View {
        VStack(spacing: JSpacing.sm) {
            ZStack {
                Circle()
                    .fill(JColor.warning.opacity(0.15))
                    .frame(width: 72, height: 72)

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(JColor.warning)
            }

            Text("Running Low on Cash")
                .font(JFont.title2)
                .foregroundStyle(JColor.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Balance Display

private extension OutOfBudgetView {

    var balanceDisplay: some View {
        JCard {
            VStack(spacing: JSpacing.xs) {
                Text("Current Balance")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)

                Text(viewModel.formattedBalance)
                    .font(JFont.priceLarge)
                    .foregroundStyle(viewModel.isCriticallyLow ? JColor.error : JColor.warning)

                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.caption)
                    Text("Below $10,000 threshold")
                        .font(JFont.caption)
                }
                .foregroundStyle(JColor.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Explanation Text

private extension OutOfBudgetView {

    var explanationText: some View {
        Text("Your virtual cash balance is low. Top up to keep trading!")
            .font(JFont.subheadline)
            .foregroundStyle(JColor.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, JSpacing.md)
    }
}

// MARK: - Action Buttons

private extension OutOfBudgetView {

    var actionButtons: some View {
        VStack(spacing: JSpacing.sm) {
            purchaseButton
            waitButton
        }
    }

    var purchaseButton: some View {
        JButton(
            "Buy $25,000 Virtual Cash \u{2014} $2.99",
            style: .primary,
            size: .large,
            isLoading: viewModel.isPurchasing
        ) {
            Task { await viewModel.purchaseVirtualCash() }
        }
    }

    var waitButton: some View {
        JButton(
            "Wait for Monthly Reset",
            style: .secondary,
            size: .large,
            isDisabled: viewModel.isPurchasing
        ) {
            dismiss()
        }
    }
}

// MARK: - Disclaimer

private extension OutOfBudgetView {

    var disclaimer: some View {
        Text("Virtual cash has no real monetary value")
            .font(JFont.caption)
            .foregroundStyle(JColor.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.top, JSpacing.xxs)
    }
}

// MARK: - Purchase Success Content

private extension OutOfBudgetView {

    var purchaseSuccessContent: some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(JColor.success)

            VStack(spacing: JSpacing.xs) {
                Text("Cash Added!")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text("$25,000 virtual cash has been added to your portfolio. Get back to trading!")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, JSpacing.lg)
            }

            Spacer()

            JButton("Continue Trading", style: .primary, size: .large) {
                dismiss()
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.lg)
        }
    }
}

// MARK: - Preview

#Preview {
    OutOfBudgetView()
}
