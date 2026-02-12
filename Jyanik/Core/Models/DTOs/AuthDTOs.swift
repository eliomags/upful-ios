//
//  AuthDTOs.swift
//  Jyanik
//
//  Network DTOs for authentication endpoints
//

import Foundation

// MARK: - Request Bodies

struct RegisterRequestBody: Encodable {
    let email: String
    let username: String
    let password: String
    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case email, username, password
        case displayName = "display_name"
    }
}

struct LoginRequestBody: Encodable {
    let email: String
    let password: String
}

struct AppleAuthRequestBody: Encodable {
    let identityToken: String
    let authorizationCode: String
    let fullName: AppleFullName?

    enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
        case authorizationCode = "authorization_code"
        case fullName = "full_name"
    }
}

struct AppleFullName: Encodable {
    let givenName: String?
    let familyName: String?

    enum CodingKeys: String, CodingKey {
        case givenName = "given_name"
        case familyName = "family_name"
    }
}

struct RefreshTokenRequestBody: Encodable {
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

struct ForgotPasswordRequestBody: Encodable {
    let email: String
}

struct ResetPasswordRequestBody: Encodable {
    let email: String
    let code: String
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case email, code
        case newPassword = "new_password"
    }
}

struct LogoutRequestBody: Encodable {
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

// MARK: - Response DTOs

struct AuthResponseDTO: Decodable {
    let user: UserDTO
    let tokens: TokensDTO
    let isNewUser: Bool?

    enum CodingKeys: String, CodingKey {
        case user, tokens
        case isNewUser = "is_new_user"
    }
}

struct UserDTO: Decodable {
    let id: String
    let email: String
    let username: String
    let displayName: String?
    let avatarURL: String?
    let paypalEmail: String?
    let subscriptionTier: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, email, username
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case paypalEmail = "paypal_email"
        case subscriptionTier = "subscription_tier"
        case createdAt = "created_at"
    }
}

struct TokensDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
