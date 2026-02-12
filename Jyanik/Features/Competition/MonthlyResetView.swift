//
//  MonthlyResetView.swift
//  Jyanik
//
//  Monthly competition reset sheet presented at the start of a new month.
//  Users choose to start fresh with $25,000 or keep their current portfolio.
//

import SwiftUI

struct MonthlyResetView: View {

    // MARK: - State

    @State private var viewModel: MonthlyResetViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        _viewModel = State(wrappedValue: MonthlyResetViewModel(competitionService: competitionService))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                JColor.background
                    .ignoresSafeArea()

                if viewModel.isComplete {
                    successContent
                } else {
                    resetContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isComplete {
                        Button("Done") { dismiss() }
                            .font(JFont.headline)
                            .foregroundStyle(JColor.primary)
                    }
                }
            }
            .task {
                await viewModel.loadLastMonthSummary()
            }
            .alert(
                "Error",
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

// MARK: - Reset Content

private extension MonthlyResetView {

    var resetContent: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                header
                lastMonthSummaryCard
                choiceCards
                confirmButton
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.lg)
        }
    }
}

// MARK: - Header

private extension MonthlyResetView {

    var header: some View {
        VStack(spacing: JSpacing.sm) {
            ZStack {
                Circle()
                    .fill(JColor.accent.opacity(0.15))
                    .frame(width: 72, height: 72)

                Image(systemName: "trophy.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(JColor.accent)
            }

            Text("New Month, New Competition!")
                .font(JFont.title2)
                .foregroundStyle(JColor.textPrimary)
                .multilineTextAlignment(.center)

            Text("Choose how you want to start this month's competition")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, JSpacing.sm)
    }
}

// MARK: - Last Month Summary Card

private extension MonthlyResetView {

    var lastMonthSummaryCard: some View {
        JCard {
            VStack(spacing: JSpacing.sm) {
                Text("Last Month's Results")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .foregroundStyle(JColor.divider)

                HStack(spacing: JSpacing.md) {
                    summaryStatItem(
                        label: "Final Equity",
                        value: viewModel.formattedEquity,
                        color: JColor.textPrimary
                    )

                    summaryStatItem(
                        label: "Growth",
                        value: viewModel.formattedGrowth,
                        color: viewModel.isGrowthPositive ? JColor.gainPositive : JColor.gainNegative
                    )

                    summaryStatItem(
                        label: "Rank",
                        value: viewModel.formattedRank,
                        color: JColor.textPrimary
                    )
                }

                if let prize = viewModel.formattedPrize {
                    HStack(spacing: JSpacing.xs) {
                        Image(systemName: "gift.fill")
                            .font(.caption)
                            .foregroundStyle(JColor.accent)

                        Text("Prize Won: \(prize)")
                            .font(JFont.calloutMedium)
                            .foregroundStyle(JColor.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, JSpacing.xxs)
                }
            }
        }
    }

    func summaryStatItem(label: String, value: String, color: Color) -> some View {
        VStack(spacing: JSpacing.xxxs) {
            Text(label)
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)

            Text(value)
                .font(JFont.calloutMedium)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Choice Cards

private extension MonthlyResetView {

    var choiceCards: some View {
        VStack(spacing: JSpacing.sm) {
            Text("Your Choice")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            choiceCard(
                choice: .new,
                icon: "sparkles",
                title: "Build New Portfolio",
                description: "Reset to $25,000 and start fresh. A clean slate for this month's competition.",
                isSelected: viewModel.selectedChoice == .new
            )

            choiceCard(
                choice: .keep,
                icon: "arrow.forward.circle",
                title: "Keep Old Portfolio",
                description: "Continue with your current positions and balance. Carry your momentum forward.",
                isSelected: viewModel.selectedChoice == .keep
            )
        }
    }

    func choiceCard(
        choice: ResetChoice,
        icon: String,
        title: String,
        description: String,
        isSelected: Bool
    ) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectChoice(choice)
            }
        } label: {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                HStack(spacing: JSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? JColor.primary.opacity(0.15) : JColor.surfaceSecondary)
                            .frame(width: 40, height: 40)

                        Image(systemName: icon)
                            .font(.body)
                            .foregroundStyle(isSelected ? JColor.primary : JColor.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text(title)
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        if choice == .new {
                            Text("$25,000")
                                .font(JFont.price)
                                .foregroundStyle(JColor.primary)
                        }
                    }

                    Spacer()

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(isSelected ? JColor.primary : JColor.textTertiary)
                }

                Text(description)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(JSpacing.md)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .strokeBorder(
                        isSelected ? JColor.primary : JColor.border,
                        lineWidth: isSelected ? 2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Confirm Button

private extension MonthlyResetView {

    var confirmButton: some View {
        JButton(
            "Confirm Choice",
            style: .primary,
            size: .large,
            isLoading: viewModel.isProcessing,
            isDisabled: !viewModel.canConfirm
        ) {
            Task { await viewModel.confirmReset() }
        }
        .padding(.top, JSpacing.xs)
    }
}

// MARK: - Success Content

private extension MonthlyResetView {

    var successContent: some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(JColor.success)

            VStack(spacing: JSpacing.xs) {
                Text("You're All Set!")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text(successMessage)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, JSpacing.lg)
            }

            Spacer()

            JButton("Start Trading", style: .primary, size: .large) {
                dismiss()
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.lg)
        }
    }

    var successMessage: String {
        switch viewModel.selectedChoice {
        case .new:
            return "Your portfolio has been reset to $25,000. Good luck this month!"
        case .keep:
            return "Your current portfolio carries over. Keep up the great work!"
        case .none:
            return "Your choice has been saved."
        }
    }
}

// MARK: - Preview

#Preview {
    MonthlyResetView()
}
