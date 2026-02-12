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

    static func resetChoice(choice: ResetChoice) -> APIEndpoint {
        APIEndpoint(
            path: "/competitions/reset-choice",
            method: .post,
            body: ResetChoiceBody(choice: choice)
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
