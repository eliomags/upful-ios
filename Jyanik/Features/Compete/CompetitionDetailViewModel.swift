//
//  CompetitionDetailViewModel.swift
//  Jyanik
//
//  ViewModel for competition detail screen showing stats, leaderboard, and rules
//

import Foundation
import Observation
import OSLog

@Observable
final class CompetitionDetailViewModel {

    // MARK: - State

    private(set) var competition: CompetitionDTO
    private(set) var leaderboard: [LeaderboardEntryDTO] = []
    private(set) var myRanking: MyRankingDTO?
    private(set) var isLoading = false
    private(set) var isJoining = false
    private(set) var errorMessage: String?
    private(set) var isJoined = false

    // MARK: - Dependencies

    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "CompetitionDetailVM")

    // MARK: - Init

    init(competition: CompetitionDTO, competitionService: CompetitionService = CompetitionService()) {
        self.competition = competition
        self.competitionService = competitionService
        self.isJoined = competition.joined
    }

    // MARK: - Data Loading

    /// Loads guest sample data for this competition detail.
    func loadGuestData() {
        leaderboard = [
            LeaderboardEntryDTO(id: "lb1", userId: "u1", rank: 1, username: "TradeMaster", displayName: "Alex Chen", avatarUrl: nil, totalEquity: 32_450.80, growthPct: 29.80, subscriptionTier: "premium", prizeAmount: 1000),
            LeaderboardEntryDTO(id: "lb2", userId: "u2", rank: 2, username: "StockWhiz", displayName: "Maria G.", avatarUrl: nil, totalEquity: 30_125.50, growthPct: 20.50, subscriptionTier: "premium", prizeAmount: 600),
            LeaderboardEntryDTO(id: "lb3", userId: "u3", rank: 3, username: "BullRunner", displayName: "James L.", avatarUrl: nil, totalEquity: 28_890.00, growthPct: 15.56, subscriptionTier: "free", prizeAmount: 400),
            LeaderboardEntryDTO(id: "lb4", userId: "u4", rank: 4, username: "InvestorJo", displayName: "Jo Park", avatarUrl: nil, totalEquity: 27_600.30, growthPct: 10.40, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb5", userId: "u5", rank: 5, username: "MarketEagle", displayName: "Sam D.", avatarUrl: nil, totalEquity: 26_320.15, growthPct: 5.28, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb6", userId: "u6", rank: 6, username: "FinanceNerd", displayName: "Chris R.", avatarUrl: nil, totalEquity: 25_800.00, growthPct: 3.20, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb7", userId: "u7", rank: 7, username: "DayTrader99", displayName: "Pat W.", avatarUrl: nil, totalEquity: 25_200.40, growthPct: 0.80, subscriptionTier: "premium", prizeAmount: nil),
        ]
        myRanking = MyRankingDTO(rank: 42, growthPct: 0.0, totalEquity: 25_000, prizeAmount: nil)
        isLoading = false
    }

    /// Loads the leaderboard for this specific competition.
    func loadData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchLeaderboard() }
            group.addTask { await self.fetchMyRanking() }
        }
    }

    func refresh() async {
        await loadData()
    }

    // MARK: - Join

    func joinCompetition() async {
        guard !isJoining else { return }

        isJoining = true
        defer { isJoining = false }

        do {
            try await competitionService.joinCompetition(id: competition.id)
            isJoined = true
            logger.info("[CompDetail] Joined competition: \(self.competition.id)")
            // Refresh leaderboard after joining
            await fetchLeaderboard()
        } catch {
            logger.error("[CompDetail] Failed to join: \(error.localizedDescription)")
            errorMessage = "Failed to join competition."
        }
    }

    // MARK: - Computed

    var topThree: [LeaderboardEntryDTO] {
        Array(leaderboard.prefix(3))
    }

    var remaining: [LeaderboardEntryDTO] {
        leaderboard.count > 3 ? Array(leaderboard.dropFirst(3)) : []
    }

    var hasLeaderboard: Bool {
        !leaderboard.isEmpty
    }

    var formattedRank: String {
        guard let ranking = myRanking else { return "--" }
        return "#\(ranking.rank)"
    }

    var formattedEquity: String {
        guard let ranking = myRanking else { return "$--" }
        return JFormatters.formatCurrency(ranking.totalEquity)
    }

    var formattedGrowth: Double {
        myRanking?.growthPct ?? 0.0
    }

    var prizePoolFormatted: String {
        JFormatters.prizePool(competition.totalPrizePool)
    }

    func formattedDate(_ dateString: String) -> String {
        JFormatters.mediumDateString(from: dateString)
    }

    // MARK: - Private Fetches

    private func fetchLeaderboard() async {
        do {
            // Determine the tier based on the competition
            let tier: LeaderboardTier = competition.isPremium ? .premium : .free

            try await competitionService.fetchLeaderboard(
                period: .weekly,
                tier: tier,
                sort: .topGainers,
                page: 1,
                limit: 50
            )
            leaderboard = competitionService.leaderboard
            logger.info("[CompDetail] Loaded \(self.leaderboard.count) leaderboard entries")
        } catch {
            logger.error("[CompDetail] Failed to fetch leaderboard: \(error.localizedDescription)")
            errorMessage = "Failed to load leaderboard."
        }
    }

    private func fetchMyRanking() async {
        do {
            try await competitionService.fetchMyRanking(period: .weekly)
            if let serviceRanking = competitionService.myRanking {
                myRanking = MyRankingDTO(
                    rank: serviceRanking.rank,
                    growthPct: serviceRanking.growthPct,
                    totalEquity: serviceRanking.totalEquity,
                    prizeAmount: serviceRanking.prizeAmount
                )
            } else {
                myRanking = nil
            }
        } catch {
            myRanking = nil
            logger.info("[CompDetail] Ranking unavailable: \(error.localizedDescription)")
        }
    }
}
