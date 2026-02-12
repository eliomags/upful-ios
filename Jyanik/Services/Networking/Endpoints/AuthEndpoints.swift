//
//  AuthEndpoints.swift
//  Jyanik
//
//  Authentication API endpoints
//

import Foundation

enum AuthEndpoints {

    static func register(email: String, username: String, password: String) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/register",
            method: .post,
            body: RegisterBody(email: email, username: username, password: password),
            requiresAuth: false
        )
    }

    static func login(email: String, password: String) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/login",
            method: .post,
            body: LoginBody(email: email, password: password),
            requiresAuth: false
        )
    }

    static func loginWithApple(
        identityToken: String,
        authorizationCode: String,
        fullName: String?
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/apple",
            method: .post,
            body: AppleLoginBody(
                identityToken: identityToken,
                authorizationCode: authorizationCode,
                fullName: fullName
            ),
            requiresAuth: false
        )
    }

    static func refreshToken(refreshToken: String) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/refresh",
            method: .post,
            body: RefreshBody(refreshToken: refreshToken),
            requiresAuth: false
        )
    }

    static func forgotPassword(email: String) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/forgot-password",
            method: .post,
            body: ForgotPasswordBody(email: email),
            requiresAuth: false
        )
    }

    static func resetPassword(token: String, newPassword: String) -> APIEndpoint {
        APIEndpoint(
            path: "/auth/reset-password",
            method: .post,
            body: ResetPasswordBody(token: token, newPassword: newPassword),
            requiresAuth: false
        )
    }

    static func logout() -> APIEndpoint {
        APIEndpoint(
            path: "/auth/logout",
            method: .post,
            requiresAuth: true
        )
    }
}

// MARK: - Request Bodies

private extension AuthEndpoints {

    struct RegisterBody: Encodable {
        let email: String
        let username: String
        let password: String
    }

    struct LoginBody: Encodable {
        let email: String
        let password: String
    }

    struct AppleLoginBody: Encodable {
        let identityToken: String
        let authorizationCode: String
        let fullName: String?
    }

    struct RefreshBody: Encodable {
        let refreshToken: String
    }

    struct ForgotPasswordBody: Encodable {
        let email: String
    }

    struct ResetPasswordBody: Encodable {
        let token: String
        let newPassword: String
    }
}
