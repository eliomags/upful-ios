//
//  SettingsViewModel.swift
//  Jyanik
//
//  ViewModel for settings and edit profile screens managing user preferences
//

import Foundation
import Observation
import OSLog

// MARK: - Appearance Mode

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "System"
    case dark = "Dark"
    case light = "Light"

    var id: String { rawValue }
}

// MARK: - Currency

enum DefaultCurrency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .usd: return "USD ($)"
        case .eur: return "EUR (\u{20AC})"
        case .gbp: return "GBP (\u{00A3})"
        }
    }
}

// MARK: - ViewModel

@Observable
final class SettingsViewModel {

    // MARK: - Settings State

    var pushNotificationsEnabled: Bool = true {
        didSet { saveSettings() }
    }

    var emailNotificationsEnabled: Bool = true {
        didSet { saveSettings() }
    }

    var appearanceMode: AppearanceMode = .system {
        didSet { saveSettings() }
    }

    var defaultCurrency: DefaultCurrency = .usd {
        didSet { saveSettings() }
    }

    // MARK: - Edit Profile State

    var displayName: String = ""
    var bio: String = ""
    var isProfileSaving: Bool = false
    var profileSaveError: String?
    var profileSaved: Bool = false

    /// Maximum bio character count.
    let maxBioLength = 200

    /// Remaining bio characters.
    var bioCharactersRemaining: Int {
        max(0, maxBioLength - bio.count)
    }

    /// Whether the bio exceeds the maximum length.
    var isBioOverLimit: Bool {
        bio.count > maxBioLength
    }

    /// Whether the profile form has valid content to save.
    var isProfileValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !isBioOverLimit
    }

    // MARK: - General State

    private(set) var isSaving: Bool = false
    private(set) var isDeleting: Bool = false

    // MARK: - Dependencies

    private let defaults = UserDefaults.standard
    private let logger = Logger(subsystem: "com.jyanik", category: "SettingsViewModel")

    // MARK: - UserDefaults Keys

    private enum Keys {
        static let pushNotifications = "settings.pushNotificationsEnabled"
        static let emailNotifications = "settings.emailNotificationsEnabled"
        static let appearanceMode = "settings.appearanceMode"
        static let defaultCurrency = "settings.defaultCurrency"
    }

    // MARK: - Init

    init() {
        loadSettings()
    }

    // MARK: - Load Settings

    /// Loads persisted settings from UserDefaults.
    func loadSettings() {
        // Push notifications (default: true)
        if defaults.object(forKey: Keys.pushNotifications) != nil {
            pushNotificationsEnabled = defaults.bool(forKey: Keys.pushNotifications)
        }

        // Email notifications (default: true)
        if defaults.object(forKey: Keys.emailNotifications) != nil {
            emailNotificationsEnabled = defaults.bool(forKey: Keys.emailNotifications)
        }

        // Appearance mode (default: system)
        if let modeRaw = defaults.string(forKey: Keys.appearanceMode),
           let mode = AppearanceMode(rawValue: modeRaw) {
            appearanceMode = mode
        }

        // Default currency (default: USD)
        if let currencyRaw = defaults.string(forKey: Keys.defaultCurrency),
           let currency = DefaultCurrency(rawValue: currencyRaw) {
            defaultCurrency = currency
        }

        logger.info("[Settings] Loaded from UserDefaults")
    }

    // MARK: - Save Settings

    /// Persists current settings to UserDefaults.
    func saveSettings() {
        defaults.set(pushNotificationsEnabled, forKey: Keys.pushNotifications)
        defaults.set(emailNotificationsEnabled, forKey: Keys.emailNotifications)
        defaults.set(appearanceMode.rawValue, forKey: Keys.appearanceMode)
        defaults.set(defaultCurrency.rawValue, forKey: Keys.defaultCurrency)

        logger.info("[Settings] Saved to UserDefaults")
    }

    // MARK: - Load Profile

    /// Loads user profile data for editing.
    func loadProfile(from user: User?) {
        guard let user else { return }
        displayName = user.displayName ?? user.username
        bio = user.bio ?? ""
    }

    // MARK: - Update Profile

    /// Simulates updating the user profile. Will connect to API later.
    func updateProfile() async {
        guard isProfileValid else { return }

        isProfileSaving = true
        profileSaveError = nil
        profileSaved = false

        // Simulate network delay
        try? await Task.sleep(for: .seconds(1))

        // In the future, this will call the API:
        // let endpoint = UserEndpoints.updateProfile(displayName: displayName, bio: bio)
        // try await apiClient.request(endpoint)

        isProfileSaving = false
        profileSaved = true

        logger.info("[Settings] Profile updated: displayName=\(self.displayName), bio=\(self.bio.prefix(20))...")
    }

    // MARK: - Sign Out

    /// Performs sign-out cleanup. The actual logout is handled by AppState.
    func signOut() async {
        isSaving = true
        defer { isSaving = false }

        // Clear local settings if desired
        // defaults.removeObject(forKey: Keys.pushNotifications)
        // etc.

        logger.info("[Settings] User signed out")
    }

    // MARK: - Delete Account

    /// Simulates account deletion. Logs the action for now.
    func deleteAccount() async {
        isDeleting = true
        defer { isDeleting = false }

        // Simulate delay
        try? await Task.sleep(for: .seconds(1))

        // In the future, this will call:
        // let endpoint = UserEndpoints.deleteAccount()
        // try await apiClient.request(endpoint)

        logger.warning("[Settings] Account deletion requested (not yet implemented)")
    }

    // MARK: - App Info

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }
}
