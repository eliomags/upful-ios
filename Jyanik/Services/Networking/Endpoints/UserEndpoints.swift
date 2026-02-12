//
//  UserEndpoints.swift
//  Jyanik
//
//  User profile API endpoints
//

import Foundation

enum UserEndpoints {

    static func getProfile() -> APIEndpoint {
        APIEndpoint(
            path: "/users/me",
            method: .get
        )
    }

    static func updateProfile(_ fields: ProfileUpdateFields) -> APIEndpoint {
        APIEndpoint(
            path: "/users/me",
            method: .patch,
            body: fields
        )
    }

    static func uploadAvatar(imageData: Data) -> APIEndpoint {
        APIEndpoint(
            path: "/users/me/avatar",
            method: .put,
            body: AvatarUploadBody(imageData: imageData.base64EncodedString()),
            headers: ["Content-Type": "application/json"]
        )
    }

    static func deleteAccount() -> APIEndpoint {
        APIEndpoint(
            path: "/users/me",
            method: .delete
        )
    }

    static func getPublicProfile(userId: String) -> APIEndpoint {
        APIEndpoint(
            path: "/users/\(userId)",
            method: .get
        )
    }

    static func updateSubscription(isPremium: Bool) -> APIEndpoint {
        APIEndpoint(
            path: "/users/me/subscription",
            method: .put,
            body: SubscriptionUpdateBody(isPremium: isPremium)
        )
    }
}

// MARK: - Request Bodies

struct ProfileUpdateFields: Encodable {
    var username: String?
    var displayName: String?
    var bio: String?
    var avatarUrl: String?

    init(
        username: String? = nil,
        displayName: String? = nil,
        bio: String? = nil,
        avatarUrl: String? = nil
    ) {
        self.username = username
        self.displayName = displayName
        self.bio = bio
        self.avatarUrl = avatarUrl
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Only encode non-nil fields so we send partial updates
        try username.map { try container.encode($0, forKey: .username) }
        try displayName.map { try container.encode($0, forKey: .displayName) }
        try bio.map { try container.encode($0, forKey: .bio) }
        try avatarUrl.map { try container.encode($0, forKey: .avatarUrl) }
    }

    private enum CodingKeys: String, CodingKey {
        case username
        case displayName
        case bio
        case avatarUrl
    }
}

private struct AvatarUploadBody: Encodable {
    let imageData: String
}

private struct SubscriptionUpdateBody: Encodable {
    let isPremium: Bool
}
