//
//  HomeViewModel.swift
//  Jyanik
//
//  View model for the Home/Dashboard screen managing portfolio, competitions, and trades
//

import Foundation
import Observation
import OSLog

@Observable
final class HomeViewModel {

    // MARK: - State

    private(set) var loadState: LoadState = .idle

    // Portfolio
    private(set) var portfolio: PortfolioDTO?
    private(set) var positions: [PositionDTO] = []

    // Competitions
    private(set) var competitions: [CompetitionDTO] = []
    private(set) var myRanking: LeaderboardEntryDTO?

    // Recent Trades
    private(set) var recentTrades: [TransactionDTO] = []

    // Stats
    private(set) var totalPrizesWon: Double = 0

    // MARK: - Dependencies

    private let portfolioService: PortfolioService
    private let competitionService: CompetitionService
    private let logger = Logger(subsystem: "com.jyanik", category: "HomeViewModel")

    // MARK: - Init

    init(
        portfolioService: PortfolioService = PortfolioService(),
        competitionService: CompetitionService = CompetitionService()
    ) {
        self.portfolioService = portfolioService
        self.competitionService = competitionService
    }

    // MARK: - Computed Properties

    var totalEquity: Double {
        portfolio?.totalEquity ?? 0
    }

    var cashBalance: Double {
        portfolio?.cashBalance ?? 0
    }

    var totalPnl: Double {
        portfolio?.totalPnl ?? 0
    }

    var totalPnlPct: Double {
        portfolio?.totalPnlPct ?? 0
    }

    var holdingsValue: Double {
        portfolio?.holdingsValue ?? 0
    }

    var hasPortfolio: Bool {
        portfolio != nil
    }

    var hasPositions: Bool {
        !positions.isEmpty
    }

    var hasCompetitions: Bool {
        !competitions.isEmpty
    }

    var hasRecentTrades: Bool {
        !recentTrades.isEmpty
    }

    var totalTrades: Int {
        positions.count
    }

    var winRate: Double {
        guard !positions.isEmpty else { return 0 }
        let winners = positions.filter { $0.unrealizedPnl > 0 }.count
        return Double(winners) / Double(positions.count) * 100.0
    }

    /// Top movers sorted by absolute unrealized P&L percent (biggest swings first).
    var topMovers: [PositionDTO] {
        positions
            .sorted { abs($0.unrealizedPnl) > abs($1.unrealizedPnl) }
            .prefix(5)
            .map { $0 }
    }

    // MARK: - Loading

    /// Loads guest mode with empty portfolio — no hardcoded fake data.
    /// Guest sees empty states with CTAs to sign up and start trading.
    func loadGuestData() {
        portfolio = PortfolioDTO(
            id: "guest-portfolio",
            userId: "guest",
            cashBalance: 25_000.00,
            totalEquity: 25_000.00,
            isActive: 1,
            competitionMonth: nil,
            holdingsValue: 0,
            totalPnl: 0,
            totalPnlPct: 0,
            positions: nil,
            createdAt: "",
            updatedAt: ""
        )

        positions = []
        competitions = []
        recentTrades = []

        loadState = .loaded
        logger.info("[Home] Guest mode — empty portfolio, no hardcoded data")
    }

    /// Loads all home screen data concurrently.
    func loadAll() async {
        loadState = .loading

        do {
            // Portfolio is critical — must succeed
            try await loadPortfolio()

            // Non-critical data — load concurrently, don't fail if any errors
            async let competitionsTask: () = loadCompetitionsSafe()
            async let rankingTask: () = loadRankingSafe()
            async let prizesTask: () = loadPrizesSafe()

            _ = await (competitionsTask, rankingTask, prizesTask)

            // Load trades after portfolio (needs portfolio ID)
            if let portfolioId = portfolio?.id {
                await loadRecentTrades(portfolioId: portfolioId)
            }

            loadState = .loaded
            logger.info("[Home] All data loaded successfully")
        } catch {
            loadState = .error(error.localizedDescription)
            logger.error("[Home] Failed to load data: \(error.localizedDescription)")
        }
    }

    /// Refreshes all data (called from pull-to-refresh).
    func refresh() async {
        await loadAll()
    }

    // MARK: - Individual Loaders

    private func loadPortfolio() async throws {
        try await portfolioService.fetchActivePortfolio()
        portfolio = portfolioService.activePortfolio
        positions = portfolioService.positions
    }

    private func loadCompetitions() async throws {
        try await competitionService.fetchCurrentCompetitions()
        competitions = competitionService.currentCompetitions
    }

    private func loadCompetitionsSafe() async {
        do {
            try await loadCompetitions()
        } catch {
            logger.warning("[Home] Failed to load competitions: \(error.localizedDescription)")
            // Non-critical — competitions may not exist yet
        }
    }

    private func loadRanking() async throws {
        try await competitionService.fetchMyRanking()
        myRanking = competitionService.myRanking
    }

    private func loadRankingSafe() async {
        do {
            try await loadRanking()
        } catch {
            logger.warning("[Home] Failed to load ranking: \(error.localizedDescription)")
            // Non-critical — user may not be in any competition yet
        }
    }

    private func loadPrizesSafe() async {
        do {
            let history = try await competitionService.fetchMyHistory(page: 1, limit: 100)
            totalPrizesWon = history.compactMap(\.prizeAmount).reduce(0, +)
        } catch {
            logger.warning("[Home] Failed to load prizes: \(error.localizedDescription)")
        }
    }

    private func loadRecentTrades(portfolioId: String) async {
        do {
            let result = try await portfolioService.fetchTransactions(
                portfolioId: portfolioId,
                page: 1,
                limit: 5
            )
            recentTrades = result.transactions
        } catch {
            logger.warning("[Home] Failed to load recent trades: \(error.localizedDescription)")
            // Non-critical -- don't fail the whole load
        }
    }
}
