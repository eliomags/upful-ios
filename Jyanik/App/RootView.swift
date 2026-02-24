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
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: appState.isLoading)
        .task {
            // Fetch user from API if authenticated but no cached user data
            if appState.isAuthenticated && !appState.isGuest && appState.currentUser == nil {
                await appState.fetchCurrentUser()
            }
        }
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

                Text("Upful")
                    .font(JFont.largeTitle)
                    .foregroundStyle(JColor.textPrimary)

                ProgressView()
                    .tint(JColor.primary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Loading") {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return RootView()
        .environment(appState)
}
