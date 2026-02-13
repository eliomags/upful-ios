//
//  AuthViewModel.swift
//  Jyanik
//
//  View model for authentication flows: login, register, Apple sign-in, forgot password
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AuthViewModel {

    // MARK: - Form Fields

    var email: String = ""
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var acceptedTerms: Bool = false

    // MARK: - State

    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    var isPasswordResetSent: Bool = false

    // MARK: - Dependencies

    private let authService: AuthService
    private let appleSignInService: AppleSignInService
    private let appState: AppState
    private let logger = Logger(subsystem: "com.jyanik", category: "AuthViewModel")

    // MARK: - Init

    init(
        authService: AuthService = .init(),
        appleSignInService: AppleSignInService = .init(),
        appState: AppState
    ) {
        self.authService = authService
        self.appleSignInService = appleSignInService
        self.appState = appState
    }

    // MARK: - Login

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            presentError("Please enter your email and password.")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let userDTO = try await authService.login(email: email, password: password)
            let user = mapUser(userDTO)

            guard let tokens = extractTokens() else {
                presentError("Authentication succeeded but failed to retrieve session tokens.")
                return
            }

            appState.login(accessToken: tokens.access, refreshToken: tokens.refresh, user: user)
            appState.completeOnboarding()

            logger.info("[AuthVM] Login successful for \(userDTO.username)")
        } catch {
            logger.error("[AuthVM] Login failed: \(error.localizedDescription)")
            presentError(friendlyMessage(from: error))
        }
    }

    // MARK: - Register

    func register() async {
        guard validateRegistration() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let userDTO = try await authService.register(
                email: email,
                username: username,
                password: password
            )
            let user = mapUser(userDTO)

            guard let tokens = extractTokens() else {
                presentError("Account created but failed to retrieve session tokens.")
                return
            }

            appState.login(accessToken: tokens.access, refreshToken: tokens.refresh, user: user)
            appState.completeOnboarding()

            logger.info("[AuthVM] Registration successful for \(userDTO.username)")
        } catch {
            logger.error("[AuthVM] Registration failed: \(error.localizedDescription)")
            presentError(friendlyMessage(from: error))
        }
    }

    // MARK: - Sign in with Apple

    func signInWithApple() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let appleResult = try await appleSignInService.signIn()

            let userDTO = try await authService.loginWithApple(
                identityToken: appleResult.identityToken,
                authorizationCode: appleResult.authorizationCode,
                fullName: appleResult.fullName
            )
            let user = mapUser(userDTO)

            guard let tokens = extractTokens() else {
                presentError("Apple sign-in succeeded but failed to retrieve session tokens.")
                return
            }

            appState.login(accessToken: tokens.access, refreshToken: tokens.refresh, user: user)
            appState.completeOnboarding()

            logger.info("[AuthVM] Apple sign-in successful for \(userDTO.username)")
        } catch let error as AppleSignInError where error == .cancelled {
            logger.info("[AuthVM] Apple sign-in cancelled by user")
            // Do not show an error for user cancellation
        } catch {
            logger.error("[AuthVM] Apple sign-in failed: \(error.localizedDescription)")
            presentError(friendlyMessage(from: error))
        }
    }

    // MARK: - Forgot Password

    func forgotPassword() async {
        guard !email.isEmpty else {
            presentError("Please enter your email address.")
            return
        }

        guard isValidEmail(email) else {
            presentError("Please enter a valid email address.")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.forgotPassword(email: email)
            isPasswordResetSent = true
            logger.info("[AuthVM] Password reset email sent")
        } catch {
            logger.error("[AuthVM] Forgot password failed: \(error.localizedDescription)")
            presentError(friendlyMessage(from: error))
        }
    }

    // MARK: - Reset Password

    func resetPassword(code: String, newPassword: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.resetPassword(email: email, code: code, newPassword: newPassword)
            logger.info("[AuthVM] Password reset completed")
        } catch {
            logger.error("[AuthVM] Reset password failed: \(error.localizedDescription)")
            presentError(friendlyMessage(from: error))
        }
    }

    // MARK: - Validation

    func validateRegistration() -> Bool {
        if email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            presentError("All fields are required.")
            return false
        }

        if !isValidEmail(email) {
            presentError("Please enter a valid email address.")
            return false
        }

        if username.count < 3 {
            presentError("Username must be at least 3 characters.")
            return false
        }

        if password.count < 8 {
            presentError("Password must be at least 8 characters.")
            return false
        }

        if password != confirmPassword {
            presentError("Passwords do not match.")
            return false
        }

        if !acceptedTerms {
            presentError("You must accept the Terms of Service to continue.")
            return false
        }

        return true
    }

    // MARK: - Password Strength

    enum PasswordStrength: String {
        case weak = "Weak"
        case medium = "Medium"
        case strong = "Strong"

        var color: String {
            switch self {
            case .weak: return "error"
            case .medium: return "warning"
            case .strong: return "success"
            }
        }
    }

    var passwordStrength: PasswordStrength {
        let length = password.count
        guard length > 0 else { return .weak }

        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        var score = 0
        if length >= 8 { score += 1 }
        if length >= 12 { score += 1 }
        if hasUppercase { score += 1 }
        if hasLowercase { score += 1 }
        if hasDigit { score += 1 }
        if hasSpecial { score += 1 }

        if score <= 2 { return .weak }
        if score <= 4 { return .medium }
        return .strong
    }

    // MARK: - Helpers

    func clearError() {
        errorMessage = nil
        showError = false
    }

    func clearForm() {
        email = ""
        username = ""
        password = ""
        confirmPassword = ""
        acceptedTerms = false
        isPasswordResetSent = false
        clearError()
    }

    // MARK: - Private

    private func presentError(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func mapUser(_ dto: UserDTO) -> User {
        User(
            id: dto.id,
            email: dto.email,
            username: dto.username,
            displayName: dto.displayName,
            avatarUrl: dto.avatarUrl,
            tier: dto.subscriptionTier
        )
    }

    /// Extracts the persisted tokens from the keychain via AuthService.
    /// AuthService stores tokens internally upon successful auth calls,
    /// so we read them back from the keychain.
    private func extractTokens() -> (access: String, refresh: String)? {
        let keychain = KeychainService.shared
        do {
            guard let accessToken = try keychain.loadToken(for: .accessToken),
                  let refreshToken = try keychain.loadToken(for: .refreshToken) else {
                return nil
            }
            return (accessToken, refreshToken)
        } catch {
            logger.error("[AuthVM] Failed to extract tokens: \(error.localizedDescription)")
            return nil
        }
    }

    private func friendlyMessage(from error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .unauthorized:
                return "Invalid email or password. Please try again."
            case .conflict:
                return "An account with this email or username already exists."
            case .validationError(let message):
                return message
            case .networkError:
                return "No internet connection. Please check your network and try again."
            case .timeout:
                return "The request timed out. Please try again."
            case .serverError:
                return "Something went wrong on our end. Please try again later."
            default:
                return apiError.localizedDescription
            }
        }

        if let appleError = error as? AppleSignInError {
            return appleError.localizedDescription
        }

        return "Something went wrong. Please try again."
    }
}

// MARK: - AppleSignInError Equatable Helper

private extension AppleSignInError {
    static func == (lhs: AppleSignInError, rhs: AppleSignInError) -> Bool {
        switch (lhs, rhs) {
        case (.cancelled, .cancelled): return true
        default: return false
        }
    }
}
