//
//  AppState.swift
//  Jyanik
//
//  Observable application state managing authentication and user session
//

import Foundation
import Observation

@Observable
final class AppState {

    // MARK: - Published State

    var isAuthenticated: Bool = false
    var isLoading: Bool = true
    var currentUser: User?
    var hasCompletedOnboarding: Bool = false

    // MARK: - Token Storage

    private(set) var accessToken: String?
    private(set) var refreshToken: String?

    // MARK: - Dependencies

    private let keychainService: KeychainService

    // MARK: - Init

    init(keychainService: KeychainService = .shared) {
        self.keychainService = keychainService
        restoreSession()
    }

    // MARK: - Session Management

    private func restoreSession() {
        isLoading = true
        defer { isLoading = false }

        do {
            let storedAccess = try keychainService.loadToken(for: .accessToken)
            let storedRefresh = try keychainService.loadToken(for: .refreshToken)

            if let storedAccess, let storedRefresh {
                accessToken = storedAccess
                refreshToken = storedRefresh
                isAuthenticated = true
                hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
            } else {
                isAuthenticated = false
            }
        } catch {
            print("[AppState] Failed to restore session: \(error.localizedDescription)")
            isAuthenticated = false
        }
    }

    // MARK: - Auth Actions

    func login(accessToken: String, refreshToken: String, user: User) {
        do {
            try keychainService.saveToken(accessToken, for: .accessToken)
            try keychainService.saveToken(refreshToken, for: .refreshToken)

            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            print("[AppState] Failed to persist tokens: \(error.localizedDescription)")
        }
    }

    func logout() {
        do {
            try keychainService.clearAll()
        } catch {
            print("[AppState] Failed to clear keychain: \(error.localizedDescription)")
        }

        accessToken = nil
        refreshToken = nil
        currentUser = nil
        isAuthenticated = false
        hasCompletedOnboarding = false
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }

    func refreshAuth() async {
        guard let currentRefresh = refreshToken else {
            logout()
            return
        }

        do {
            let url = URL(string: "\(AppConfig.API.baseURL)/auth/refresh")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["refreshToken": currentRefresh]
            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                logout()
                return
            }

            let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
            try keychainService.saveToken(decoded.accessToken, for: .accessToken)
            try keychainService.saveToken(decoded.refreshToken, for: .refreshToken)

            self.accessToken = decoded.accessToken
            self.refreshToken = decoded.refreshToken
        } catch {
            print("[AppState] Token refresh failed: \(error.localizedDescription)")
            logout()
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }

    /// Allows browsing the app without a backend connection.
    /// Creates a demo user and sets authenticated state.
    var isGuest: Bool = false

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

    func updateTokens(access: String, refresh: String) {
        do {
            try keychainService.saveToken(access, for: .accessToken)
            try keychainService.saveToken(refresh, for: .refreshToken)
            self.accessToken = access
            self.refreshToken = refresh
        } catch {
            print("[AppState] Failed to update tokens: \(error.localizedDescription)")
        }
    }
}

// MARK: - Token Refresh Response

private struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
