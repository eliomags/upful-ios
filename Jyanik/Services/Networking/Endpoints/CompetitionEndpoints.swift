//
//  CompetitionEndpoints.swift
//  Jyanik
//
//  Competition API endpoints
//

import Foundation

enum CompetitionEndpoints {

    static func getCurrentCompetitions() -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/current",
            method: .get
        )
    }

    static func getCompetitionHistory(page: Int = 1, limit: Int = 20) -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/history",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func getPastResults(page: Int = 1, limit: Int = 10) -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/past-results",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func joinCompetition(id: String) -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/\(id)/join",
            method: .post
        )
    }

    static func getMyHistory(
        periodType: String? = nil,
        tier: String? = nil,
        page: Int = 1,
        limit: Int = 20
    ) -> APIEndpoint {
        var queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        if let periodType {
            queryItems.append(URLQueryItem(name: "period_type", value: periodType))
        }
        if let tier {
            queryItems.append(URLQueryItem(name: "tier", value: tier))
        }
        return APIEndpoint(
            path: "/competitions/my-history",
            method: .get,
            queryItems: queryItems
        )
    }

    static func resetChoice(choice: ResetChoice) -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/reset-choice",
            method: .post,
            body: ResetChoiceBody(choice: choice)
        )
    }
}

// MARK: - User Performance

enum UserPerformanceEndpoints {

    static func getUserPerformance(userId: String) -> APIEndpoint {
        APIEndpoint(
            path: "/users/\(userId)/performance",
            method: .get
        )
    }
}

// MARK: - Reset Choice

enum ResetChoice: String, Codable, Hashable {
    case new
    case keep
}

private struct ResetChoiceBody: Encodable {
    let choice: ResetChoice
}
