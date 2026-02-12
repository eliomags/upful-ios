//
//  CompetitionService.swift
//  Jyanik
//
//  Manages competitions, leaderboard, and user ranking
//

import Foundation
import Observation
import OSLog

@Observable
final class CompetitionService {

    // MARK: - State

    private(set) var currentCompetitions: [CompetitionDTO] = []
    private(set) var leaderboard: [LeaderboardEntryDTO] = []
    private(set) var myRanking: LeaderboardEntryDTO?
    private(set) var isLoading = false

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "CompetitionService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Current Competitions

    /// Fetches all currently active competitions.
    func fetchCurrentCompetitions() async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = CompetitionEndpoints.getCurrentCompetitions()
        let competitions: [CompetitionDTO] = try await apiClient.request(endpoint)

        currentCompetitions = competitions
        logger.info("[Competition] Fetched \(competitions.count) active competitions")
    }

    // MARK: - Leaderboard

    /// Fetches the leaderboard for a given period and tab.
    func fetchLeaderboard(
        period: LeaderboardPeriod = .weekly,
        tab: LeaderboardTab = .topGainers,
        page: Int = 1,
        limit: Int = 50
    ) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = LeaderboardEndpoints.getLeaderboard(
            period: period,
            tab: tab,
            page: page,
            limit: limit
        )
        let entries: [LeaderboardEntryDTO] = try await apiClient.request(endpoint)

        if page == 1 {
            leaderboard = entries
        } else {
            leaderboard.append(contentsOf: entries)
        }

        logger.info("[Competition] Fetched \(entries.count) leaderboard entries (page \(page))")
    }

    // MARK: - My Ranking

    /// Fetches the current user's ranking.
    func fetchMyRanking() async throws {
        let endpoint = LeaderboardEndpoints.getMyRanking()
        let ranking: MyRankingDTO = try await apiClient.request(endpoint)

        myRanking = LeaderboardEntryDTO(
            id: nil,
            userId: nil,
            rank: ranking.rank,
            username: "",
            displayName: nil,
            avatarURL: nil,
            totalEquity: ranking.totalEquity,
            growthPct: ranking.growthPct,
            subscriptionTier: nil
        )

        logger.info("[Competition] My ranking: #\(ranking.rank) (\(ranking.growthPct)%)")
    }

    // MARK: - Competition History

    /// Fetches past competition results with pagination.
    func fetchHistory(
        page: Int = 1,
        limit: Int = 20
    ) async throws -> [CompetitionDTO] {
        let endpoint = CompetitionEndpoints.getCompetitionHistory(page: page, limit: limit)
        let competitions: [CompetitionDTO] = try await apiClient.request(endpoint)

        logger.info("[Competition] Fetched \(competitions.count) history entries (page \(page))")
        return competitions
    }

    // MARK: - Monthly Reset

    /// Submits the user's monthly reset choice (start fresh or keep current portfolio).
    func submitResetChoice(_ choice: ResetChoice) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = CompetitionEndpoints.resetChoice(choice: choice)
        let _: ResetResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Competition] Reset choice submitted: \(choice.rawValue)")
    }
}
