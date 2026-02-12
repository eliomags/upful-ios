//
//  CompeteViewModel.swift
//  Jyanik
//
//  ViewModel for the Compete tab managing competitions and leaderboard
//

import Foundation
import Observation
import OSLog

@Observable
final class CompeteViewModel {

    // MARK: - State

    private(set) var activeCompetitions: [CompetitionDTO] = []
    private(set) var availableCompetitions: [CompetitionDTO] = []
    private(set) var myRanking: LeaderboardEntryDTO?
    private(set) var isLoading = false
    private(set) var isJoining = false
    private(set) var errorMessage: String?

    /// Set of competition IDs the user has joined (tracked locally for UI state).
    private(set) var joinedCompetitionIDs: Set<String> = []

    // MARK: - Dependencies

    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "CompeteViewModel")

    // MARK: - Init

    init(competitionService: CompetitionService) {
        self.competitionService = competitionService
    }

    // MARK: - Load All Data

    /// Loads competitions and user ranking in parallel.
    func loadData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchCompetitions() }
            group.addTask { await self.fetchMyRanking() }
        }
    }

    /// Pull-to-refresh handler.
    func refresh() async {
        await loadData()
    }

    // MARK: - Fetch Competitions

    private func fetchCompetitions() async {
        do {
            try await competitionService.fetchCurrentCompetitions()
            let all = competitionService.currentCompetitions

            // Separate into active (user joined) and available (can join).
            // Competitions with status "active" that the user has joined go to activeCompetitions.
            // For now, we treat competitions the user has explicitly joined via the joinedCompetitionIDs set.
            activeCompetitions = all.filter { joinedCompetitionIDs.contains($0.id) }
            availableCompetitions = all.filter { !joinedCompetitionIDs.contains($0.id) }

            logger.info("[Compete] Loaded \(all.count) competitions")
        } catch {
            logger.error("[Compete] Failed to fetch competitions: \(error.localizedDescription)")
            errorMessage = "Failed to load competitions. Pull to retry."
        }
    }

    // MARK: - Fetch My Ranking

    private func fetchMyRanking() async {
        do {
            try await competitionService.fetchMyRanking()
            myRanking = competitionService.myRanking
        } catch {
            logger.warning("[Compete] Failed to fetch ranking: \(error.localizedDescription)")
            // Non-critical: don't surface error for ranking alone
        }
    }

    // MARK: - Join Competition

    /// Joins a competition by ID and moves it from available to active.
    func joinCompetition(_ competition: CompetitionDTO) async {
        guard !isJoining else { return }

        isJoining = true
        defer { isJoining = false }

        // Optimistically update UI
        joinedCompetitionIDs.insert(competition.id)
        availableCompetitions.removeAll { $0.id == competition.id }
        activeCompetitions.append(competition)

        logger.info("[Compete] Joined competition: \(competition.id)")

        // Refresh data to get server-confirmed state
        await fetchCompetitions()
    }

    // MARK: - Computed Helpers

    var hasActiveCompetitions: Bool {
        !activeCompetitions.isEmpty
    }

    var hasAvailableCompetitions: Bool {
        !availableCompetitions.isEmpty
    }

    var isEmpty: Bool {
        activeCompetitions.isEmpty && availableCompetitions.isEmpty
    }

    var formattedRank: String? {
        guard let rank = myRanking?.rank else { return nil }
        return "#\(rank)"
    }

    // MARK: - Formatting Helpers

    func formattedPrizePool(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(Int(amount))"
    }

    func formattedDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none

        if let date = isoFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }

        // Fallback: try without fractional seconds
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }

        return dateString
    }

    func competitionStatusBadge(_ status: String) -> (text: String, color: String) {
        switch status.lowercased() {
        case "active":
            return ("Active", "success")
        case "upcoming":
            return ("Upcoming", "info")
        case "completed", "ended":
            return ("Ended", "textSecondary")
        case "registration":
            return ("Open", "accent")
        default:
            return (status.capitalized, "textSecondary")
        }
    }
}
