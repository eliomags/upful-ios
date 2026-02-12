//
//  MarketsViewModel.swift
//  Jyanik
//
//  View model for the Markets screen: search, indices, trending, movers
//

import Foundation
import Observation
import OSLog

// MARK: - Market Index

struct MarketIndex: Identifiable {
    let id: String
    let name: String
    let shortName: String
    let value: Double
    let changePercent: Double

    var isPositive: Bool { changePercent >= 0 }

    var formattedValue: String {
        value.formatted(.number.precision(.fractionLength(2)))
    }

    var formattedChange: String {
        let sign = changePercent >= 0 ? "+" : ""
        return "\(sign)\(changePercent.formatted(.number.precision(.fractionLength(2))))%"
    }
}

// MARK: - Market Section

enum MarketSection: String, CaseIterable, Identifiable {
    case trending = "Trending"
    case mostActive = "Most Active"
    case topGainers = "Top Gainers"
    case topLosers = "Top Losers"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .trending: return "flame.fill"
        case .mostActive: return "chart.bar.fill"
        case .topGainers: return "arrow.up.right"
        case .topLosers: return "arrow.down.right"
        }
    }

    var iconColor: MarketSectionColor {
        switch self {
        case .trending: return .orange
        case .mostActive: return .blue
        case .topGainers: return .green
        case .topLosers: return .red
        }
    }
}

enum MarketSectionColor {
    case orange, blue, green, red
}

// MARK: - Stock Display Item

struct StockDisplayItem: Identifiable {
    let ticker: String
    let companyName: String
    let price: Double
    let changePercent: Double
    let sparkline: [Double]

    var id: String { ticker }
}

// MARK: - Markets View Model

@Observable
final class MarketsViewModel {

    // MARK: - State

    var searchText = "" {
        didSet { handleSearchTextChange() }
    }

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var indices: [MarketIndex] = []
    private(set) var trendingStocks: [StockDisplayItem] = []
    private(set) var mostActiveStocks: [StockDisplayItem] = []
    private(set) var topGainers: [StockDisplayItem] = []
    private(set) var topLosers: [StockDisplayItem] = []

    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var isSearching = false

    var isShowingSearch: Bool {
        !searchText.isEmpty
    }

    // MARK: - Dependencies

    private let marketDataService: MarketDataService
    private let logger = Logger(subsystem: "com.jyanik", category: "MarketsViewModel")
    private var searchTask: Task<Void, Never>?

    // MARK: - Init

    init(marketDataService: MarketDataService = MarketDataService()) {
        self.marketDataService = marketDataService
    }

    // MARK: - Data Loading

    func loadMarketData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        // Load mock indices (these would come from a real API)
        loadMockIndices()

        // Try fetching real data; fall back to mock data on failure
        do {
            try await loadSectionData()
        } catch {
            logger.warning("[Markets] API fetch failed, using mock data: \(error.localizedDescription)")
            loadMockStocks()
        }

        isLoading = false
    }

    func refresh() async {
        errorMessage = nil
        loadMockIndices()

        do {
            try await loadSectionData()
        } catch {
            logger.warning("[Markets] Refresh failed: \(error.localizedDescription)")
            errorMessage = "Could not refresh market data. Pull to retry."
        }
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
                try await Task.sleep(for: .milliseconds(350))
                let results = try await self.marketDataService.search(query: query)
                if !Task.isCancelled {
                    self.searchResults = results
                }
            } catch is CancellationError {
                // Expected on rapid typing
            } catch {
                self.logger.warning("[Markets] Search failed: \(error.localizedDescription)")
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
        searchText = ""
        searchResults = []
        isSearching = false
        searchTask?.cancel()
    }

    // MARK: - Helpers

    func stocks(for section: MarketSection) -> [StockDisplayItem] {
        switch section {
        case .trending: return trendingStocks
        case .mostActive: return mostActiveStocks
        case .topGainers: return topGainers
        case .topLosers: return topLosers
        }
    }

    // MARK: - Private: API Fetch

    private func loadSectionData() async throws {
        // Attempt to fetch real search-based data for each category.
        // In production these would be dedicated endpoints (e.g., /market/movers).
        // For now we use search as a proxy and fall back to mock data.
        async let trendingResult = marketDataService.search(query: "AAPL MSFT GOOGL AMZN NVDA")
        async let activeResult = marketDataService.search(query: "TSLA AMD PLTR SOFI META")
        async let gainersResult = marketDataService.search(query: "SMCI MSTR ARM CRWD PANW")
        async let losersResult = marketDataService.search(query: "INTC NKE PFE WBA PARA")

        let (trending, active, gainers, losers) = try await (
            trendingResult, activeResult, gainersResult, losersResult
        )

        if trending.isEmpty && active.isEmpty {
            // If API returned nothing useful, use mock data
            loadMockStocks()
        } else {
            trendingStocks = trending.prefix(6).map { mapSearchToDisplay($0) }
            mostActiveStocks = active.prefix(6).map { mapSearchToDisplay($0) }
            topGainers = gainers.prefix(6).map { mapSearchToDisplay($0, positive: true) }
            topLosers = losers.prefix(6).map { mapSearchToDisplay($0, positive: false) }
        }
    }

    private func mapSearchToDisplay(_ result: SearchResultDTO, positive: Bool? = nil) -> StockDisplayItem {
        // Generate plausible mock price/change data for display.
        // Real data would come from a quote endpoint.
        let basePrice = Double.random(in: 25...500)
        let change: Double
        if let positive {
            change = positive
                ? Double.random(in: 1.5...8.0)
                : Double.random(in: -8.0 ... -1.5)
        } else {
            change = Double.random(in: -4.0...6.0)
        }
        let sparkline = generateSparkline(count: 7, trending: change >= 0)

        return StockDisplayItem(
            ticker: result.symbol,
            companyName: result.name,
            price: basePrice,
            changePercent: change,
            sparkline: sparkline
        )
    }

    // MARK: - Private: Mock Data

    private func loadMockIndices() {
        indices = [
            MarketIndex(id: "SPX", name: "S&P 500", shortName: "S&P", value: 5248.49, changePercent: 0.68),
            MarketIndex(id: "IXIC", name: "NASDAQ", shortName: "NASDAQ", value: 16742.39, changePercent: 1.12),
            MarketIndex(id: "DJI", name: "Dow Jones", shortName: "DOW", value: 39512.84, changePercent: -0.22),
        ]
    }

    private func loadMockStocks() {
        trendingStocks = [
            StockDisplayItem(ticker: "AAPL", companyName: "Apple Inc.", price: 178.52, changePercent: 1.24, sparkline: [170, 172, 171, 174, 176, 175, 178]),
            StockDisplayItem(ticker: "NVDA", companyName: "NVIDIA Corporation", price: 875.28, changePercent: 3.56, sparkline: [840, 845, 855, 850, 860, 870, 875]),
            StockDisplayItem(ticker: "MSFT", companyName: "Microsoft Corp.", price: 378.90, changePercent: 0.42, sparkline: [375, 376, 377, 376, 378, 377, 379]),
            StockDisplayItem(ticker: "GOOGL", companyName: "Alphabet Inc.", price: 155.72, changePercent: 1.85, sparkline: [150, 151, 153, 152, 154, 155, 156]),
            StockDisplayItem(ticker: "AMZN", companyName: "Amazon.com Inc.", price: 178.25, changePercent: -0.18, sparkline: [180, 179, 178, 179, 178, 177, 178]),
            StockDisplayItem(ticker: "META", companyName: "Meta Platforms Inc.", price: 502.30, changePercent: 2.15, sparkline: [488, 490, 495, 493, 498, 500, 502]),
        ]

        mostActiveStocks = [
            StockDisplayItem(ticker: "TSLA", companyName: "Tesla, Inc.", price: 245.30, changePercent: -2.15, sparkline: [255, 252, 250, 248, 249, 246, 245]),
            StockDisplayItem(ticker: "AMD", companyName: "Advanced Micro Devices", price: 174.50, changePercent: 4.20, sparkline: [165, 167, 170, 168, 172, 173, 175]),
            StockDisplayItem(ticker: "PLTR", companyName: "Palantir Technologies", price: 24.80, changePercent: 5.10, sparkline: [22, 23, 23, 24, 23, 24, 25]),
            StockDisplayItem(ticker: "SOFI", companyName: "SoFi Technologies", price: 9.45, changePercent: -1.35, sparkline: [10, 9.8, 9.6, 9.7, 9.5, 9.4, 9.5]),
            StockDisplayItem(ticker: "BAC", companyName: "Bank of America Corp.", price: 37.25, changePercent: 0.85, sparkline: [36, 36.5, 37, 36.8, 37, 37.1, 37.3]),
        ]

        topGainers = [
            StockDisplayItem(ticker: "SMCI", companyName: "Super Micro Computer", price: 1012.40, changePercent: 8.50, sparkline: [920, 940, 960, 950, 980, 1000, 1012]),
            StockDisplayItem(ticker: "MSTR", companyName: "MicroStrategy Inc.", price: 1645.00, changePercent: 6.20, sparkline: [1500, 1530, 1560, 1550, 1600, 1630, 1645]),
            StockDisplayItem(ticker: "ARM", companyName: "ARM Holdings plc", price: 152.30, changePercent: 5.80, sparkline: [140, 142, 145, 144, 148, 150, 152]),
            StockDisplayItem(ticker: "CRWD", companyName: "CrowdStrike Holdings", price: 318.50, changePercent: 4.75, sparkline: [300, 305, 310, 308, 315, 316, 318]),
            StockDisplayItem(ticker: "PANW", companyName: "Palo Alto Networks", price: 372.80, changePercent: 3.90, sparkline: [355, 358, 362, 360, 365, 370, 373]),
        ]

        topLosers = [
            StockDisplayItem(ticker: "INTC", companyName: "Intel Corporation", price: 42.85, changePercent: -4.20, sparkline: [46, 45, 44, 44.5, 43.5, 43, 43]),
            StockDisplayItem(ticker: "NKE", companyName: "Nike, Inc.", price: 94.20, changePercent: -3.50, sparkline: [100, 98, 97, 96, 95, 94.5, 94]),
            StockDisplayItem(ticker: "PFE", companyName: "Pfizer Inc.", price: 27.40, changePercent: -2.80, sparkline: [29, 28.5, 28, 28.2, 27.8, 27.5, 27.4]),
            StockDisplayItem(ticker: "WBA", companyName: "Walgreens Boots Alliance", price: 20.15, changePercent: -2.30, sparkline: [21, 20.8, 20.6, 20.5, 20.3, 20.2, 20.2]),
            StockDisplayItem(ticker: "PARA", companyName: "Paramount Global", price: 12.90, changePercent: -1.95, sparkline: [13.5, 13.3, 13.1, 13.2, 13, 12.9, 12.9]),
        ]
    }

    private func generateSparkline(count: Int, trending: Bool) -> [Double] {
        var points: [Double] = []
        var value = Double.random(in: 50...200)
        for _ in 0..<count {
            let drift = trending ? Double.random(in: -1...3) : Double.random(in: -3...1)
            value += drift
            points.append(max(1, value))
        }
        return points
    }
}
