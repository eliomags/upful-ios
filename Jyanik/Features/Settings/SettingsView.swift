//
//  SettingsView.swift
//  Jyanik
//
//  Full settings screen with profile, preferences, subscription, and account management
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Dependencies

    @State private var viewModel = SettingsViewModel()
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router

    @State private var showSignOutAlert = false
    @State private var showDeleteAccountAlert = false

    // MARK: - Body

    var body: some View {
        List {
            profileSection
            preferencesSection
            subscriptionSection
            aboutSection
            dangerZoneSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .background(JColor.background)
    }
}

// MARK: - Profile Section

private extension SettingsView {

    var profileSection: some View {
        Section {
            Button {
                router.navigate(to: .editProfile)
            } label: {
                HStack(spacing: JSpacing.sm) {
                    JAvatar(
                        urlString: appState.currentUser?.avatarUrl,
                        initials: userInitials,
                        size: .large
                    )

                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text(displayName)
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        Text(appState.currentUser?.email ?? "")
                            .font(JFont.subheadline)
                            .foregroundStyle(JColor.textSecondary)

                        if let user = appState.currentUser, user.isPremium {
                            JTextBadge("Pro", color: JColor.accent, style: .filled)
                                .padding(.top, JSpacing.xxxs)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
                .padding(.vertical, JSpacing.xxs)
            }
            .buttonStyle(.plain)
        } header: {
            Text("Profile")
        }
    }

    var displayName: String {
        appState.currentUser?.displayName ?? appState.currentUser?.username ?? "User"
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

// MARK: - Preferences Section

private extension SettingsView {

    var preferencesSection: some View {
        Section {
            // Push Notifications
            Toggle(isOn: $viewModel.pushNotificationsEnabled) {
                settingsLabel(
                    icon: "bell.badge",
                    title: "Push Notifications",
                    color: JColor.error
                )
            }
            .tint(JColor.primary)

            // Email Notifications
            Toggle(isOn: $viewModel.emailNotificationsEnabled) {
                settingsLabel(
                    icon: "envelope",
                    title: "Email Notifications",
                    color: JColor.info
                )
            }
            .tint(JColor.primary)

            // Appearance
            Picker(selection: $viewModel.appearanceMode) {
                ForEach(AppearanceMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            } label: {
                settingsLabel(
                    icon: "moon.circle",
                    title: "Appearance",
                    color: JColor.secondary
                )
            }

            // Default Currency
            Picker(selection: $viewModel.defaultCurrency) {
                ForEach(DefaultCurrency.allCases) { currency in
                    Text(currency.displayName).tag(currency)
                }
            } label: {
                settingsLabel(
                    icon: "dollarsign.circle",
                    title: "Default Currency",
                    color: JColor.success
                )
            }
        } header: {
            Text("Preferences")
        }
    }
}

// MARK: - Subscription Section

private extension SettingsView {

    var subscriptionSection: some View {
        Section {
            HStack(spacing: JSpacing.sm) {
                settingsLabel(
                    icon: "crown",
                    title: "Current Plan",
                    color: JColor.accent
                )

                Spacer()

                JTextBadge(
                    currentTierDisplay,
                    color: appState.currentUser?.isPremium == true ? JColor.accent : JColor.textSecondary,
                    style: .tinted
                )
            }

            if appState.currentUser?.isPremium != true {
                Button {
                    // Will navigate to subscription/paywall screen
                } label: {
                    HStack {
                        Spacer()

                        HStack(spacing: JSpacing.xs) {
                            Image(systemName: "sparkles")
                            Text("Upgrade to Premium")
                                .font(JFont.calloutMedium)
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, JSpacing.sm)

                        Spacer()
                    }
                    .background(
                        LinearGradient(
                            colors: [JColor.primary, JColor.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: JRadius.small)
                    )
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(
                    top: JSpacing.xs,
                    leading: JSpacing.md,
                    bottom: JSpacing.xs,
                    trailing: JSpacing.md
                ))
            }
        } header: {
            Text("Subscription")
        }
    }

    var currentTierDisplay: String {
        let tier = appState.currentUser?.tier ?? "free"
        switch tier.lowercased() {
        case "premium", "pro": return "Premium"
        default: return "Free"
        }
    }
}

// MARK: - About Section

private extension SettingsView {

    var aboutSection: some View {
        Section {
            // App Version
            HStack {
                settingsLabel(
                    icon: "info.circle",
                    title: "App Version",
                    color: JColor.textSecondary
                )

                Spacer()

                Text(viewModel.appVersion)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textTertiary)
            }

            // Terms of Service
            Button {
                // Will open Terms of Service URL
            } label: {
                settingsLabel(
                    icon: "doc.text",
                    title: "Terms of Service",
                    color: JColor.info
                )
            }
            .buttonStyle(.plain)

            // Privacy Policy
            Button {
                // Will open Privacy Policy URL
            } label: {
                settingsLabel(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    color: JColor.success
                )
            }
            .buttonStyle(.plain)

            // Support & Feedback
            Button {
                // Will open support/feedback flow
            } label: {
                settingsLabel(
                    icon: "bubble.left.and.bubble.right",
                    title: "Support & Feedback",
                    color: JColor.accent
                )
            }
            .buttonStyle(.plain)
        } header: {
            Text("About")
        }
    }
}

// MARK: - Danger Zone

private extension SettingsView {

    var dangerZoneSection: some View {
        Section {
            // Sign Out
            Button {
                showSignOutAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("Sign Out")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.primary)
                    Spacer()
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    Task {
                        await viewModel.signOut()
                        appState.logout()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out of your account?")
            }

            // Delete Account
            Button {
                showDeleteAccountAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("Delete Account")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.error)
                    Spacer()
                }
            }
            .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete Account", role: .destructive) {
                    Task {
                        await viewModel.deleteAccount()
                        appState.logout()
                    }
                }
            } message: {
                Text("This action cannot be undone. All your data, portfolio history, and competition records will be permanently deleted.")
            }
        } header: {
            Text("Account")
        } footer: {
            Text("Deleting your account is permanent and cannot be reversed.")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
    }
}

// MARK: - Shared Components

private extension SettingsView {

    func settingsLabel(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: JSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.15))
                    .frame(width: 28, height: 28)

                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)
            }

            Text(title)
                .font(JFont.body)
                .foregroundStyle(JColor.textPrimary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
    .environment(AppRouter())
}
