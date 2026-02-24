//
//  TransactionHistoryViewModel.swift
//  Jyanik
//
//  View model for the full transaction history screen.
//  Loads paginated trades from the portfolio service.
//

import Foundation
import Observation
import OSLog

@Observable
final class TransactionHistoryViewModel {

    // MARK: - State

    private(set) var loadState: LoadState = .idle
    private(set) var transactions: [TransactionDTO] = []
    private(set) var hasMore = false
    private(set) var isLoadingMore = false

    // MARK: - Pagination

    private var currentPage = 1
    private let pageSize = 20

    // MARK: - Dependencies

    private let portfolioService: PortfolioService
    private let logger = Logger(subsystem: "com.jyanik", category: "TransactionHistory")

    // MARK: - Init

    init(portfolioService: PortfolioService = PortfolioService()) {
        self.portfolioService = portfolioService
    }

    // MARK: - Computed

    var isEmpty: Bool {
        transactions.isEmpty && loadState == .loaded
    }

    // MARK: - Loading

    /// Loads the first page of transactions.
    func load() async {
        loadState = .loading
        currentPage = 1

        do {
            // First ensure we have the portfolio
            try await portfolioService.fetchActivePortfolio()

            guard let portfolioId = portfolioService.activePortfolio?.id else {
                loadState = .error("No active portfolio found.")
                return
            }

            let result = try await portfolioService.fetchTransactions(
                portfolioId: portfolioId,
                page: currentPage,
                limit: pageSize
            )

            transactions = result.transactions
            hasMore = result.hasMore
            loadState = .loaded

            logger.info("[TransactionHistory] Loaded \(result.transactions.count) transactions")
        } catch {
            loadState = .error(error.localizedDescription)
            logger.error("[TransactionHistory] Failed to load: \(error.localizedDescription)")
        }
    }

    /// Loads the next page of transactions (infinite scroll).
    func loadMore() async {
        guard hasMore, !isLoadingMore else { return }

        guard let portfolioId = portfolioService.activePortfolio?.id else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextPage = currentPage + 1

        do {
            let result = try await portfolioService.fetchTransactions(
                portfolioId: portfolioId,
                page: nextPage,
                limit: pageSize
            )

            transactions.append(contentsOf: result.transactions)
            hasMore = result.hasMore
            currentPage = nextPage

            logger.info("[TransactionHistory] Loaded page \(nextPage), \(result.transactions.count) more")
        } catch {
            logger.warning("[TransactionHistory] Failed to load page \(nextPage): \(error.localizedDescription)")
        }
    }

    /// Refreshes from the first page.
    func refresh() async {
        await load()
    }

    /// Loads guest demo data.
    func loadGuestData() {
        transactions = [
            TransactionDTO(id: "t1", portfolioId: "guest", ticker: "AAPL", assetType: "stock", side: "buy", quantity: 5, price: 185.20, totalValue: 926.00, executedAt: "2026-02-20T14:30:00Z"),
            TransactionDTO(id: "t2", portfolioId: "guest", ticker: "TSLA", assetType: "stock", side: "buy", quantity: 3, price: 245.00, totalValue: 735.00, executedAt: "2026-02-19T10:15:00Z"),
            TransactionDTO(id: "t3", portfolioId: "guest", ticker: "MSFT", assetType: "stock", side: "buy", quantity: 4, price: 410.50, totalValue: 1642.00, executedAt: "2026-02-18T09:45:00Z"),
            TransactionDTO(id: "t4", portfolioId: "guest", ticker: "NVDA", assetType: "stock", side: "buy", quantity: 2, price: 875.00, totalValue: 1750.00, executedAt: "2026-02-17T11:00:00Z"),
            TransactionDTO(id: "t5", portfolioId: "guest", ticker: "AMZN", assetType: "stock", side: "buy", quantity: 5, price: 195.30, totalValue: 976.50, executedAt: "2026-02-16T15:20:00Z"),
        ]
        hasMore = false
        loadState = .loaded
    }
}
