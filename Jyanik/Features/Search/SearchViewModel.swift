//
//  SearchViewModel.swift
//  Jyanik
//
//  View model for universal search: debounced queries, recent history, asset type filtering
//

import Foundation
import Observation
import OSLog

// MARK: - Search Asset Filter

enum SearchAssetFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case stocks = "Stocks"
    case crypto = "Crypto"
    case etfs = "ETFs"
    case bonds = "Bonds"
    case forex = "Forex"

    var id: String { rawValue }
}

// MARK: - Search View Model

@Observable
final class SearchViewModel {

    // MARK: - State

    var searchText = "" {
        didSet { handleSearchTextChange() }
    }

    var selectedSearchAssetFilter: SearchAssetFilter = .all {
        didSet { applyFilter() }
    }

    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var filteredResults: [SearchResultDTO] = []
    private(set) var isSearching = false

    var recentSearches: [String] {
        get {
            let stored = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
            return stored
        }
        set {
            UserDefaults.standard.set(newValue, forKey: recentSearchesKey)
        }
    }

    var hasSearchText: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Dependencies

    private let marketDataService: MarketDataService
    private let logger = Logger(subsystem: "com.jyanik", category: "SearchViewModel")
    private var searchTask: Task<Void, Never>?

    private let recentSearchesKey = "recentSearches"
    private let maxRecentSearches = 10

    // MARK: - Init

    init(marketDataService: MarketDataService = MarketDataService()) {
        self.marketDataService = marketDataService
    }

    // MARK: - Search

    func search() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            filteredResults = []
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
                    self.applyFilter()
                }
            } catch is CancellationError {
                // Expected when superseded by a new search
            } catch {
                self.logger.warning("[Search] Failed: \(error.localizedDescription)")
                if !Task.isCancelled {
                    self.searchResults = []
                    self.filteredResults = []
                }
            }

            if !Task.isCancelled {
                self.isSearching = false
            }
        }
    }

    // MARK: - Recent Searches

    func addToRecent(symbol: String) {
        var recent = recentSearches
        recent.removeAll { $0 == symbol }
        recent.insert(symbol, at: 0)
        if recent.count > maxRecentSearches {
            recent = Array(recent.prefix(maxRecentSearches))
        }
        recentSearches = recent
    }

    func clearRecent() {
        recentSearches = []
    }

    func selectRecent(_ symbol: String) {
        searchText = symbol
    }

    // MARK: - Filtering

    func applyFilter() {
        guard selectedSearchAssetFilter != .all else {
            filteredResults = searchResults
            return
        }

        filteredResults = searchResults.filter { result in
            guard let resultType = result.type?.lowercased() else { return true }
            switch selectedSearchAssetFilter {
            case .all:
                return true
            case .stocks:
                return resultType.contains("stock") || resultType.contains("equity")
            case .crypto:
                return resultType.contains("crypto") || resultType.contains("digital")
            case .etfs:
                return resultType.contains("etf") || resultType.contains("fund")
            case .bonds:
                return resultType.contains("bond") || resultType.contains("fixed")
            case .forex:
                return resultType.contains("forex") || resultType.contains("fx") || resultType.contains("currency")
            }
        }
    }

    // MARK: - Cleanup

    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        searchResults = []
        filteredResults = []
        isSearching = false
        selectedSearchAssetFilter = .all
    }

    // MARK: - Private

    private func handleSearchTextChange() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            searchTask?.cancel()
            searchResults = []
            filteredResults = []
            isSearching = false
        } else {
            search()
        }
    }
}
