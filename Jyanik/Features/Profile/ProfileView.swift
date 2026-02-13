//
//  ProfileView.swift
//  Jyanik
//
//  User profile screen with stats, portfolio summary, and settings
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Dependencies

    @State private var viewModel: ProfileViewModel
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router

    @State private var showSignOutConfirmation = false

    // MARK: - Init

    init(portfolioService: PortfolioService = PortfolioService(), competitionService: CompetitionService = CompetitionService()) {
        _viewModel = State(wrappedValue: ProfileViewModel(
            portfolioService: portfolioService,
            competitionService: competitionService
        ))
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.lg) {
                profileHeader
                statsRow
                portfolioSummaryCard
                settingsSection
                signOutSection
                versionInfo
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
        }
        .navigationTitle("Profile")
        .background(JColor.background)
        .task {
            if !appState.isGuest {
                await viewModel.loadData()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .alert("Sign Out", isPresented: $showSignOutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

// MARK: - Profile Header

private extension ProfileView {

    var profileHeader: some View {
        JCard {
            HStack(spacing: JSpacing.md) {
                JAvatar(
                    urlString: appState.currentUser?.avatarUrl,
                    initials: userInitials,
                    size: .large
                )

                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    Text(displayName)
                        .font(JFont.title3)
                        .foregroundStyle(JColor.textPrimary)

                    Text("@\(username)")
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)

                    if let user = appState.currentUser, user.isPremium {
                        JTextBadge("Pro", color: JColor.accent, style: .filled)
                    }
                }

                Spacer()

                Button {
                    router.navigate(to: .editProfile)
                } label: {
                    Image(systemName: "pencil.circle")
                        .font(.title2)
                        .foregroundStyle(JColor.primary)
                }
            }
        }
    }

    var displayName: String {
        appState.currentUser?.displayName ?? appState.currentUser?.username ?? "User"
    }

    var username: String {
        appState.currentUser?.username ?? "unknown"
    }

    var userInitials: String {
        let name = displayName
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        }
        return String(name.prefix(2))
    }
}

// MARK: - Stats Row

private extension ProfileView {

    var statsRow: some View {
        HStack(spacing: JSpacing.sm) {
            statCard(
                title: "Total Trades",
                value: "\(viewModel.totalTrades)",
                icon: "arrow.left.arrow.right"
            )

            statCard(
                title: "Win Rate",
                value: viewModel.formattedWinRate(),
                icon: "chart.line.uptrend.xyaxis"
            )

            statCard(
                title: "Competitions",
                value: "\(viewModel.competitionsWon)",
                icon: "trophy"
            )
        }
    }

    func statCard(title: String, value: String, icon: String) -> some View {
        JCard {
            VStack(spacing: JSpacing.xs) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(JColor.primary)

                Text(value)
                    .font(JFont.title3)
                    .foregroundStyle(JColor.textPrimary)

                Text(title)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Portfolio Summary Card

private extension ProfileView {

    var portfolioSummaryCard: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                HStack {
                    Text("Portfolio Summary")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    if viewModel.isLoading {
                        JInlineLoading()
                    }
                }

                // Total Value
                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    Text("Total Value")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)

                    HStack(alignment: .firstTextBaseline, spacing: JSpacing.xs) {
                        Text(viewModel.formattedCurrency(viewModel.portfolioValue))
                            .font(JFont.priceLarge)
                            .foregroundStyle(JColor.textPrimary)

                        JPriceChangeView(viewModel.portfolioGainPct, style: .percent)
                    }
                }

                Divider()
                    .foregroundStyle(JColor.divider)

                // Breakdown
                HStack {
                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text("Cash")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(viewModel.formattedCurrency(viewModel.cashBalance))
                            .font(JFont.calloutMedium)
                            .foregroundStyle(JColor.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text("Holdings")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(viewModel.formattedCurrency(viewModel.holdingsValue))
                            .font(JFont.calloutMedium)
                            .foregroundStyle(JColor.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text("Total P&L")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        Text(viewModel.formattedCurrency(viewModel.totalPnl))
                            .font(JFont.calloutMedium)
                            .foregroundStyle(viewModel.totalPnl >= 0 ? JColor.gainPositive : JColor.gainNegative)
                    }
                }
            }
        }
    }
}

// MARK: - Settings Section

private extension ProfileView {

    var settingsSection: some View {
        JCard(padding: 0) {
            VStack(spacing: 0) {
                settingsHeader

                settingsRow(
                    icon: "bell",
                    title: "Notifications",
                    color: JColor.info
                ) {
                    router.navigate(to: .notificationList)
                }

                Divider()
                    .padding(.leading, JSpacing.xl + JSpacing.md)

                settingsRow(
                    icon: "lock.shield",
                    title: "Privacy & Security",
                    color: JColor.success
                ) {
                    router.navigate(to: .settings)
                }

                Divider()
                    .padding(.leading, JSpacing.xl + JSpacing.md)

                settingsRow(
                    icon: "questionmark.circle",
                    title: "Help & Support",
                    color: JColor.accent
                ) {
                    router.navigate(to: .settings)
                }
            }
        }
    }

    var settingsHeader: some View {
        HStack {
            Text("Settings")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            Spacer()
        }
        .padding(.horizontal, JSpacing.md)
        .padding(.top, JSpacing.md)
        .padding(.bottom, JSpacing.xs)
    }

    func settingsRow(
        icon: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: JSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: JRadius.small)
                        .fill(color.opacity(0.15))
                        .frame(width: 32, height: 32)

                    Image(systemName: icon)
                        .font(.callout)
                        .foregroundStyle(color)
                }

                Text(title)
                    .font(JFont.body)
                    .foregroundStyle(JColor.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sign Out Section

private extension ProfileView {

    var signOutSection: some View {
        JButton("Sign Out", style: .destructive, size: .large) {
            showSignOutConfirmation = true
        }
    }
}

// MARK: - Version Info

private extension ProfileView {

    var versionInfo: some View {
        VStack(spacing: JSpacing.xxs) {
            Text("Upful")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textTertiary)

            Text(viewModel.appVersion)
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, JSpacing.md)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView(
            portfolioService: PortfolioService(),
            competitionService: CompetitionService()
        )
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
    .environment(AppRouter())
}
