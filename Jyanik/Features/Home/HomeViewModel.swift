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
        portfolio = PortfolioDTO(
            id: "guest-portfolio",
            userId: "guest",
            cashBalance: 18_735.42,
            totalEquity: 25_000.00,
            isActive: 1,
            competitionMonth: "2026-02",
            holdingsValue: 6_264.58,
            totalPnl: 234.08,
            totalPnlPct: 0.94,
            positions: nil,
            createdAt: "2026-02-01T00:00:00Z",
            updatedAt: "2026-02-20T12:00:00Z"
        )

        positions = [
            PositionDTO(id: "p1", portfolioId: "guest-portfolio", ticker: "AAPL", assetType: "stock", quantity: 5, averageCost: 185.20, currentPrice: 192.53, marketValue: 962.65, unrealizedPnl: 36.65, unrealizedPnlPct: 3.96, updatedAt: nil, createdAt: nil),
            PositionDTO(id: "p2", portfolioId: "guest-portfolio", ticker: "TSLA", assetType: "stock", quantity: 3, averageCost: 245.00, currentPrice: 258.10, marketValue: 774.30, unrealizedPnl: 39.30, unrealizedPnlPct: 5.35, updatedAt: nil, createdAt: nil),
            PositionDTO(id: "p3", portfolioId: "guest-portfolio", ticker: "MSFT", assetType: "stock", quantity: 4, averageCost: 410.50, currentPrice: 422.80, marketValue: 1691.20, unrealizedPnl: 49.20, unrealizedPnlPct: 3.00, updatedAt: nil, createdAt: nil),
            PositionDTO(id: "p4", portfolioId: "guest-portfolio", ticker: "NVDA", assetType: "stock", quantity: 2, averageCost: 875.00, currentPrice: 912.40, marketValue: 1824.80, unrealizedPnl: 74.80, unrealizedPnlPct: 4.28, updatedAt: nil, createdAt: nil),
            PositionDTO(id: "p5", portfolioId: "guest-portfolio", ticker: "AMZN", assetType: "stock", quantity: 5, averageCost: 195.30, currentPrice: 202.33, marketValue: 1011.63, unrealizedPnl: 35.13, unrealizedPnlPct: 3.60, updatedAt: nil, createdAt: nil),
        ]

        competitions = [
            CompetitionDTO(id: "comp-weekly", type: "weekly", status: "active", startDate: "2026-02-16", endDate: "2026-02-22", totalPrizePool: 500, participantCount: 128, createdAt: "2026-02-16T00:00:00Z", tier: "free", description: nil, rules: nil, isJoined: true),
            CompetitionDTO(id: "comp-monthly", type: "monthly", status: "active", startDate: "2026-02-01", endDate: "2026-02-28", totalPrizePool: 2500, participantCount: 312, createdAt: "2026-02-01T00:00:00Z", tier: "free", description: nil, rules: nil, isJoined: true),
        ]

        loadState = .loaded
        logger.info("[Home] Guest mode — showing sample dashboard")
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
