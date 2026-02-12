//
//  LeaderboardViewModel.swift
//  Jyanik
//
//  ViewModel for the full leaderboard screen
//

import Foundation
import Observation
import OSLog

@Observable
final class LeaderboardViewModel {

    // MARK: - Load State

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    // MARK: - State

    private(set) var entries: [LeaderboardEntryDTO] = []
    private(set) var myRanking: MyRankingDTO?
    private(set) var loadState: LoadState = .idle

    var selectedPeriod: LeaderboardPeriod = .weekly
    var selectedTab: LeaderboardTab = .topGainers

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
        return formatCurrency(ranking.totalEquity)
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

    /// Reloads data with the current period and tab selection.
    func refresh() async {
        loadState = .idle
        await load()
    }

    // MARK: - Period & Tab Changes

    func changePeriod(_ period: LeaderboardPeriod) async {
        guard period != selectedPeriod else { return }
        selectedPeriod = period
        await refresh()
    }

    func changeTab(_ tab: LeaderboardTab) async {
        guard tab != selectedTab else { return }
        selectedTab = tab
        await refresh()
    }

    // MARK: - Private Fetches

    private func fetchLeaderboard() async {
        do {
            try await competitionService.fetchLeaderboard(
                period: selectedPeriod,
                tab: selectedTab,
                page: 1,
                limit: 50
            )
            entries = competitionService.leaderboard
            logger.info("[Leaderboard] Loaded \(self.entries.count) entries for \(self.selectedPeriod.rawValue)/\(self.selectedTab.rawValue)")
        } catch {
            logger.error("[Leaderboard] Failed to fetch entries: \(error.localizedDescription)")
            loadState = .error("Failed to load leaderboard. Pull to retry.")
        }
    }

    private func fetchMyRanking() async {
        do {
            try await competitionService.fetchMyRanking()
            if let serviceRanking = competitionService.myRanking {
                myRanking = MyRankingDTO(
                    rank: serviceRanking.rank,
                    growthPct: serviceRanking.growthPct,
                    totalEquity: serviceRanking.totalEquity
                )
            }
        } catch {
            logger.warning("[Leaderboard] Failed to fetch my ranking: \(error.localizedDescription)")
            // Non-critical; don't override the main load state for this
        }
    }

    // MARK: - Formatting

    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$\(String(format: "%.2f", value))"
    }
}
