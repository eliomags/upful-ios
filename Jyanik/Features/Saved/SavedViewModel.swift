//
//  SavedViewModel.swift
//  Jyanik
//
//  ViewModel for saved watchlist stocks and saved screener configurations
//

import Foundation
import Observation
import OSLog

@Observable
final class SavedViewModel {

    // MARK: - Tab

    enum Tab: String, CaseIterable, Identifiable {
        case watchlist = "Watchlist"
        case screeners = "Screeners"

        var id: String { rawValue }
    }

    // MARK: - State

    var selectedTab: Tab = .watchlist

    private(set) var savedStocks: [SavedStock] = []
    private(set) var savedScreeners: [SavedScreener] = []
    private(set) var isLoading = false

    // MARK: - Dependencies

    private let logger = Logger(subsystem: "com.jyanik", category: "SavedViewModel")

    // MARK: - Init

    init() {
        loadMockData()
    }

    // MARK: - Watchlist

    func loadWatchlist() async {
        isLoading = true
        // Future: connect to WatchlistEndpoints.getWatchlist()
        // For now, mock data is loaded in init
        try? await Task.sleep(for: .milliseconds(300))
        isLoading = false
        logger.info("[Saved] Watchlist loaded with \(self.savedStocks.count) items")
    }

    func removeStock(at offsets: IndexSet) {
        let removed = offsets.map { savedStocks[$0].ticker }
        savedStocks.remove(atOffsets: offsets)
        logger.info("[Saved] Removed stocks: \(removed)")
    }

    func reorderStocks(from source: IndexSet, to destination: Int) {
        savedStocks.move(fromOffsets: source, toOffset: destination)

        // Update sort orders
        for (index, stock) in savedStocks.enumerated() {
            stock.sortOrder = index
        }

        logger.info("[Saved] Reordered watchlist")
    }

    func addToWatchlist(ticker: String, companyName: String) {
        // Check for duplicates
        guard !savedStocks.contains(where: { $0.ticker == ticker }) else {
            logger.info("[Saved] \(ticker) already in watchlist")
            return
        }

        let stock = SavedStock(
            ticker: ticker,
            companyName: companyName,
            sortOrder: savedStocks.count,
            addedAt: ISO8601DateFormatter().string(from: Date())
        )
        savedStocks.append(stock)
        logger.info("[Saved] Added \(ticker) to watchlist")
    }

    // MARK: - Screeners

    func loadScreeners() async {
        isLoading = true
        // Future: load from SwiftData
        try? await Task.sleep(for: .milliseconds(300))
        isLoading = false
        logger.info("[Saved] Screeners loaded with \(self.savedScreeners.count) items")
    }

    func removeScreener(at offsets: IndexSet) {
        let removed = offsets.map { savedScreeners[$0].name }
        savedScreeners.remove(atOffsets: offsets)
        logger.info("[Saved] Removed screeners: \(removed)")
    }

    /// Decodes the JSON filters string from a SavedScreener into ScreenerFilters.
    func decodeFilters(from screener: SavedScreener) -> ScreenerFilters? {
        guard let data = screener.filters.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(ScreenerFilters.self, from: data)
    }

    /// Returns a human-readable summary of a SavedScreener's filter configuration.
    func filterSummary(for screener: SavedScreener) -> String {
        guard let filters = decodeFilters(from: screener) else { return "Custom filters" }

        var parts: [String] = []

        if let sector = filters.sector {
            parts.append(sector)
        }
        if let exchange = filters.exchange {
            parts.append(exchange)
        }
        if let minPrice = filters.priceMin {
            parts.append("$\(Int(minPrice))+")
        }
        if let maxPrice = filters.priceMax {
            parts.append("< $\(Int(maxPrice))")
        }
        if let sortBy = filters.sortBy {
            parts.append("by \(sortBy.replacingOccurrences(of: "_", with: " "))")
        }

        return parts.isEmpty ? "All assets" : parts.joined(separator: " - ")
    }

    // MARK: - Mock Data

    private func loadMockData() {
        savedStocks = [
            SavedStock(ticker: "AAPL", companyName: "Apple Inc.", sortOrder: 0, addedAt: "2024-11-15T10:00:00Z"),
            SavedStock(ticker: "NVDA", companyName: "NVIDIA Corporation", sortOrder: 1, addedAt: "2024-11-10T14:30:00Z"),
            SavedStock(ticker: "MSFT", companyName: "Microsoft Corp.", sortOrder: 2, addedAt: "2024-11-08T09:15:00Z"),
            SavedStock(ticker: "TSLA", companyName: "Tesla, Inc.", sortOrder: 3, addedAt: "2024-10-20T16:45:00Z"),
            SavedStock(ticker: "GOOGL", companyName: "Alphabet Inc.", sortOrder: 4, addedAt: "2024-10-15T11:00:00Z"),
        ]

        let techFilters = """
        {"sector":"Technology","sort_by":"market_cap","sort_order":"desc","limit":25}
        """
        let pennyFilters = """
        {"price_max":5,"sort_by":"volume","sort_order":"desc","limit":25}
        """
        let healthFilters = """
        {"sector":"Healthcare","market_cap_min":10000000000,"sort_by":"market_cap","sort_order":"desc","limit":25}
        """

        savedScreeners = [
            SavedScreener(
                name: "Tech Giants",
                filters: techFilters,
                createdAt: "2024-11-10T10:00:00Z",
                updatedAt: "2024-11-10T10:00:00Z"
            ),
            SavedScreener(
                name: "Penny Stocks",
                filters: pennyFilters,
                createdAt: "2024-10-25T14:30:00Z",
                updatedAt: "2024-10-25T14:30:00Z"
            ),
            SavedScreener(
                name: "Large Cap Healthcare",
                filters: healthFilters,
                createdAt: "2024-10-15T09:00:00Z",
                updatedAt: "2024-10-20T12:00:00Z"
            ),
        ]
    }
}

// Note: ScreenerFilters is now Codable (Encodable + Decodable) in MarketEndpoints.swift
// Auto-synthesized decoding works since all properties are optional standard types.
