//
//  LeaderboardViewModel.swift
//  Jyanik
//
//  ViewModel for the full leaderboard screen with Free/Premium tier tabs
//

import Foundation
import Observation
import OSLog

@Observable
final class LeaderboardViewModel {

    // MARK: - State

    private(set) var entries: [LeaderboardEntryDTO] = []
    private(set) var myRanking: MyRankingDTO?
    private(set) var loadState: LoadState = .idle

    var selectedTier: LeaderboardTier = .free
    var selectedPeriod: LeaderboardPeriod = .weekly
    var selectedSort: LeaderboardSort = .topGainers

    // MARK: - Computed

    var topThree: [LeaderboardEntryDTO] {
        Array(entries.prefix(3))
    }

    var remaining: [LeaderboardEntryDTO] {
        entries.count > 3 ? Array(entries.dropFirst(3)) : []
    }

    var hasEntries: Bool {
        !entries.isEmpty
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

    // MARK: - Dependencies

    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "LeaderboardViewModel")

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        self.competitionService = competitionService
    }

    // MARK: - Data Loading

    /// Loads sample leaderboard for guest mode.
    func loadGuestData() {
        entries = [
            LeaderboardEntryDTO(id: "lb1", userId: "u1", rank: 1, username: "TradeMaster", displayName: "Alex Chen", avatarUrl: nil, totalEquity: 32_450.80, growthPct: 29.80, subscriptionTier: "premium", prizeAmount: 1000),
            LeaderboardEntryDTO(id: "lb2", userId: "u2", rank: 2, username: "StockWhiz", displayName: "Maria G.", avatarUrl: nil, totalEquity: 30_125.50, growthPct: 20.50, subscriptionTier: "premium", prizeAmount: 600),
            LeaderboardEntryDTO(id: "lb3", userId: "u3", rank: 3, username: "BullRunner", displayName: "James L.", avatarUrl: nil, totalEquity: 28_890.00, growthPct: 15.56, subscriptionTier: "free", prizeAmount: 400),
            LeaderboardEntryDTO(id: "lb4", userId: "u4", rank: 4, username: "InvestorJo", displayName: "Jo Park", avatarUrl: nil, totalEquity: 27_600.30, growthPct: 10.40, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb5", userId: "u5", rank: 5, username: "MarketEagle", displayName: "Sam D.", avatarUrl: nil, totalEquity: 26_320.15, growthPct: 5.28, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb6", userId: "u6", rank: 6, username: "FinanceNerd", displayName: "Chris R.", avatarUrl: nil, totalEquity: 25_800.00, growthPct: 3.20, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb7", userId: "u7", rank: 7, username: "DayTrader99", displayName: "Pat W.", avatarUrl: nil, totalEquity: 25_200.40, growthPct: 0.80, subscriptionTier: "premium", prizeAmount: nil),
        ]
        myRanking = MyRankingDTO(rank: 42, growthPct: 0.0, totalEquity: 25_000, prizeAmount: nil)
        loadState = .loaded
    }

    /// Loads leaderboard entries and user ranking concurrently.
    func load() async {
        guard loadState != .loading else { return }

        loadState = .loading

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchLeaderboard() }
            group.addTask { await self.fetchMyRanking() }
        }

        if case .loading = loadState {
            loadState = entries.isEmpty ? .error("No leaderboard data available.") : .loaded
        }
    }

    /// Reloads data with the current selections.
    func refresh() async {
        loadState = .idle
        await load()
    }

    // MARK: - Selection Changes

    func changeTier(_ tier: LeaderboardTier) async {
        guard tier != selectedTier else { return }
        selectedTier = tier
        await refresh()
    }

    func changePeriod(_ period: LeaderboardPeriod) async {
        guard period != selectedPeriod else { return }
        selectedPeriod = period
        await refresh()
    }

    func changeSort(_ sort: LeaderboardSort) async {
        guard sort != selectedSort else { return }
        selectedSort = sort
        await refresh()
    }

    // MARK: - Private Fetches

    private func fetchLeaderboard() async {
        do {
            try await competitionService.fetchLeaderboard(
                period: selectedPeriod,
                tier: selectedTier,
                sort: selectedSort,
                page: 1,
                limit: 50
            )
            entries = competitionService.leaderboard
            logger.info("[Leaderboard] Loaded \(self.entries.count) entries for \(self.selectedTier.rawValue)/\(self.selectedPeriod.rawValue)/\(self.selectedSort.rawValue)")
        } catch {
            logger.error("[Leaderboard] Failed to fetch entries: \(error.localizedDescription)")
            loadState = .error("Failed to load leaderboard. Pull to retry.")
        }
    }

    private func fetchMyRanking() async {
        do {
            try await competitionService.fetchMyRanking(period: selectedPeriod)
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
            // Non-critical — don't override the main load state
            myRanking = nil
            logger.info("[Leaderboard] Ranking unavailable: \(error.localizedDescription)")
        }
    }
}
