//
//  MonthlyResetViewModel.swift
//  Jyanik
//
//  View model for the monthly competition reset sheet.
//  Manages reset choice selection, last month summary, and submission.
//

import Foundation
import Observation
import OSLog

// MARK: - Last Month Summary

struct LastMonthSummary {
    let endingEquity: Double
    let growthPct: Double
    let rank: Int
    let prizeWon: Double
}

// MARK: - Monthly Reset View Model

@Observable
final class MonthlyResetViewModel {

    // MARK: - State

    var selectedChoice: ResetChoice?
    private(set) var isProcessing = false
    private(set) var isComplete = false
    private(set) var errorMessage: String?
    private(set) var lastMonthSummary: LastMonthSummary?

    // MARK: - Dependencies

    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "MonthlyResetViewModel")

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        self.competitionService = competitionService
    }

    // MARK: - Computed

    /// Whether the confirm button should be enabled.
    var canConfirm: Bool {
        selectedChoice != nil && !isProcessing && !isComplete
    }

    /// Formatted ending equity for display.
    var formattedEquity: String {
        guard let summary = lastMonthSummary else { return "$0.00" }
        return "$\(summary.endingEquity.formatted(.number.precision(.fractionLength(2))))"
    }

    /// Formatted growth percentage for display.
    var formattedGrowth: String {
        guard let summary = lastMonthSummary else { return "0.0%" }
        let sign = summary.growthPct >= 0 ? "+" : ""
        return "\(sign)\(summary.growthPct.formatted(.number.precision(.fractionLength(1))))%"
    }

    /// Whether growth was positive last month.
    var isGrowthPositive: Bool {
        (lastMonthSummary?.growthPct ?? 0) >= 0
    }

    /// Formatted rank for display.
    var formattedRank: String {
        guard let summary = lastMonthSummary else { return "--" }
        return "#\(summary.rank)"
    }

    /// Formatted prize won, or nil if no prize.
    var formattedPrize: String? {
        guard let summary = lastMonthSummary, summary.prizeWon > 0 else { return nil }
        return "$\(summary.prizeWon.formatted(.number.precision(.fractionLength(2))))"
    }

    // MARK: - Actions

    /// Loads the summary of last month's competition performance.
    func loadLastMonthSummary() async {
        // Mock data for now; will be replaced with API call to competition history.
        lastMonthSummary = LastMonthSummary(
            endingEquity: 28_450.00,
            growthPct: 13.8,
            rank: 26,
            prizeWon: 0
        )
        logger.info("[MonthlyReset] Loaded last month summary")
    }

    /// Submits the user's reset choice to the server.
    func confirmReset() async {
        guard let choice = selectedChoice else { return }
        guard !isProcessing else { return }

        isProcessing = true
        errorMessage = nil

        do {
            try await competitionService.submitResetChoice(choice)
            isComplete = true
            logger.info("[MonthlyReset] Reset choice confirmed: \(choice.rawValue)")
        } catch {
            logger.error("[MonthlyReset] Reset failed: \(error.localizedDescription)")
            errorMessage = "Failed to submit your choice. Please try again."
            isProcessing = false
        }
    }

    /// Selects a reset choice.
    func selectChoice(_ choice: ResetChoice) {
        guard !isProcessing && !isComplete else { return }
        selectedChoice = choice
    }

    /// Clears any displayed error.
    func dismissError() {
        errorMessage = nil
    }
}
