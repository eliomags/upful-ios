//
//  SubscriptionView.swift
//  Jyanik
//
//  Paywall / subscription screen presented as a sheet
//

import SwiftUI
import StoreKit

/// Paywall/subscription screen presented as a sheet
struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SubscriptionViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                JColor.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: JSpacing.xl) {
                        headerSection
                        featureComparisonSection
                        pricingSection

                        if viewModel.state == .loading {
                            loadingSection
                        } else if case .purchased = viewModel.state {
                            successSection
                        } else {
                            subscribeButton
                        }

                        restoreButton
                        legalLinksSection
                    }
                    .padding(JSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                            .foregroundStyle(JColor.textSecondary)
                    }
                }
            }
            .task {
                await viewModel.loadProducts()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: JSpacing.md) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [JColor.primary, JColor.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Unlock Premium")
                .font(JFont.largeTitle)
                .foregroundStyle(JColor.textPrimary)

            Text("Get unlimited access to all premium features")
                .font(JFont.body)
                .foregroundStyle(JColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, JSpacing.lg)
    }

    // MARK: - Feature Comparison Section

    private var featureComparisonSection: some View {
        JCard {
            VStack(spacing: JSpacing.md) {
                Text("Feature Comparison")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .background(JColor.divider)

                VStack(spacing: JSpacing.sm) {
                    featureRow(title: "Monthly Trades", free: "5", premium: "Unlimited")
                    featureRow(title: "Stock Screener", free: "Basic", premium: "Advanced")
                    featureRow(title: "Leaderboard", free: "Basic", premium: "Full Access")
                    featureRow(title: "Priority Support", free: "–", premium: "✓")
                    featureRow(title: "Exclusive Competitions", free: "–", premium: "✓")
                    featureRow(title: "Advanced Analytics", free: "–", premium: "✓")
                }
            }
            .padding(JSpacing.md)
        }
    }

    private func featureRow(title: String, free: String, premium: String) -> some View {
        HStack(spacing: JSpacing.sm) {
            Text(title)
                .font(JFont.callout)
                .foregroundStyle(JColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(free)
                .font(JFont.calloutMedium)
                .foregroundStyle(free == "–" ? JColor.textTertiary : JColor.textSecondary)
                .frame(width: 80)

            Text(premium)
                .font(JFont.calloutMedium)
                .foregroundStyle(premium == "✓" ? JColor.success : JColor.primary)
                .frame(width: 80)
        }
    }

    // MARK: - Pricing Section

    private var pricingSection: some View {
        VStack(spacing: JSpacing.md) {
            Text("Choose Your Plan")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: JSpacing.sm) {
                ForEach(viewModel.subscriptionProducts, id: \.id) { product in
                    pricingCard(for: product)
                }
            }
        }
    }

    private func pricingCard(for product: Product) -> some View {
        let isSelected = viewModel.selectedProduct?.id == product.id
        let isYearly = product.id == StoreKitService.ProductID.premiumYearly

        return Button {
            viewModel.selectProduct(product)
        } label: {
            JCard {
                HStack(spacing: JSpacing.md) {
                    VStack(alignment: .leading, spacing: JSpacing.xxs) {
                        HStack(spacing: JSpacing.xs) {
                            Text(isYearly ? "Yearly" : "Monthly")
                                .font(JFont.headline)
                                .foregroundStyle(JColor.textPrimary)

                            if isYearly {
                                JTextBadge("Save 33%", color: JColor.success, style: .filled)
                            }
                        }

                        Text(product.displayPrice)
                            .font(JFont.priceLarge)
                            .foregroundStyle(JColor.primary)

                        if isYearly {
                            Text("$3.33/month")
                                .font(JFont.caption)
                                .foregroundStyle(JColor.textTertiary)
                        }
                    }

                    Spacer()

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isSelected ? JColor.primary : JColor.border)
                }
                .padding(JSpacing.md)
            }
            .overlay(
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .strokeBorder(
                        isSelected ? JColor.primary : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subscribe Button

    private var subscribeButton: some View {
        JButton(
            subscribeButtonTitle,
            style: .primary,
            isDisabled: viewModel.selectedProduct == nil || viewModel.state == .loading
        ) {
            Task {
                await viewModel.purchase()
            }
        }
    }

    private var subscribeButtonTitle: String {
        if let product = viewModel.selectedProduct {
            return "Subscribe for \(product.displayPrice)"
        }
        return "Select a Plan"
    }

    // MARK: - Loading Section

    private var loadingSection: some View {
        VStack(spacing: JSpacing.md) {
            ProgressView()
                .tint(JColor.primary)

            Text("Processing purchase...")
                .font(JFont.callout)
                .foregroundStyle(JColor.textSecondary)
        }
        .padding(JSpacing.lg)
    }

    // MARK: - Success Section

    private var successSection: some View {
        VStack(spacing: JSpacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(JColor.success)
                .symbolEffect(.bounce, value: viewModel.state)

            Text("Welcome to Premium!")
                .font(JFont.title2)
                .foregroundStyle(JColor.textPrimary)

            Text("You now have access to all premium features")
                .font(JFont.body)
                .foregroundStyle(JColor.textSecondary)
                .multilineTextAlignment(.center)

            JButton("Get Started", style: .primary) {
                dismiss()
            }
            .padding(.top, JSpacing.sm)
        }
        .padding(JSpacing.lg)
    }

    // MARK: - Restore Button

    private var restoreButton: some View {
        Button {
            Task {
                await viewModel.restore()
            }
        } label: {
            Text("Restore Purchases")
                .font(JFont.callout)
                .foregroundStyle(JColor.textSecondary)
        }
        .disabled(viewModel.state == .loading)
    }

    // MARK: - Legal Links Section

    private var legalLinksSection: some View {
        HStack(spacing: JSpacing.sm) {
            Link("Terms of Service", destination: URL(string: "https://upful.com/terms")!)

            Text("•")
                .foregroundStyle(JColor.textTertiary)

            Link("Privacy Policy", destination: URL(string: "https://upful.com/privacy")!)
        }
        .font(JFont.caption)
        .foregroundStyle(JColor.textTertiary)
        .padding(.bottom, JSpacing.lg)
    }
}

// MARK: - Preview

#Preview("Subscription View") {
    SubscriptionView()
}
