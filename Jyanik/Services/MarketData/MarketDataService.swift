//
//  MarketDataService.swift
//  Jyanik
//
//  Manages market data: search, quotes, charts, news, crypto, and exchanges
//

import Foundation
import Observation
import OSLog

@Observable
final class MarketDataService {

    // MARK: - State

    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var isSearching = false
    private(set) var quote: MarketQuoteDTO?
    private(set) var chartData: [ChartDataPointDTO] = []

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "MarketDataService")

    /// Debounce task for search input.
    private var searchTask: Task<Void, Never>?

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Search

    /// Searches for stocks/assets matching the query. Automatically debounces rapid calls.
    @discardableResult
    func search(query: String) async throws -> [SearchResultDTO] {
        // Cancel any in-flight search
        searchTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return []
        }

        isSearching = true
        defer { isSearching = false }

        let endpoint = MarketEndpoints.search(query: trimmed)
        let response: SearchResponseDTO = try await apiClient.request(endpoint)

        searchResults = response.results
        logger.info("[Market] Search returned \(response.results.count) results for: \(trimmed)")
        return response.results
    }

    /// Debounced search for use with text field binding.
    func debouncedSearch(query: String, delay: Duration = .milliseconds(300)) {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            do {
                try await Task.sleep(for: delay)
                try await self?.search(query: query)
            } catch is CancellationError {
                // Expected when superseded by a new search
            } catch {
                self?.logger.warning("[Market] Debounced search failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Quote

    /// Fetches the latest quote for a symbol.
    @discardableResult
    func fetchQuote(symbol: String) async throws -> MarketQuoteDTO {
        let endpoint = MarketEndpoints.getQuote(symbol: symbol)
        let quoteDTO: MarketQuoteDTO = try await apiClient.request(endpoint)

        quote = quoteDTO
        logger.info("[Market] Fetched quote for \(symbol): $\(quoteDTO.currentPrice)")
        return quoteDTO
    }

    // MARK: - Chart

    /// Fetches chart data points for a symbol and range.
    @discardableResult
    func fetchChart(symbol: String, range: ChartRange = .oneDay) async throws -> [ChartDataPointDTO] {
        let endpoint = MarketEndpoints.getChart(symbol: symbol, range: range)
        let response: ChartResponseDTO = try await apiClient.request(endpoint)

        chartData = response.data
        logger.info("[Market] Fetched \(response.data.count) chart points for \(symbol) (\(range.rawValue))")
        return response.data
    }

    // MARK: - News

    /// Fetches news articles, optionally filtered by symbol.
    func fetchNews(symbol: String? = nil) async throws -> [NewsArticleDTO] {
        let endpoint = MarketEndpoints.getNews(symbol: symbol)
        let response: NewsResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Market] Fetched \(response.news.count) news articles")
        return response.news
    }

    // MARK: - Crypto

    /// Fetches top cryptocurrency assets.
    func fetchCrypto() async throws -> [CryptoAssetDTO] {
        let endpoint = MarketEndpoints.getCrypto()
        let response: CryptoResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Market] Fetched \(response.crypto.count) crypto assets")
        return response.crypto
    }

    // MARK: - Exchanges

    /// Fetches the list of supported exchanges.
    func fetchExchanges() async throws -> [ExchangeDTO] {
        let endpoint = MarketEndpoints.getExchanges()
        let response: ExchangesResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Market] Fetched \(response.exchanges.count) exchanges")
        return response.exchanges
    }

    // MARK: - Cleanup

    /// Clears local search state.
    func clearSearch() {
        searchTask?.cancel()
        searchResults = []
        isSearching = false
    }
}
