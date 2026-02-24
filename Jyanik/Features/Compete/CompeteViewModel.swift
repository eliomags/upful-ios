//
//  CompeteViewModel.swift
//  Jyanik
//
//  Leaderboard-first ViewModel for the Compete tab.
//  Shows a flat ranked list with Free/Subscribed tabs, 5 period types,
//  sort options, and a My History tab for past competition results.
//

import Foundation
import Observation
import OSLog

// MARK: - Compete Tab

enum CompeteTab: String, CaseIterable {
    case leaderboard
    case myHistory

    var displayName: String {
        switch self {
        case .leaderboard: return "Leaderboard"
        case .myHistory: return "My History"
        }
    }
}

// MARK: - ViewModel

@Observable
final class CompeteViewModel {

    // MARK: - View State

    var selectedTab: CompeteTab = .leaderboard
    var selectedTier: LeaderboardTier = .free
    var selectedPeriod: LeaderboardPeriod = .weekly
    var historyPeriodFilter: LeaderboardPeriod? = nil // nil = show all

    // MARK: - Leaderboard Data

    private(set) var entries: [LeaderboardEntryDTO] = []
    private(set) var myRanking: MyRankingDTO?
    private(set) var loadState: LoadState = .idle

    // MARK: - History Data

    private(set) var historyEntries: [CompetitionHistoryEntryDTO] = []
    private(set) var historyLoadState: LoadState = .idle

    // MARK: - Computed

    var hasEntries: Bool { !entries.isEmpty }
    var hasHistory: Bool { !filteredHistory.isEmpty }

    /// History entries filtered by the selected period type.
    var filteredHistory: [CompetitionHistoryEntryDTO] {
        guard let filter = historyPeriodFilter else { return historyEntries }
        return historyEntries.filter { ($0.type ?? "").lowercased() == filter.rawValue }
    }

    var formattedRank: String {
        guard let ranking = myRanking else { return "--" }
        return "\(ranking.rank)"
    }

    var formattedGrowth: Double {
        myRanking?.growthPct ?? 0.0
    }

    // MARK: - Dependencies

    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "CompeteViewModel")

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        self.competitionService = competitionService
    }

    // MARK: - Guest Mode

    func loadGuestData() {
        entries = [
            LeaderboardEntryDTO(id: "lb1", userId: "u1", rank: 1, username: "TradeMaster", displayName: "Alex Chen", avatarUrl: nil, totalEquity: 32_450.80, growthPct: 29.80, subscriptionTier: "premium", prizeAmount: 1000),
            LeaderboardEntryDTO(id: "lb2", userId: "u2", rank: 2, username: "StockWhiz", displayName: "Maria G.", avatarUrl: nil, totalEquity: 30_125.50, growthPct: 20.50, subscriptionTier: "premium", prizeAmount: 600),
            LeaderboardEntryDTO(id: "lb3", userId: "u3", rank: 3, username: "BullRunner", displayName: "James L.", avatarUrl: nil, totalEquity: 28_890.00, growthPct: 15.56, subscriptionTier: "free", prizeAmount: 400),
            LeaderboardEntryDTO(id: "lb4", userId: "u4", rank: 4, username: "InvestorJo", displayName: "Jo Park", avatarUrl: nil, totalEquity: 27_600.30, growthPct: 10.40, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb5", userId: "u5", rank: 5, username: "MarketEagle", displayName: "Sam D.", avatarUrl: nil, totalEquity: 26_320.15, growthPct: 5.28, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb6", userId: "u6", rank: 6, username: "FinanceNerd", displayName: "Chris R.", avatarUrl: nil, totalEquity: 25_800.00, growthPct: 3.20, subscriptionTier: "free", prizeAmount: nil),
            LeaderboardEntryDTO(id: "lb7", userId: "u7", rank: 7, username: "DayTrader99", displayName: "Pat W.", avatarUrl: nil, totalEquity: 25_200.40, growthPct: 0.80, subscriptionTier: "free", prizeAmount: nil),
        ]
        myRanking = MyRankingDTO(rank: 42, growthPct: 0.0, totalEquity: 25_000, prizeAmount: nil)

        historyEntries = [
            CompetitionHistoryEntryDTO(id: "h1", competitionId: "c1", startingEquity: 25_000, endingEquity: 27_500, growthPct: 10.0, rank: 5, prizeAmount: nil, prizeStatus: nil, createdAt: "2026-01-31T00:00:00Z", type: "monthly", startDate: "2026-01-01", endDate: "2026-01-31", totalPrizePool: 2000, participantCount: 28, subscriptionTier: "free"),
            CompetitionHistoryEntryDTO(id: "h2", competitionId: "c2", startingEquity: 25_000, endingEquity: 24_200, growthPct: -3.2, rank: 18, prizeAmount: nil, prizeStatus: nil, createdAt: "2026-01-26T00:00:00Z", type: "weekly", startDate: "2026-01-20", endDate: "2026-01-26", totalPrizePool: 500, participantCount: 28, subscriptionTier: "free"),
            CompetitionHistoryEntryDTO(id: "h3", competitionId: "c3", startingEquity: 25_000, endingEquity: 26_100, growthPct: 4.4, rank: 2, prizeAmount: 150, prizeStatus: "paid", createdAt: "2026-01-15T00:00:00Z", type: "daily", startDate: "2026-01-15", endDate: "2026-01-15", totalPrizePool: 500, participantCount: 28, subscriptionTier: "free"),
            CompetitionHistoryEntryDTO(id: "h4", competitionId: "c4", startingEquity: 25_000, endingEquity: 29_800, growthPct: 19.2, rank: 3, prizeAmount: 400, prizeStatus: "paid", createdAt: "2025-12-31T00:00:00Z", type: "monthly", startDate: "2025-12-01", endDate: "2025-12-31", totalPrizePool: 2000, participantCount: 28, subscriptionTier: "premium"),
        ]

        loadState = .loaded
        historyLoadState = .loaded
    }

    // MARK: - Load Leaderboard

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

    // MARK: - Load History

    func loadHistory() async {
        guard historyLoadState != .loading else { return }
        historyLoadState = .loading

        do {
            // Pass selected tier so backend filters by free/premium
            let tierParam: String? = selectedTier == .all ? nil : selectedTier.rawValue
            historyEntries = try await competitionService.fetchMyHistory(tier: tierParam)
            historyLoadState = .loaded
            logger.info("[Compete] Loaded \(self.historyEntries.count) history entries for tier: \(tierParam ?? "all")")
        } catch {
            logger.error("[Compete] Failed to load history: \(error.localizedDescription)")
            historyLoadState = .error("Failed to load history. Pull to retry.")
        }
    }

    // MARK: - Tab Switching

    func switchTab(_ tab: CompeteTab) async {
        guard tab != selectedTab else { return }
        selectedTab = tab
        if tab == .myHistory && historyEntries.isEmpty && historyLoadState != .loading {
            await loadHistory()
        }
    }

    // MARK: - Selection Changes

    func changeTier(_ tier: LeaderboardTier) async {
        guard tier != selectedTier else { return }
        selectedTier = tier
        if selectedTab == .leaderboard {
            await refresh()
        } else if selectedTab == .myHistory {
            // Reload history when tier changes on the history tab
            historyLoadState = .idle
            await loadHistory()
        }
    }

    func changePeriod(_ period: LeaderboardPeriod) async {
        guard period != selectedPeriod else { return }
        selectedPeriod = period
        await refresh()
    }

    // MARK: - Private Fetches

    private func fetchLeaderboard() async {
        do {
            try await competitionService.fetchLeaderboard(
                period: selectedPeriod,
                tier: selectedTier,
                page: 1,
                limit: 50
            )
            entries = competitionService.leaderboard
            logger.info("[Compete] Loaded \(self.entries.count) entries for \(self.selectedTier.rawValue)/\(self.selectedPeriod.rawValue)")
        } catch {
            logger.error("[Compete] Failed to fetch leaderboard: \(error.localizedDescription)")
            loadState = .error("Failed to load leaderboard. Pull to retry.")
        }
    }

    private func fetchMyRanking() async {
        do {
            try await competitionService.fetchMyRanking(period: selectedPeriod, tier: selectedTier)
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
            logger.info("[Compete] Ranking unavailable: \(error.localizedDescription)")
        }
    }
}
