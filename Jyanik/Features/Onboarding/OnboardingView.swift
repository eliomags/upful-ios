//
//  OnboardingView.swift
//  Jyanik
//
//  Multi-step onboarding flow: Welcome -> Feature Highlights -> Auth Choice
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var currentStep: Int = 0

    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            switch currentStep {
            case 0:
                welcomeStep
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            case 1:
                featureHighlightsStep
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            case 2:
                authChoiceStep
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            default:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: currentStep)
    }

    // MARK: - Step 1: Welcome Splash

    private var welcomeStep: some View {
        VStack(spacing: 0) {
            Spacer()

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

                    Text("Join monthly paper trading competitions with virtual cash and win real prizes. No risk, all skill.")
                        .font(JFont.body)
                        .foregroundStyle(JColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }

            Spacer()

            // CTA
            VStack(spacing: JSpacing.md) {
                JButton("Get Started", style: .primary, size: .large) {
                    currentStep = 1
                }

                Button {
                    currentStep = 2
                } label: {
                    Text("Skip")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.textSecondary)
                }
            }
            .padding(.horizontal, JSpacing.xl)
            .padding(.bottom, JSpacing.xxl)
        }
        .padding(.horizontal, JSpacing.lg)
    }

    // MARK: - Step 2: Feature Highlights

    private var featureHighlightsStep: some View {
        VStack(spacing: 0) {
            Spacer()

            TabView {
                featureCard(
                    icon: "dollarsign.arrow.circlepath",
                    title: "Paper Trade",
                    description: "Trade stocks, crypto, and ETFs completely risk-free with $25K in virtual cash. Learn the markets without losing a dime."
                )

                featureCard(
                    icon: "trophy.fill",
                    title: "Compete Monthly",
                    description: "Enter monthly trading competitions and climb the leaderboard. Show off your trading skills against other players."
                )

                featureCard(
                    icon: "banknote.fill",
                    title: "Win Real Prizes",
                    description: "Top traders win real cash prizes every month. The better you trade, the more you earn. Skill pays off."
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 380)

            Spacer()

            // Navigation
            VStack(spacing: JSpacing.md) {
                JButton("Continue", style: .primary, size: .large) {
                    currentStep = 2
                }

                Button {
                    currentStep = 0
                } label: {
                    Text("Back")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.textSecondary)
                }
            }
            .padding(.horizontal, JSpacing.xl)
            .padding(.bottom, JSpacing.xxl)
        }
    }

    private func featureCard(icon: String, title: String, description: String) -> some View {
        VStack(spacing: JSpacing.lg) {
            ZStack {
                RoundedRectangle(cornerRadius: JRadius.large)
                    .fill(JColor.primary.opacity(0.1))
                    .frame(width: 96, height: 96)

                Image(systemName: icon)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(JColor.primary)
            }

            VStack(spacing: JSpacing.sm) {
                Text(title)
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text(description)
                    .font(JFont.body)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.horizontal, JSpacing.xl)
    }

    // MARK: - Step 3: Auth Choice

    private var authChoiceStep: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: JSpacing.lg) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(JColor.primary)

                    VStack(spacing: JSpacing.xs) {
                        Text("Ready to Trade?")
                            .font(JFont.title)
                            .foregroundStyle(JColor.textPrimary)

                        Text("Create an account to start competing in paper trading competitions.")
                            .font(JFont.body)
                            .foregroundStyle(JColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                VStack(spacing: JSpacing.md) {
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Create Account")
                            .font(JFont.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, JSpacing.md)
                            .background(JColor.primary, in: RoundedRectangle(cornerRadius: JRadius.small))
                    }

                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack(spacing: JSpacing.xxs) {
                            Text("Already have an account?")
                                .font(JFont.callout)
                                .foregroundStyle(JColor.textSecondary)

                            Text("Sign In")
                                .font(JFont.calloutMedium)
                                .foregroundStyle(JColor.primary)
                        }
                    }

                    // Back button
                    Button {
                        currentStep = 1
                    } label: {
                        Text("Back")
                            .font(JFont.calloutMedium)
                            .foregroundStyle(JColor.textSecondary)
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

// MARK: - Previews

#Preview {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return OnboardingView()
        .environment(appState)
}
