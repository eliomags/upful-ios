//
//  ComparisonViewModel.swift
//  Jyanik
//
//  View model for side-by-side stock comparison with metrics and chart data
//

import Foundation
import Observation
import OSLog

// MARK: - Compared Stock

struct ComparedStock: Identifiable {
    let ticker: String
    let companyName: String
    var quote: MarketQuoteDTO?

    var id: String { ticker }

    var isLoaded: Bool { quote != nil }
}

// MARK: - Comparison Metric

struct ComparisonMetric: Identifiable {
    let name: String
    let values: [String]
    let rawValues: [Double?]
    let bestIndex: Int?
    let higherIsBetter: Bool

    var id: String { name }
}

// MARK: - Comparison View Model

@Observable
final class ComparisonViewModel {

    // MARK: - Constants

    static let maxStocks = 4

    // MARK: - State

    private(set) var stocks: [ComparedStock] = []
    private(set) var isLoading = false
    var errorMessage: String?

    // Search sheet state
    var isShowingAddSheet = false
    var searchText = "" {
        didSet { handleSearchTextChange() }
    }
    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var isSearching = false

    // MARK: - Dependencies

    private let marketDataService: MarketDataService
    private let logger = Logger(subsystem: "com.jyanik", category: "ComparisonViewModel")
    private var searchTask: Task<Void, Never>?

    // MARK: - Init

    init(
        primaryTicker: String,
        primaryName: String = "",
        marketDataService: MarketDataService = MarketDataService()
    ) {
        self.marketDataService = marketDataService
        let name = primaryName.isEmpty ? primaryTicker : primaryName
        stocks.append(ComparedStock(ticker: primaryTicker, companyName: name))
    }

    // MARK: - Stock Management

    func addStock(ticker: String, companyName: String) {
        guard stocks.count < Self.maxStocks else {
            errorMessage = "Maximum \(Self.maxStocks) stocks can be compared at once."
            return
        }

        guard !stocks.contains(where: { $0.ticker == ticker }) else {
            errorMessage = "\(ticker) is already in the comparison."
            return
        }

        stocks.append(ComparedStock(ticker: ticker, companyName: companyName))
        errorMessage = nil
        logger.info("[Comparison] Added \(ticker), total: \(self.stocks.count)")

        Task { await loadQuoteForStock(ticker: ticker) }
    }

    func removeStock(ticker: String) {
        guard stocks.first?.ticker != ticker else { return }
        stocks.removeAll { $0.ticker == ticker }
        errorMessage = nil
        logger.info("[Comparison] Removed \(ticker)")
    }

    var canAddMore: Bool {
        stocks.count < Self.maxStocks
    }

    func isInComparison(_ ticker: String) -> Bool {
        stocks.contains { $0.ticker == ticker }
    }

    // MARK: - Data Loading

    func loadQuotes() async {
        isLoading = true
        errorMessage = nil

        await withTaskGroup(of: (String, MarketQuoteDTO?).self) { group in
            for stock in stocks where stock.quote == nil {
                group.addTask { [weak self] in
                    guard let self else { return (stock.ticker, nil) }
                    do {
                        let quote = try await self.marketDataService.fetchQuote(symbol: stock.ticker)
                        return (stock.ticker, quote)
                    } catch {
                        return (stock.ticker, nil)
                    }
                }
            }

            for await (ticker, quote) in group {
                if let index = stocks.firstIndex(where: { $0.ticker == ticker }) {
                    stocks[index].quote = quote
                }
            }
        }

        // If any stock has no quote, apply mock data
        for index in stocks.indices where stocks[index].quote == nil {
            stocks[index].quote = Self.mockQuote(for: stocks[index].ticker, name: stocks[index].companyName)
        }

        isLoading = false
    }

    private func loadQuoteForStock(ticker: String) async {
        do {
            let quote = try await marketDataService.fetchQuote(symbol: ticker)
            if let index = stocks.firstIndex(where: { $0.ticker == ticker }) {
                stocks[index].quote = quote
            }
        } catch {
            logger.warning("[Comparison] Failed to fetch quote for \(ticker), using mock")
            if let index = stocks.firstIndex(where: { $0.ticker == ticker }) {
                stocks[index].quote = Self.mockQuote(for: ticker, name: stocks[index].companyName)
            }
        }
    }

    func refreshAll() async {
        // Clear existing quotes to force re-fetch
        for index in stocks.indices {
            stocks[index].quote = nil
        }
        await loadQuotes()
    }

    // MARK: - Comparison Metrics

    var comparisonMetrics: [ComparisonMetric] {
        let quotes = stocks.compactMap(\.quote)
        guard !quotes.isEmpty else { return [] }

        return [
            buildMetric(name: "Price", values: quotes.map { $0.currentPrice }, format: .currency, higherIsBetter: true),
            buildMetric(name: "Change %", values: quotes.map { $0.changePercent }, format: .percent, higherIsBetter: true),
            buildMetric(name: "Market Cap", values: quotes.map { $0.marketCap }, format: .abbreviated, higherIsBetter: true),
            buildMetric(name: "P/E Ratio", values: quotes.map { $0.peRatio }, format: .decimal, higherIsBetter: false),
            buildMetric(name: "Volume", values: quotes.map { Double($0.volume ?? 0) }, format: .abbreviated, higherIsBetter: true),
            buildMetric(name: "Div. Yield", values: quotes.map { $0.dividendYield }, format: .percent, higherIsBetter: true),
            buildMetric(name: "Day High", values: quotes.map { $0.dayHigh }, format: .currency, higherIsBetter: true),
            buildMetric(name: "Day Low", values: quotes.map { $0.dayLow }, format: .currency, higherIsBetter: false),
        ]
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
                // Expected
            } catch {
                self.logger.warning("[Comparison] Search failed: \(error.localizedDescription)")
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

    // MARK: - Private: Metric Building

    private enum MetricFormat {
        case currency, percent, decimal, abbreviated
    }

    private func buildMetric(
        name: String,
        values: [Double?],
        format: MetricFormat,
        higherIsBetter: Bool
    ) -> ComparisonMetric {
        let formatted = values.map { value -> String in
            guard let value else { return "--" }
            switch format {
            case .currency:
                return "$\(value.formatted(.number.precision(.fractionLength(2))))"
            case .percent:
                let sign = value >= 0 ? "+" : ""
                return "\(sign)\(value.formatted(.number.precision(.fractionLength(2))))%"
            case .decimal:
                return value.formatted(.number.precision(.fractionLength(2)))
            case .abbreviated:
                return Self.abbreviatedNumber(value)
            }
        }

        // Find the best index
        let nonNilValues = values.enumerated().compactMap { index, val -> (Int, Double)? in
            guard let val else { return nil }
            return (index, val)
        }

        var bestIndex: Int?
        if nonNilValues.count > 1 {
            if higherIsBetter {
                bestIndex = nonNilValues.max(by: { $0.1 < $1.1 })?.0
            } else {
                bestIndex = nonNilValues.min(by: { $0.1 < $1.1 })?.0
            }
        }

        return ComparisonMetric(
            name: name,
            values: formatted,
            rawValues: values,
            bestIndex: bestIndex,
            higherIsBetter: higherIsBetter
        )
    }

    private static func abbreviatedNumber(_ value: Double) -> String {
        let absValue = abs(value)
        let sign = value < 0 ? "-" : ""

        switch absValue {
        case 1_000_000_000_000...:
            return "\(sign)\((absValue / 1_000_000_000_000).formatted(.number.precision(.fractionLength(1))))T"
        case 1_000_000_000...:
            return "\(sign)\((absValue / 1_000_000_000).formatted(.number.precision(.fractionLength(1))))B"
        case 1_000_000...:
            return "\(sign)\((absValue / 1_000_000).formatted(.number.precision(.fractionLength(1))))M"
        case 1_000...:
            return "\(sign)\((absValue / 1_000).formatted(.number.precision(.fractionLength(1))))K"
        default:
            return "\(sign)\(absValue.formatted(.number.precision(.fractionLength(0))))"
        }
    }

    // MARK: - Mock Data

    private static func mockQuote(for ticker: String, name: String) -> MarketQuoteDTO {
        let prices: [String: (Double, Double)] = [
            "AAPL": (178.52, 1.24),
            "TSLA": (245.30, -2.15),
            "MSFT": (378.90, 0.42),
            "GOOGL": (155.72, 1.85),
            "AMZN": (178.25, -0.18),
            "NVDA": (875.28, 3.56),
            "META": (502.30, 2.15),
            "NFLX": (628.40, 1.05),
        ]

        let (price, changePct) = prices[ticker] ?? (Double.random(in: 50...400), Double.random(in: -3...3))
        let changeDollar = price * changePct / 100.0

        return MarketQuoteDTO(
            ticker: ticker,
            companyName: name,
            currentPrice: price,
            previousClose: price - changeDollar,
            openPrice: price - Double.random(in: -2...2),
            dayHigh: price + Double.random(in: 1...5),
            dayLow: price - Double.random(in: 1...5),
            volume: Int.random(in: 5_000_000...80_000_000),
            marketCap: price * Double.random(in: 1_000_000_000...3_000_000_000),
            peRatio: Double.random(in: 10...45),
            dividendYield: Double.random(in: 0...2.5),
            changeDollar: changeDollar,
            changePercent: changePct,
            updatedAt: nil
        )
    }
}
