//
//  AuthService.swift
//  Jyanik
//
//  Manages authentication state, token lifecycle, and user session
//

import Foundation
import Observation
import OSLog

@Observable
final class AuthService {

    // MARK: - State

    private(set) var isAuthenticated = false
    private(set) var isLoading = false
    private(set) var currentUser: UserDTO?

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let keychain: KeychainService
    private let logger = Logger(subsystem: "com.jyanik", category: "AuthService")

    // MARK: - Init

    init(
        apiClient: APIClient = .shared,
        keychain: KeychainService = .shared
    ) {
        self.apiClient = apiClient
        self.keychain = keychain
    }

    // MARK: - Register

    @discardableResult
    func register(email: String, username: String, password: String) async throws -> UserDTO {
        isLoading = true
        defer { isLoading = false }

        let endpoint = AuthEndpoints.register(email: email, username: username, password: password)
        let response: AuthResponseDTO = try await apiClient.request(endpoint)

        try persistTokens(response.tokens)

        currentUser = response.user
        isAuthenticated = true

        logger.info("[Auth] Registered user: \(response.user.username)")
        return response.user
    }

    // MARK: - Login

    @discardableResult
    func login(email: String, password: String) async throws -> UserDTO {
        isLoading = true
        defer { isLoading = false }

        let endpoint = AuthEndpoints.login(email: email, password: password)
        let response: AuthResponseDTO = try await apiClient.request(endpoint)

        try persistTokens(response.tokens)

        currentUser = response.user
        isAuthenticated = true

        logger.info("[Auth] Logged in user: \(response.user.username)")
        return response.user
    }

    // MARK: - Sign in with Apple

    @discardableResult
    func loginWithApple(
        identityToken: String,
        authorizationCode: String,
        fullName: PersonNameComponents? = nil
    ) async throws -> UserDTO {
        isLoading = true
        defer { isLoading = false }

        let displayName: String? = {
            guard let fullName else { return nil }
            let parts = [fullName.givenName, fullName.familyName].compactMap { $0 }
            return parts.isEmpty ? nil : parts.joined(separator: " ")
        }()

        let endpoint = AuthEndpoints.loginWithApple(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: displayName
        )
        let response: AuthResponseDTO = try await apiClient.request(endpoint)

        try persistTokens(response.tokens)

        currentUser = response.user
        isAuthenticated = true

        logger.info("[Auth] Apple sign-in for user: \(response.user.username)")
        return response.user
    }

    // MARK: - Token Refresh

    func refreshTokens() async throws {
        guard let refreshToken = try? keychain.loadToken(for: .refreshToken) else {
            logger.warning("[Auth] No refresh token found, logging out")
            await logout()
            return
        }

        let endpoint = AuthEndpoints.refreshToken(refreshToken: refreshToken)
        let response: RefreshTokenResponseDTO = try await apiClient.request(endpoint)

        try keychain.saveToken(response.accessToken, for: .accessToken)
        try keychain.saveToken(response.refreshToken, for: .refreshToken)

        logger.debug("[Auth] Tokens refreshed successfully")
    }

    // MARK: - Forgot Password

    func forgotPassword(email: String) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = AuthEndpoints.forgotPassword(email: email)
        try await apiClient.requestNoContent(endpoint)

        logger.info("[Auth] Password reset requested for email")
    }

    // MARK: - Reset Password

    func resetPassword(email: String, code: String, newPassword: String) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = AuthEndpoints.resetPassword(token: code, newPassword: newPassword)
        try await apiClient.requestNoContent(endpoint)

        logger.info("[Auth] Password reset completed")
    }

    // MARK: - Logout

    func logout() async {
        // Best-effort server logout
        do {
            let endpoint = AuthEndpoints.logout()
            try await apiClient.requestNoContent(endpoint)
        } catch {
            logger.warning("[Auth] Server logout failed: \(error.localizedDescription)")
        }

        clearSession()
        logger.info("[Auth] User logged out")
    }

    // MARK: - Check Auth Status

    /// Checks keychain for existing tokens and attempts to restore session.
    /// Call this on app launch to determine initial auth state.
    func checkAuthStatus() async {
        isLoading = true
        defer { isLoading = false }

        guard let accessToken = try? keychain.loadToken(for: .accessToken),
              !accessToken.isEmpty else {
            isAuthenticated = false
            currentUser = nil
            return
        }

        // Tokens exist, try fetching the current user profile
        do {
            let endpoint = UserEndpoints.getProfile()
            let user: UserDTO = try await apiClient.request(endpoint)
            currentUser = user
            isAuthenticated = true
            logger.info("[Auth] Session restored for: \(user.username)")
        } catch let error as APIError where error == .unauthorized {
            // Access token expired, try refreshing
            do {
                try await refreshTokens()
                let endpoint = UserEndpoints.getProfile()
                let user: UserDTO = try await apiClient.request(endpoint)
                currentUser = user
                isAuthenticated = true
                logger.info("[Auth] Session restored after token refresh for: \(user.username)")
            } catch {
                logger.warning("[Auth] Token refresh failed during status check: \(error.localizedDescription)")
                clearSession()
            }
        } catch {
            logger.warning("[Auth] Failed to check auth status: \(error.localizedDescription)")
            clearSession()
        }
    }

    // MARK: - Private Helpers

    private func persistTokens(_ tokens: TokensDTO) throws {
        try keychain.saveToken(tokens.accessToken, for: .accessToken)
        try keychain.saveToken(tokens.refreshToken, for: .refreshToken)
    }

    private func clearSession() {
        try? keychain.clearAll()
        currentUser = nil
        isAuthenticated = false
    }
}

// MARK: - APIError Equatable Helper

private extension APIError {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized): return true
        default: return false
        }
    }
}
