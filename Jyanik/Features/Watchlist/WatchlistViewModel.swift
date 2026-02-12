//
//  WatchlistViewModel.swift
//  Jyanik
//
//  View model for watchlist management: load, add, remove, reorder stocks
//

import Foundation
import Observation
import OSLog

// MARK: - Watchlist Item

struct WatchlistItem: Identifiable {
    let ticker: String
    let companyName: String
    var currentPrice: Double
    var changeDollar: Double
    var changePercent: Double

    var id: String { ticker }
}

// MARK: - Load State

enum WatchlistLoadState {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - Watchlist View Model

@Observable
final class WatchlistViewModel {

    // MARK: - State

    private(set) var watchlistItems: [WatchlistItem] = []
    private(set) var loadState: WatchlistLoadState = .idle
    var isEditing = false

    // Search sheet state
    var isShowingAddSheet = false
    var searchText = "" {
        didSet { handleSearchTextChange() }
    }
    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var isSearching = false

    // MARK: - Dependencies

    private let marketDataService: MarketDataService
    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "WatchlistViewModel")
    private var searchTask: Task<Void, Never>?

    // MARK: - Init

    init(
        marketDataService: MarketDataService = MarketDataService(),
        apiClient: APIClient = .shared
    ) {
        self.marketDataService = marketDataService
        self.apiClient = apiClient
    }

    // MARK: - Data Loading

    func loadWatchlist() async {
        if case .loading = loadState { return }

        loadState = .loading

        // For now, use mock data. Future: fetch from WatchlistEndpoints then fetch quotes.
        do {
            try await Task.sleep(for: .milliseconds(400))
            watchlistItems = Self.mockWatchlistItems
            loadState = .loaded
            logger.info("[Watchlist] Loaded \(self.watchlistItems.count) items")
        } catch {
            loadState = .error("Failed to load watchlist.")
            logger.error("[Watchlist] Load failed: \(error.localizedDescription)")
        }
    }

    func refresh() async {
        loadState = .loading

        do {
            try await Task.sleep(for: .milliseconds(300))
            // Re-generate slight price variations to simulate refresh
            watchlistItems = watchlistItems.map { item in
                let priceShift = Double.random(in: -2.0...2.0)
                let newPrice = max(1.0, item.currentPrice + priceShift)
                let newChangeDollar = item.changeDollar + priceShift
                let newChangePercent = (newChangeDollar / (newPrice - newChangeDollar)) * 100
                return WatchlistItem(
                    ticker: item.ticker,
                    companyName: item.companyName,
                    currentPrice: newPrice,
                    changeDollar: newChangeDollar,
                    changePercent: newChangePercent
                )
            }
            loadState = .loaded
        } catch {
            loadState = .error("Failed to refresh watchlist.")
        }
    }

    // MARK: - Mutations

    func removeStock(ticker: String) {
        watchlistItems.removeAll { $0.ticker == ticker }
        logger.info("[Watchlist] Removed \(ticker)")

        // Future: call WatchlistEndpoints.removeFromWatchlist(ticker:)
    }

    func moveStock(from source: IndexSet, to destination: Int) {
        watchlistItems.move(fromOffsets: source, toOffset: destination)
        let tickers = watchlistItems.map(\.ticker)
        logger.info("[Watchlist] Reordered: \(tickers.joined(separator: ", "))")

        // Future: call WatchlistEndpoints.reorderWatchlist(tickers:)
    }

    func addStock(ticker: String, companyName: String) {
        guard !watchlistItems.contains(where: { $0.ticker == ticker }) else {
            logger.info("[Watchlist] \(ticker) already in watchlist")
            return
        }

        // Generate mock price data for the newly added stock
        let price = Double.random(in: 20...500)
        let changeDollar = Double.random(in: -10...10)
        let changePercent = (changeDollar / (price - changeDollar)) * 100

        let item = WatchlistItem(
            ticker: ticker,
            companyName: companyName,
            currentPrice: price,
            changeDollar: changeDollar,
            changePercent: changePercent
        )

        watchlistItems.append(item)
        logger.info("[Watchlist] Added \(ticker)")

        // Future: call WatchlistEndpoints.addToWatchlist(ticker:)
    }

    func isInWatchlist(_ ticker: String) -> Bool {
        watchlistItems.contains { $0.ticker == ticker }
    }

    // MARK: - Search

    private func handleSearchTextChange() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            searchTask?.cancel()
            searchResults = []
            isSearching = false
            return
        }

        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }

            self.isSearching = true

            do {
                try await Task.sleep(for: .milliseconds(300))
                let results = try await self.marketDataService.search(query: query)
                if !Task.isCancelled {
                    self.searchResults = results
                }
            } catch is CancellationError {
                // Expected when superseded
            } catch {
                self.logger.warning("[Watchlist] Search failed: \(error.localizedDescription)")
                if !Task.isCancelled {
                    self.searchResults = []
                }
            }

            if !Task.isCancelled {
                self.isSearching = false
            }
        }
    }

    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        searchResults = []
        isSearching = false
    }

    // MARK: - Mock Data

    private static let mockWatchlistItems: [WatchlistItem] = [
        WatchlistItem(ticker: "AAPL", companyName: "Apple Inc.", currentPrice: 178.52, changeDollar: 2.18, changePercent: 1.24),
        WatchlistItem(ticker: "TSLA", companyName: "Tesla, Inc.", currentPrice: 245.30, changeDollar: -5.38, changePercent: -2.15),
        WatchlistItem(ticker: "MSFT", companyName: "Microsoft Corp.", currentPrice: 378.90, changeDollar: 1.59, changePercent: 0.42),
        WatchlistItem(ticker: "GOOGL", companyName: "Alphabet Inc.", currentPrice: 155.72, changeDollar: 2.83, changePercent: 1.85),
        WatchlistItem(ticker: "AMZN", companyName: "Amazon.com Inc.", currentPrice: 178.25, changeDollar: -0.32, changePercent: -0.18),
        WatchlistItem(ticker: "NVDA", companyName: "NVIDIA Corporation", currentPrice: 875.28, changeDollar: 30.12, changePercent: 3.56),
    ]
}
