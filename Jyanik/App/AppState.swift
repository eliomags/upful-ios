//
//  AppState.swift
//  Jyanik
//
//  Observable application state managing authentication and user session.
//  Token storage is handled exclusively by KeychainService.
//  Token refresh is handled exclusively by APIClient (coalesced, retry-safe).
//

import Foundation
import Observation
import OSLog

@Observable
final class AppState {

    // MARK: - State

    var isAuthenticated: Bool = false
    var isLoading: Bool = true
    var currentUser: User?
    var hasCompletedOnboarding: Bool = false
    var isGuest: Bool = false

    // MARK: - Dependencies

    private let keychainService: KeychainService
    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "AppState")

    // MARK: - Init

    init(keychainService: KeychainService = .shared, apiClient: APIClient = .shared) {
        self.keychainService = keychainService
        self.apiClient = apiClient
        restoreSession()
    }

    // MARK: - Session Management

    private func restoreSession() {
        isLoading = true
        defer { isLoading = false }

        do {
            let storedAccess = try keychainService.loadToken(for: .accessToken)
            let storedRefresh = try keychainService.loadToken(for: .refreshToken)

            if storedAccess != nil, storedRefresh != nil {
                isAuthenticated = true
                hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
                restoreCachedUser()
            } else {
                isAuthenticated = false
            }
        } catch {
            logger.error("[AppState] Failed to restore session: \(error.localizedDescription)")
            isAuthenticated = false
        }
    }

    /// Restores basic user info from UserDefaults so the UI has a name/avatar immediately.
    private func restoreCachedUser() {
        let defaults = UserDefaults.standard
        guard let id = defaults.string(forKey: "cachedUserId"),
              let username = defaults.string(forKey: "cachedUsername") else { return }

        let user = User(
            id: id,
            username: username,
            displayName: defaults.string(forKey: "cachedDisplayName"),
            avatarUrl: defaults.string(forKey: "cachedAvatarUrl"),
            tier: defaults.string(forKey: "cachedTier") ?? "free"
        )
        currentUser = user
        logger.info("[AppState] Restored cached user: \(username)")
    }

    /// Caches essential user info to UserDefaults for instant session restore.
    private func cacheUser(_ user: User) {
        let defaults = UserDefaults.standard
        defaults.set(user.id, forKey: "cachedUserId")
        defaults.set(user.username, forKey: "cachedUsername")
        defaults.set(user.displayName, forKey: "cachedDisplayName")
        defaults.set(user.avatarUrl, forKey: "cachedAvatarUrl")
        defaults.set(user.tier, forKey: "cachedTier")
    }

    /// Clears cached user info from UserDefaults.
    private func clearCachedUser() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "cachedUserId")
        defaults.removeObject(forKey: "cachedUsername")
        defaults.removeObject(forKey: "cachedDisplayName")
        defaults.removeObject(forKey: "cachedAvatarUrl")
        defaults.removeObject(forKey: "cachedTier")
    }

    // MARK: - Fetch User from API

    /// Fetches the current user's profile from the API and caches it.
    /// Call this after session restore when cached user data is missing.
    func fetchCurrentUser() async {
        guard isAuthenticated, !isGuest else { return }

        do {
            let endpoint = UserEndpoints.getProfile()
            let userDTO: UserDTO = try await apiClient.request(endpoint)

            let user = User(
                id: userDTO.id,
                email: userDTO.email,
                username: userDTO.username,
                displayName: userDTO.displayName,
                avatarUrl: userDTO.avatarUrl,
                tier: userDTO.subscriptionTier
            )
            currentUser = user
            cacheUser(user)
            logger.info("[AppState] Fetched user from API: \(user.username)")
        } catch {
            logger.warning("[AppState] Failed to fetch user from API: \(error.localizedDescription)")
        }
    }

    // MARK: - Auth Actions

    func login(accessToken: String, refreshToken: String, user: User) {
        do {
            try keychainService.saveToken(accessToken, for: .accessToken)
            try keychainService.saveToken(refreshToken, for: .refreshToken)

            self.currentUser = user
            self.isAuthenticated = true
            self.isGuest = false
            cacheUser(user)
        } catch {
            logger.error("[AppState] Failed to persist tokens: \(error.localizedDescription)")
        }
    }

    func logout() {
        do {
            try keychainService.clearAll()
        } catch {
            logger.error("[AppState] Failed to clear keychain: \(error.localizedDescription)")
        }

        currentUser = nil
        isAuthenticated = false
        isGuest = false
        hasCompletedOnboarding = false
        clearCachedUser()
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }

    /// Allows browsing the app without a backend connection.
    func loginAsGuest() {
        let guest = User(
            id: "guest",
            email: "guest@upful.app",
            username: "GuestTrader",
            displayName: "Guest Trader",
            avatarUrl: nil,
            tier: "free"
        )
        currentUser = guest
        isAuthenticated = true
        isGuest = true
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }

    /// Updates stored tokens (called after APIClient refreshes).
    func updateTokens(access: String, refresh: String) {
        do {
            try keychainService.saveToken(access, for: .accessToken)
            try keychainService.saveToken(refresh, for: .refreshToken)
        } catch {
            logger.error("[AppState] Failed to update tokens: \(error.localizedDescription)")
        }
    }
}
