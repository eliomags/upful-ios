//
//  PortfolioService.swift
//  Jyanik
//
//  Manages portfolio data, positions, transactions, and performance
//

import Foundation
import Observation
import OSLog

@Observable
final class PortfolioService {

    // MARK: - State

    private(set) var activePortfolio: PortfolioDTO?
    private(set) var positions: [PositionDTO] = []
    private(set) var isLoading = false

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "PortfolioService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Fetch Active Portfolio

    /// Fetches the user's active portfolio with embedded positions.
    func fetchActivePortfolio() async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = PortfolioEndpoints.getActivePortfolio()
        let portfolio: PortfolioDTO = try await apiClient.request(endpoint)

        activePortfolio = portfolio
        positions = portfolio.positions ?? []

        logger.info("[Portfolio] Fetched active portfolio: \(portfolio.id)")
    }

    // MARK: - Create Portfolio

    /// Creates a new portfolio for the current user.
    @discardableResult
    func createPortfolio() async throws -> PortfolioDTO {
        isLoading = true
        defer { isLoading = false }

        let endpoint = PortfolioEndpoints.createPortfolio()
        let portfolio: PortfolioDTO = try await apiClient.request(endpoint)

        activePortfolio = portfolio
        positions = portfolio.positions ?? []

        logger.info("[Portfolio] Created new portfolio: \(portfolio.id)")
        return portfolio
    }

    // MARK: - Fetch Positions

    /// Fetches positions for a specific portfolio.
    @discardableResult
    func fetchPositions(portfolioId: String) async throws -> [PositionDTO] {
        let endpoint = PortfolioEndpoints.getPositions(portfolioId: portfolioId)
        let response: PositionsResponseDTO = try await apiClient.request(endpoint)

        // Update local state if this is the active portfolio
        if portfolioId == activePortfolio?.id {
            positions = response.positions
        }

        logger.info("[Portfolio] Fetched \(response.positions.count) positions for portfolio: \(portfolioId)")
        return response.positions
    }

    // MARK: - Fetch Transactions

    /// Fetches paginated trade history for a portfolio.
    func fetchTransactions(
        portfolioId: String,
        page: Int = 1,
        limit: Int = 20
    ) async throws -> (transactions: [TransactionDTO], hasMore: Bool) {
        let endpoint = PortfolioEndpoints.getTransactions(
            portfolioId: portfolioId,
            page: page,
            limit: limit
        )
        let response: TransactionsPageDTO = try await apiClient.request(endpoint)

        let hasMore = response.pagination.hasMore ?? (page < (response.pagination.totalPages ?? 1))

        logger.info("[Portfolio] Fetched \(response.data.count) transactions (page \(page))")
        return (response.data, hasMore)
    }

    // MARK: - Fetch Performance

    /// Fetches performance snapshots for charting.
    func fetchPerformance(
        portfolioId: String,
        range: PerformanceRange = .oneMonth
    ) async throws -> [PortfolioSnapshotDTO] {
        let endpoint = PortfolioEndpoints.getPerformance(
            portfolioId: portfolioId,
            range: range
        )
        let response: SnapshotsResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Portfolio] Fetched \(response.snapshots.count) snapshots for range: \(range.rawValue)")
        return response.snapshots
    }

    // MARK: - Helpers

    /// Convenience to refresh the active portfolio after a trade.
    func refreshAfterTrade() async {
        do {
            try await fetchActivePortfolio()
        } catch {
            logger.warning("[Portfolio] Failed to refresh after trade: \(error.localizedDescription)")
        }
    }
}
