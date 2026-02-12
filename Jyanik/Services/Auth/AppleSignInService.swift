//
//  AppleSignInService.swift
//  Jyanik
//
//  Wraps ASAuthorizationController for Sign in with Apple
//

import AuthenticationServices
import Foundation
import OSLog

// MARK: - Apple Sign In Result

struct AppleSignInResult {
    let identityToken: String
    let authorizationCode: String
    let fullName: PersonNameComponents?
}

// MARK: - Apple Sign In Error

enum AppleSignInError: Error, LocalizedError {
    case missingIdentityToken
    case missingAuthorizationCode
    case tokenEncodingFailed
    case cancelled
    case failed(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingIdentityToken:
            return "Apple did not provide an identity token."
        case .missingAuthorizationCode:
            return "Apple did not provide an authorization code."
        case .tokenEncodingFailed:
            return "Failed to encode Apple credentials."
        case .cancelled:
            return "Sign in with Apple was cancelled."
        case .failed(let error):
            return "Sign in with Apple failed: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred during Apple sign in."
        }
    }
}

// MARK: - Apple Sign In Service

final class AppleSignInService: NSObject {

    private let logger = Logger(subsystem: "com.jyanik", category: "AppleSignIn")

    /// The continuation used to bridge the delegate callback to async/await.
    private var continuation: CheckedContinuation<AppleSignInResult, Error>?

    // MARK: - Public API

    /// Initiates the Apple Sign In flow and returns the credentials.
    ///
    /// Must be called from the main actor context to present the authorization UI.
    @MainActor
    func signIn() async throws -> AppleSignInResult {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: AppleSignInError.unknown)
                return
            }

            self.continuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    /// Checks if the user's Apple ID credential is still valid.
    func checkCredentialState(userID: String) async -> ASAuthorizationAppleIDProvider.CredentialState {
        await withCheckedContinuation { continuation in
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { state, _ in
                continuation.resume(returning: state)
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleSignInService: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleSignInError.unknown)
            continuation = nil
            return
        }

        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleSignInError.missingIdentityToken)
            continuation = nil
            return
        }

        guard let authCodeData = appleIDCredential.authorizationCode,
              let authorizationCode = String(data: authCodeData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleSignInError.missingAuthorizationCode)
            continuation = nil
            return
        }

        let result = AppleSignInResult(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: appleIDCredential.fullName
        )

        logger.info("[AppleSignIn] Authorization completed successfully")
        continuation?.resume(returning: result)
        continuation = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let asError = error as? ASAuthorizationError

        if asError?.code == .canceled {
            logger.info("[AppleSignIn] User cancelled sign in")
            continuation?.resume(throwing: AppleSignInError.cancelled)
        } else {
            logger.error("[AppleSignIn] Authorization failed: \(error.localizedDescription)")
            continuation?.resume(throwing: AppleSignInError.failed(error))
        }

        continuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleSignInService: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let window = windowScene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }
}
