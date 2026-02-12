//
//  RequestPayoutView.swift
//  Jyanik
//
//  Form for requesting a payout from earnings
//

import SwiftUI

// MARK: - Request Payout View

struct RequestPayoutView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: PayoutViewModel

    @State private var amount: String = ""
    @State private var selectedMethod: PayoutMethod = .stripe
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    private var isValidAmount: Bool {
        guard let value = Double(amount) else { return false }
        guard let balance = viewModel.balance else { return false }
        return value >= 10.0 && value <= balance.availableBalance
    }

    private var amountError: String? {
        guard !amount.isEmpty, let value = Double(amount) else { return nil }

        if value < 10.0 {
            return "Minimum payout is $10.00"
        }

        if let balance = viewModel.balance, value > balance.availableBalance {
            return "Amount exceeds available balance"
        }

        return nil
    }

    var body: some View {
        NavigationStack {
            Group {
                if showSuccess {
                    successView
                } else {
                    formView
                }
            }
            .navigationTitle("Request Payout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Form View

    private var formView: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                balanceInfoCard

                amountSection

                methodSection

                infoSection

                submitButton

                if let error = errorMessage {
                    errorView(error)
                }
            }
            .padding(JSpacing.md)
        }
        .disabled(isSubmitting)
    }

    // MARK: - Balance Info Card

    private var balanceInfoCard: some View {
        JCard {
            HStack {
                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    Text("Available Balance")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    if let balance = viewModel.balance {
                        Text(viewModel.formatCurrency(balance.availableBalance))
                            .font(JFont.title2)
                            .foregroundStyle(JColor.textPrimary)
                    }
                }

                Spacer()
            }
        }
    }

    // MARK: - Amount Section

    private var amountSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Payout Amount")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textPrimary)

            HStack {
                Text("$")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                TextField("0.00", text: $amount)
                    .font(JFont.title2)
                    .keyboardType(.decimalPad)
                    .foregroundStyle(JColor.textPrimary)
            }
            .padding(JSpacing.md)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .stroke(amountError != nil ? JColor.error : JColor.border, lineWidth: 1)
            )

            if let error = amountError {
                Text(error)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.error)
            } else {
                Text("Minimum: $10.00")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
    }

    // MARK: - Method Section

    private var methodSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Payout Method")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textPrimary)

            VStack(spacing: JSpacing.sm) {
                ForEach(PayoutMethod.allCases) { method in
                    methodCard(method)
                }
            }
        }
    }

    private func methodCard(_ method: PayoutMethod) -> some View {
        Button {
            selectedMethod = method
        } label: {
            HStack(spacing: JSpacing.sm) {
                Image(systemName: method.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(selectedMethod == method ? JColor.primary : JColor.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(
                        selectedMethod == method
                            ? JColor.primary.opacity(0.1)
                            : JColor.surfaceSecondary
                    )
                    .clipShape(Circle())

                Text(method.displayName)
                    .font(JFont.bodyBold)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                Image(systemName: selectedMethod == method ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(selectedMethod == method ? JColor.primary : JColor.border)
            }
            .padding(JSpacing.md)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .stroke(selectedMethod == method ? JColor.primary : JColor.border, lineWidth: 1)
            )
        }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        JCard {
            HStack(alignment: .top, spacing: JSpacing.sm) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(JColor.primary)

                Text("Payout will be processed within 3-5 business days. You'll receive a confirmation email once the transfer is complete.")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        JButton(
            isSubmitting ? "Processing..." : "Request Payout",
            style: .primary,
            isLoading: isSubmitting,
            isDisabled: !isValidAmount || isSubmitting
        ) {
            Task {
                await submitPayout()
            }
        }
    }

    // MARK: - Error View

    private func errorView(_ message: String) -> some View {
        HStack(alignment: .top, spacing: JSpacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundStyle(JColor.error)

            Text(message)
                .font(JFont.caption)
                .foregroundStyle(JColor.error)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(JSpacing.md)
        .background(JColor.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
    }

    // MARK: - Success View

    private var successView: some View {
        VStack(spacing: JSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(JColor.success)

            VStack(spacing: JSpacing.sm) {
                Text("Payout Requested")
                    .font(JFont.title)
                    .foregroundStyle(JColor.textPrimary)

                if let value = Double(amount) {
                    Text(viewModel.formatCurrency(value))
                        .font(JFont.priceLarge)
                        .foregroundStyle(JColor.textPrimary)
                }

                Text("Your payout request has been submitted successfully. You'll receive a confirmation email shortly.")
                    .font(JFont.body)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, JSpacing.lg)
            }

            Spacer()

            JButton("Done", style: .primary) {
                dismiss()
            }
            .padding(.horizontal, JSpacing.md)
        }
        .padding(JSpacing.md)
    }

    // MARK: - Actions

    private func submitPayout() async {
        guard let value = Double(amount) else { return }

        isSubmitting = true
        errorMessage = nil

        let success = await viewModel.requestPayout(amount: value, method: selectedMethod)

        isSubmitting = false

        if success {
            withAnimation {
                showSuccess = true
            }
        } else {
            errorMessage = "Failed to submit payout request. Please try again."
        }
    }
}

// MARK: - Preview

#Preview {
    RequestPayoutView(viewModel: PayoutViewModel())
}
