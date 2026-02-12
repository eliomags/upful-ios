//
//  ScreenerResultsView.swift
//  Jyanik
//
//  Displays results from a stock screener query
//

import SwiftUI

// MARK: - Screener Results View Model

@Observable
final class ScreenerResultsViewModel {

    // MARK: - State

    enum LoadState {
        case idle
        case loading
        case loaded
        case error(String)
    }

    private(set) var loadState: LoadState = .idle
    private(set) var results: [StockDisplayItem] = []

    // MARK: - Dependencies

    private let apiClient: APIClient

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Loading

    func loadResults(filters: ScreenerFilters) async {
        loadState = .loading

        do {
            let endpoint = MarketEndpoints.getScreenerResults(filters: filters)
            let quotes: [MarketQuoteDTO] = try await apiClient.request(endpoint)
            results = quotes.map { quote in
                StockDisplayItem(
                    ticker: quote.ticker,
                    companyName: quote.companyName,
                    price: quote.currentPrice,
                    changePercent: quote.changePercent,
                    sparkline: []
                )
            }
            loadState = .loaded
        } catch {
            // Fall back to mock data for development
            loadMockResults(filters: filters)
            loadState = .loaded
        }
    }

    // MARK: - Mock Data

    private func loadMockResults(filters: ScreenerFilters) {
        let mockStocks: [StockDisplayItem] = [
            StockDisplayItem(ticker: "AAPL", companyName: "Apple Inc.", price: 178.52, changePercent: 1.24, sparkline: []),
            StockDisplayItem(ticker: "MSFT", companyName: "Microsoft Corp.", price: 378.90, changePercent: 0.42, sparkline: []),
            StockDisplayItem(ticker: "GOOGL", companyName: "Alphabet Inc.", price: 155.72, changePercent: 1.85, sparkline: []),
            StockDisplayItem(ticker: "AMZN", companyName: "Amazon.com Inc.", price: 178.25, changePercent: -0.18, sparkline: []),
            StockDisplayItem(ticker: "NVDA", companyName: "NVIDIA Corporation", price: 875.28, changePercent: 3.56, sparkline: []),
            StockDisplayItem(ticker: "META", companyName: "Meta Platforms Inc.", price: 502.30, changePercent: 2.15, sparkline: []),
            StockDisplayItem(ticker: "TSLA", companyName: "Tesla, Inc.", price: 245.30, changePercent: -2.15, sparkline: []),
            StockDisplayItem(ticker: "AMD", companyName: "Advanced Micro Devices", price: 174.50, changePercent: 4.20, sparkline: []),
            StockDisplayItem(ticker: "CRM", companyName: "Salesforce Inc.", price: 298.45, changePercent: 1.05, sparkline: []),
            StockDisplayItem(ticker: "NFLX", companyName: "Netflix Inc.", price: 612.80, changePercent: -0.92, sparkline: []),
        ]

        // Apply basic client-side filtering for mock data
        var filtered = mockStocks

        if let minPrice = filters.priceMin {
            filtered = filtered.filter { $0.price >= minPrice }
        }
        if let maxPrice = filters.priceMax {
            filtered = filtered.filter { $0.price <= maxPrice }
        }

        let limit = filters.limit ?? 25
        results = Array(filtered.prefix(limit))
    }
}

// MARK: - Screener Results View

struct ScreenerResultsView: View {

    let filters: ScreenerFilters
    let title: String

    @State private var viewModel = ScreenerResultsViewModel()

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Scanning markets...")

            case .loaded:
                if viewModel.results.isEmpty {
                    JEmptyState(
                        icon: "magnifyingglass",
                        title: "No Results",
                        description: "No stocks match your screener criteria. Try adjusting your filters."
                    )
                } else {
                    resultsList
                }

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.loadResults(filters: filters) }
                }
            }
        }
        .background(JColor.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadResults(filters: filters)
        }
        .refreshable {
            await viewModel.loadResults(filters: filters)
        }
    }

    // MARK: - Results List

    private var resultsList: some View {
        ScrollView {
            VStack(spacing: JSpacing.sm) {
                resultsHeader

                LazyVStack(spacing: 0) {
                    ForEach(viewModel.results) { stock in
                        NavigationLink(value: Route.stockDetail(ticker: stock.ticker)) {
                            JStockRow(
                                ticker: stock.ticker,
                                companyName: stock.companyName,
                                price: stock.price,
                                changePercent: stock.changePercent
                            )
                        }
                        .buttonStyle(.plain)

                        if stock.id != viewModel.results.last?.id {
                            Divider()
                                .foregroundStyle(JColor.divider)
                        }
                    }
                }
                .padding(.horizontal, JSpacing.md)
                .padding(.vertical, JSpacing.xs)
                .background(JColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
    }

    private var resultsHeader: some View {
        HStack {
            Text("\(viewModel.results.count) results")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)

            Spacer()

            if let sortBy = filters.sortBy {
                JTextBadge(sortLabel(for: sortBy), color: JColor.primary)
            }
        }
    }

    private func sortLabel(for sortBy: String) -> String {
        switch sortBy {
        case "market_cap": return "Market Cap"
        case "price": return "Price"
        case "volume": return "Volume"
        case "change_percent": return "Change %"
        case "name": return "Name"
        default: return sortBy.capitalized
        }
    }
}

// MARK: - Previews

#Preview("Screener Results") {
    NavigationStack {
        ScreenerResultsView(
            filters: ScreenerFilters(sortBy: "market_cap", sortOrder: "desc", limit: 10),
            title: "Top Gainers"
        )
    }
}
