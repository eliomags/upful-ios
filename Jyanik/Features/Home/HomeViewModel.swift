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

    enum LoadState {
        case idle
        case loading
        case loaded
        case error(String)
    }

    private(set) var loadState: LoadState = .idle

    // Portfolio
    private(set) var portfolio: PortfolioDTO?
    private(set) var positions: [PositionDTO] = []

    // Competitions
    private(set) var competitions: [CompetitionDTO] = []
    private(set) var myRanking: LeaderboardEntryDTO?

    // Recent Trades
    private(set) var recentTrades: [TransactionDTO] = []

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

    /// Top movers sorted by absolute unrealized P&L percent (biggest swings first).
    var topMovers: [PositionDTO] {
        positions
            .sorted { abs($0.unrealizedPnl) > abs($1.unrealizedPnl) }
            .prefix(5)
            .map { $0 }
    }

    // MARK: - Loading

    /// Loads demo data for guest mode (no backend required).
    func loadGuestData() {
        loadState = .loaded
        logger.info("[Home] Guest mode — showing default dashboard")
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

            _ = await (competitionsTask, rankingTask)

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
