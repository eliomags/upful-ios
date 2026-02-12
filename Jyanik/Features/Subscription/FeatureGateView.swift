//
//  FeatureGateView.swift
//  Jyanik
//
//  Reusable overlay/banner shown when free users try to access premium features
//

import SwiftUI

/// Reusable overlay/banner shown when free users try to access premium features
struct FeatureGateView: View {

    // MARK: - Properties

    let feature: String
    var onUpgrade: (() -> Void)?

    @State private var showSubscriptionSheet = false

    // MARK: - Initialization

    init(
        feature: String = "premium feature",
        onUpgrade: (() -> Void)? = nil
    ) {
        self.feature = feature
        self.onUpgrade = onUpgrade
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Semi-transparent background overlay
            JColor.overlay
                .ignoresSafeArea()

            // Gate card
            JCard {
                VStack(spacing: JSpacing.md) {
                    iconSection
                    contentSection
                    actionButton
                }
                .padding(JSpacing.lg)
            }
            .padding(JSpacing.md)
            .frame(maxWidth: 400)
        }
        .sheet(isPresented: $showSubscriptionSheet) {
            SubscriptionView()
        }
    }

    // MARK: - Icon Section

    private var iconSection: some View {
        Image(systemName: "lock.circle.fill")
            .font(.system(size: 56))
            .foregroundStyle(
                LinearGradient(
                    colors: [JColor.primary, JColor.accent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(spacing: JSpacing.xs) {
            Text("Premium Feature")
                .font(JFont.title2)
                .foregroundStyle(JColor.textPrimary)

            Text(featureDescription)
                .font(JFont.body)
                .foregroundStyle(JColor.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Action Button

    private var actionButton: some View {
        JButton("Upgrade Now", style: .primary) {
            onUpgrade?()
            showSubscriptionSheet = true
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Helpers

    private var featureDescription: String {
        switch feature.lowercased() {
        case "unlimited trades":
            return "Unlock unlimited paper trades to practice without limits"
        case "advanced screener":
            return "Access advanced filters and screening tools to find the best stocks"
        case "full leaderboard":
            return "View complete leaderboard rankings and compete with all traders"
        case "priority support":
            return "Get priority customer support and faster response times"
        case "exclusive competitions":
            return "Join exclusive trading competitions and win prizes"
        case "advanced analytics":
            return "Access advanced charts, indicators, and portfolio analytics"
        default:
            return "Upgrade to premium to access \(feature) and more"
        }
    }
}

// MARK: - View Extension

extension View {
    /// Shows a feature gate overlay if the condition is met
    func featureGate(
        _ feature: String,
        isLocked: Bool,
        onUpgrade: (() -> Void)? = nil
    ) -> some View {
        overlay {
            if isLocked {
                FeatureGateView(feature: feature, onUpgrade: onUpgrade)
            }
        }
    }
}

// MARK: - Preview

#Preview("Feature Gate") {
    ZStack {
        VStack {
            Text("Trading View")
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(JColor.background)

        FeatureGateView(feature: "unlimited trades")
    }
}

#Preview("Using View Extension") {
    VStack {
        Text("Premium Content")
            .font(.title)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(JColor.background)
    .featureGate("exclusive competitions", isLocked: true)
}
