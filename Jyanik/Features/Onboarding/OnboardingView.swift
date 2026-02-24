//
//  OnboardingView.swift
//  Jyanik
//
//  Single-screen onboarding with Sign In, Create Account, and Guest options.
//  Login/Register are immediately visible — no multi-step funnel.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ZStack {
                JColor.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Hero section
                    VStack(spacing: JSpacing.lg) {
                        // App Logo
                        ZStack {
                            Circle()
                                .fill(JColor.primary.opacity(0.15))
                                .frame(width: 120, height: 120)

                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 52, weight: .bold))
                                .foregroundStyle(JColor.primary)
                        }

                        // Badge
                        Text("Subscribe & Win")
                            .font(JFont.footnoteSemibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, JSpacing.md)
                            .padding(.vertical, JSpacing.xs)
                            .background(JColor.primary, in: Capsule())

                        // Headline
                        VStack(spacing: JSpacing.sm) {
                            Text("Compete. Trade.\nWin Real Money.")
                                .font(JFont.largeTitle)
                                .foregroundStyle(JColor.textPrimary)
                                .multilineTextAlignment(.center)

                            Text("Join paper trading competitions with virtual cash and win real prizes.")
                                .font(JFont.body)
                                .foregroundStyle(JColor.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }

                    Spacer()

                    // Auth options — all visible on first screen
                    VStack(spacing: JSpacing.md) {
                        // Sign In (primary action for returning users)
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Sign In")
                                .font(JFont.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, JSpacing.md)
                                .background(JColor.primary, in: RoundedRectangle(cornerRadius: JRadius.small))
                        }

                        // Create Account (secondary)
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Create Account")
                                .font(JFont.headline)
                                .foregroundStyle(JColor.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, JSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: JRadius.small)
                                        .stroke(JColor.primary, lineWidth: 1.5)
                                )
                        }

                        // Guest mode
                        Button {
                            appState.loginAsGuest()
                        } label: {
                            Text("Continue as Guest")
                                .font(JFont.calloutMedium)
                                .foregroundStyle(JColor.textTertiary)
                        }
                        .padding(.top, JSpacing.xs)
                    }
                    .padding(.horizontal, JSpacing.xl)
                    .padding(.bottom, JSpacing.xxl)
                }
                .padding(.horizontal, JSpacing.lg)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return OnboardingView()
        .environment(appState)
}
