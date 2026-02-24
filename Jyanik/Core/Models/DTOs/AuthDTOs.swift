//
//  AuthDTOs.swift
//  Jyanik
//
//  Network DTOs for authentication endpoints.
//  Request bodies are defined in AuthEndpoints.swift (private, uses .convertToSnakeCase encoder).
//  Response DTOs use .convertFromSnakeCase decoder — no manual CodingKeys needed.
//

import Foundation

// MARK: - Response DTOs

struct AuthResponseDTO: Decodable {
    let user: UserDTO
    let tokens: TokensDTO
    let isNewUser: Bool?
}

struct UserDTO: Decodable {
    let id: String
    let email: String
    let username: String
    let displayName: String?
    let avatarUrl: String?
    let paypalEmail: String?
    let subscriptionTier: String
    let createdAt: String
}

struct TokensDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String?
}

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String?
}
