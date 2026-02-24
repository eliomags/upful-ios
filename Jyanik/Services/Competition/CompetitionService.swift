//
//  CompetitionService.swift
//  Jyanik
//
//  Manages competitions, leaderboard, user ranking, and performance data
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
    private(set) var pastResults: [PastCompetitionResultDTO] = []
    private(set) var isLoading = false

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "CompetitionService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Current Competitions

    /// Fetches all currently active competitions (includes join status when authenticated).
    func fetchCurrentCompetitions() async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = CompetitionEndpoints.getCurrentCompetitions()
        let competitions: [CompetitionDTO] = try await apiClient.request(endpoint)

        currentCompetitions = competitions
        logger.info("[Competition] Fetched \(competitions.count) active competitions")
    }

    // MARK: - Leaderboard

    /// Fetches the leaderboard for a given period, tier, and sort order.
    func fetchLeaderboard(
        period: LeaderboardPeriod = .weekly,
        tier: LeaderboardTier = .all,
        sort: LeaderboardSort = .topGainers,
        page: Int = 1,
        limit: Int = 50
    ) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = LeaderboardEndpoints.getLeaderboard(
            period: period,
            tier: tier,
            sort: sort,
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

    /// Fetches the current user's ranking for the given period and tier. Returns nil gracefully if not ranked or tier mismatches.
    func fetchMyRanking(period: LeaderboardPeriod = .weekly, tier: LeaderboardTier = .all) async throws {
        let endpoint = LeaderboardEndpoints.getMyRanking(period: period, tier: tier)

        // The backend now returns { success: true, data: null } when not ranked
        // instead of a 404, so this should decode gracefully
        do {
            let ranking: MyRankingDTO = try await apiClient.request(endpoint)
            myRanking = LeaderboardEntryDTO(
                id: nil,
                userId: nil,
                rank: ranking.rank,
                username: "",
                displayName: nil,
                avatarUrl: nil,
                totalEquity: ranking.totalEquity,
                growthPct: ranking.growthPct,
                subscriptionTier: nil,
                prizeAmount: ranking.prizeAmount
            )
            logger.info("[Competition] My ranking: #\(ranking.rank) (\(ranking.growthPct)%)")
        } catch {
            // Gracefully handle auth errors or not-ranked responses
            myRanking = nil
            logger.info("[Competition] No ranking data: \(error.localizedDescription)")
        }
    }

    // MARK: - Past Results

    /// Fetches past competition results with winners.
    func fetchPastResults(page: Int = 1, limit: Int = 10) async throws {
        let endpoint = CompetitionEndpoints.getPastResults(page: page, limit: limit)
        let results: [PastCompetitionResultDTO] = try await apiClient.request(endpoint)

        if page == 1 {
            pastResults = results
        } else {
            pastResults.append(contentsOf: results)
        }

        logger.info("[Competition] Fetched \(results.count) past results")
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

    // MARK: - Join Competition

    /// Joins a specific competition by ID.
    func joinCompetition(id: String) async throws {
        let endpoint = CompetitionEndpoints.joinCompetition(id: id)
        try await apiClient.requestNoContent(endpoint)
        logger.info("[Competition] Joined competition: \(id)")
    }

    // MARK: - User Performance

    /// Fetches a user's competition performance history.
    func fetchUserPerformance(userId: String) async throws -> UserPerformanceResponseDTO {
        let endpoint = UserPerformanceEndpoints.getUserPerformance(userId: userId)
        let response: UserPerformanceResponseDTO = try await apiClient.request(endpoint)
        logger.info("[Competition] Fetched performance for user: \(userId)")
        return response
    }

    // MARK: - My History

    /// Fetches the current user's competition history, optionally filtered by period type and tier.
    func fetchMyHistory(
        periodType: String? = nil,
        tier: String? = nil,
        page: Int = 1,
        limit: Int = 50
    ) async throws -> [CompetitionHistoryEntryDTO] {
        let endpoint = CompetitionEndpoints.getMyHistory(
            periodType: periodType,
            tier: tier,
            page: page,
            limit: limit
        )
        let entries: [CompetitionHistoryEntryDTO] = try await apiClient.request(endpoint)
        logger.info("[Competition] Fetched \(entries.count) history entries")
        return entries
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
