//
//  UserPerformanceViewModel.swift
//  Jyanik
//
//  ViewModel for the public user profile showing competition history and performance stats.
//

import Foundation
import Observation
import OSLog

@Observable
final class UserPerformanceViewModel {

    // MARK: - State

    private(set) var loadState: LoadState = .idle
    private(set) var profile: UserPerformanceProfileDTO?
    private(set) var stats: UserPerformanceStatsDTO?
    private(set) var history: [CompetitionHistoryEntryDTO] = []

    // MARK: - Dependencies

    private let userId: String
    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "UserPerformanceVM")

    // MARK: - Init

    init(userId: String, competitionService: CompetitionService = CompetitionService()) {
        self.userId = userId
        self.competitionService = competitionService
    }

    // MARK: - Data Loading

    func load() async {
        guard loadState != .loading else { return }

        loadState = .loading

        do {
            let response = try await competitionService.fetchUserPerformance(userId: userId)
            profile = response.user
            stats = response.stats
            history = response.history
            loadState = .loaded
            logger.info("[UserPerf] Loaded performance for \(self.userId): \(response.history.count) entries")
        } catch {
            logger.error("[UserPerf] Failed to load performance: \(error.localizedDescription)")
            loadState = .error("Failed to load profile. Pull to retry.")
        }
    }

    // MARK: - Computed: Display

    var displayName: String {
        profile?.displayName ?? profile?.username ?? "User"
    }

    var username: String {
        profile?.username ?? "unknown"
    }

    var initials: String {
        let name = displayName
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    var isPremium: Bool {
        (profile?.subscriptionTier ?? "free") == "premium"
    }

    var memberSinceFormatted: String? {
        guard let dateStr = profile?.memberSince else { return nil }
        return JFormatters.mediumDateString(from: dateStr)
    }

    var hasHistory: Bool {
        !history.isEmpty
    }

    // MARK: - Computed: Stats

    var formattedAvgGrowth: String {
        guard let stats else { return "--" }
        let pct = stats.avgGrowthPct
        let sign = pct >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", pct))%"
    }

    var formattedBestRank: String {
        guard let rank = stats?.bestRank else { return "--" }
        return "#\(rank)"
    }

    var formattedTotalPrize: String {
        guard let stats else { return "$0" }
        return JFormatters.prizePool(stats.totalPrizeWon)
    }
}
