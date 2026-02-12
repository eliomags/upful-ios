//
//  RootView.swift
//  Jyanik
//
//  Root view that routes between loading, onboarding, and main app
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.isLoading {
                LoadingScreen()
            } else if appState.isAuthenticated {
                MainTabView()
            } else {
                OnboardingPlaceholderView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: appState.isLoading)
    }
}

// MARK: - Loading Screen

private struct LoadingScreen: View {
    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            VStack(spacing: JSpacing.lg) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(JColor.primary)

                Text("Jyanik")
                    .font(JFont.largeTitle)
                    .foregroundStyle(JColor.textPrimary)

                ProgressView()
                    .tint(JColor.primary)
            }
        }
    }
}

// MARK: - Onboarding Placeholder

/// Placeholder until the full OnboardingView feature is built.
struct OnboardingPlaceholderView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            VStack(spacing: JSpacing.xl) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(JColor.primary)

                VStack(spacing: JSpacing.sm) {
                    Text("Welcome to Jyanik")
                        .font(JFont.largeTitle)
                        .foregroundStyle(JColor.textPrimary)

                    Text("Compete. Trade. Win.")
                        .font(JFont.title3)
                        .foregroundStyle(JColor.textSecondary)
                }

                VStack(spacing: JSpacing.md) {
                    JButton("Get Started", style: .primary, size: .large) {
                        // Will navigate to sign up once auth feature is built
                    }

                    JButton("Sign In", style: .secondary, size: .large) {
                        // Will navigate to sign in once auth feature is built
                    }
                }
                .padding(.horizontal, JSpacing.xl)
            }
            .padding(JSpacing.xl)
        }
    }
}

// MARK: - Previews

#Preview("Loading") {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return RootView()
        .environment(appState)
}

#Preview("Onboarding") {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return OnboardingPlaceholderView()
        .environment(appState)
}
