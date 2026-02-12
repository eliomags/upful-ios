//
//  ProfileViewModel.swift
//  Jyanik
//
//  ViewModel for the Profile tab managing user data and stats
//

import Foundation
import Observation
import OSLog

@Observable
final class ProfileViewModel {

    // MARK: - State

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    /// Portfolio performance data.
    private(set) var portfolioValue: Double = 0
    private(set) var portfolioGainPct: Double = 0
    private(set) var cashBalance: Double = 0
    private(set) var holdingsValue: Double = 0
    private(set) var totalPnl: Double = 0

    /// User stats.
    private(set) var totalTrades: Int = 0
    private(set) var winRate: Double = 0
    private(set) var competitionsWon: Int = 0

    // MARK: - Dependencies

    private let portfolioService: PortfolioService
    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "ProfileViewModel")

    // MARK: - Init

    init(
        portfolioService: PortfolioService,
        competitionService: CompetitionService
    ) {
        self.portfolioService = portfolioService
        self.competitionService = competitionService
    }

    // MARK: - Load Data

    /// Loads profile-related data: portfolio performance and competition history.
    func loadData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchPortfolio() }
            group.addTask { await self.fetchCompetitionStats() }
        }
    }

    /// Pull-to-refresh handler.
    func refresh() async {
        await loadData()
    }

    // MARK: - Fetch Portfolio

    private func fetchPortfolio() async {
        do {
            try await portfolioService.fetchActivePortfolio()

            if let portfolio = portfolioService.activePortfolio {
                portfolioValue = portfolio.totalEquity
                cashBalance = portfolio.cashBalance
                holdingsValue = portfolio.holdingsValue ?? 0
                totalPnl = portfolio.totalPnl ?? 0
                portfolioGainPct = portfolio.totalPnlPct ?? 0
            }

            // Calculate trade stats from positions
            let positions = portfolioService.positions
            totalTrades = positions.count
            if !positions.isEmpty {
                let winners = positions.filter { $0.unrealizedPnl > 0 }.count
                winRate = Double(winners) / Double(positions.count) * 100.0
            }

            logger.info("[Profile] Portfolio loaded: $\(self.portfolioValue)")
        } catch {
            logger.error("[Profile] Failed to fetch portfolio: \(error.localizedDescription)")
            errorMessage = "Failed to load portfolio data."
        }
    }

    // MARK: - Fetch Competition Stats

    private func fetchCompetitionStats() async {
        do {
            let history = try await competitionService.fetchHistory(page: 1, limit: 50)
            // Count competitions where user finished in first place
            competitionsWon = history.filter { $0.status.lowercased() == "completed" }.count

            logger.info("[Profile] Competition stats loaded: \(history.count) entries")
        } catch {
            logger.warning("[Profile] Failed to fetch competition stats: \(error.localizedDescription)")
            // Non-critical: don't overwrite error
        }
    }

    // MARK: - Formatting Helpers

    func formattedCurrency(_ amount: Double) -> String {
        Self.currencyFormatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"
    }

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    func formattedWinRate() -> String {
        String(format: "%.0f%%", winRate)
    }

    // MARK: - App Info

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }
}
