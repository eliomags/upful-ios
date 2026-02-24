//
//  TradeViewModel.swift
//  Jyanik
//
//  View model for the trade execution screen.
//  Manages stock selection, order configuration, validation, and trade submission.
//

import Foundation
import Observation
import OSLog

// MARK: - Order Type

enum OrderType: String, CaseIterable, Identifiable {
    case market = "Market"
    case limit = "Limit"

    var id: String { rawValue }
}

// MARK: - Trade State

enum TradeState: Equatable {
    case idle
    case loading
    case validating
    case executing
    case success(TransactionDTO)
    case error(String)

    static func == (lhs: TradeState, rhs: TradeState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.validating, .validating),
             (.executing, .executing):
            return true
        case (.success(let a), .success(let b)):
            return a.id == b.id
        case (.error(let a), .error(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - Trade View Model

@Observable
final class TradeViewModel {

    // MARK: - Input State

    var selectedTicker: String = ""
    var searchQuery: String = ""
    var side: TradeSide = .buy
    var orderType: OrderType = .market
    var quantityText: String = ""
    var limitPriceText: String = ""

    // MARK: - Data State

    private(set) var quote: MarketQuoteDTO?
    private(set) var cashBalance: Double = 0
    private(set) var portfolioId: String?
    private(set) var positions: [PositionDTO] = []
    private(set) var searchResults: [SearchResultDTO] = []
    private(set) var tradeState: TradeState = .idle
    private(set) var isSearching = false
    private(set) var isLoadingQuote = false

    /// Whether to show the confirmation sheet after a successful trade.
    var showConfirmation = false

    /// The last completed transaction for the confirmation sheet.
    var completedTransaction: TransactionDTO?

    // MARK: - Dependencies

    private let tradingService: TradingService
    private let portfolioService: PortfolioService
    private let marketDataService: MarketDataService
    private let logger = Logger(subsystem: "com.jyanik", category: "TradeViewModel")

    // MARK: - Init

    init(
        tradingService: TradingService = TradingService(),
        portfolioService: PortfolioService = PortfolioService(),
        marketDataService: MarketDataService = MarketDataService(),
        initialTicker: String? = nil,
        initialSide: TradeSide = .buy
    ) {
        self.tradingService = tradingService
        self.portfolioService = portfolioService
        self.marketDataService = marketDataService
        self.side = initialSide

        if let ticker = initialTicker, !ticker.isEmpty {
            self.selectedTicker = ticker
        }
    }

    // MARK: - Computed Properties

    var quantity: Double {
        Double(quantityText) ?? 0
    }

    var limitPrice: Double {
        Double(limitPriceText) ?? 0
    }

    /// The effective price for the order (market price or user-entered limit price).
    var effectivePrice: Double {
        switch orderType {
        case .market:
            return quote?.currentPrice ?? 0
        case .limit:
            return limitPrice > 0 ? limitPrice : (quote?.currentPrice ?? 0)
        }
    }

    /// Total cost/proceeds of the trade.
    var totalAmount: Double {
        quantity * effectivePrice
    }

    /// Cash remaining after a buy, or cash gained after a sell.
    var estimatedCashAfter: Double {
        switch side {
        case .buy:
            return cashBalance - totalAmount
        case .sell:
            return cashBalance + totalAmount
        }
    }

    /// The user's current position in the selected stock, if any.
    var currentPosition: PositionDTO? {
        positions.first { $0.ticker.uppercased() == selectedTicker.uppercased() }
    }

    /// Number of shares currently held for the selected stock.
    var sharesOwned: Double {
        currentPosition?.quantity ?? 0
    }

    /// Whether the user has a stock selected and a quote loaded.
    var hasStockSelected: Bool {
        !selectedTicker.isEmpty && quote != nil
    }

    /// Whether the trade form has valid inputs to attempt submission.
    var isFormValid: Bool {
        guard hasStockSelected else { return false }
        guard quantity > 0 else { return false }
        guard effectivePrice > 0 else { return false }

        if orderType == .limit && limitPrice <= 0 {
            return false
        }

        return true
    }

    /// Human-readable validation error, or nil if valid.
    var validationError: String? {
        guard hasStockSelected else { return nil }
        guard quantity > 0 else {
            return quantityText.isEmpty ? nil : "Enter a valid number of shares"
        }
        guard effectivePrice > 0 else {
            return "Price unavailable"
        }

        let result = tradingService.validateTrade(
            side: side,
            quantity: quantity,
            price: effectivePrice,
            cashBalance: cashBalance,
            currentPosition: currentPosition
        )

        switch result {
        case .success:
            return nil
        case .failure(let error):
            return error.localizedDescription
        }
    }

    /// Whether the Place Trade button should be enabled.
    var canPlaceTrade: Bool {
        isFormValid && validationError == nil && tradeState != .executing
    }

    /// Cash balance formatted for display.
    var formattedCashBalance: String {
        "$\(cashBalance.formatted(.number.precision(.fractionLength(2))))"
    }

    // MARK: - Actions

    /// Loads sample data for guest mode.
    func loadGuestData() {
        cashBalance = 25_000.00
        portfolioId = "guest-portfolio"
        positions = []
        tradeState = .idle
    }

    /// Loads portfolio data (cash balance, positions, portfolio ID).
    func loadPortfolio() async {
        tradeState = .loading
        do {
            try await portfolioService.fetchActivePortfolio()

            if let portfolio = portfolioService.activePortfolio {
                cashBalance = portfolio.cashBalance
                portfolioId = portfolio.id
                positions = portfolioService.positions
            }

            tradeState = .idle

            // If we have a pre-selected ticker, fetch its quote
            if !selectedTicker.isEmpty {
                await fetchQuote(for: selectedTicker)
            }
        } catch {
            logger.warning("[Trade] Failed to load portfolio: \(error.localizedDescription)")
            tradeState = .error("Could not load your portfolio. Please try again.")
        }
    }

    /// Fetches a quote for the given ticker.
    func fetchQuote(for ticker: String) async {
        isLoadingQuote = true
        defer { isLoadingQuote = false }

        do {
            let fetchedQuote = try await marketDataService.fetchQuote(symbol: ticker.uppercased())
            quote = fetchedQuote
            selectedTicker = ticker.uppercased()

            // Pre-fill limit price with current market price
            if orderType == .limit && limitPriceText.isEmpty {
                limitPriceText = String(format: "%.2f", fetchedQuote.currentPrice)
            }

            logger.info("[Trade] Fetched quote for \(ticker): $\(fetchedQuote.currentPrice)")
        } catch {
            logger.warning("[Trade] Failed to fetch quote for \(ticker): \(error.localizedDescription)")
            quote = nil
        }
    }

    /// Searches for stocks matching the query.
    func searchStocks() async {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        defer { isSearching = false }

        do {
            let results = try await marketDataService.search(query: trimmed)
            searchResults = results
        } catch {
            logger.warning("[Trade] Search failed: \(error.localizedDescription)")
            searchResults = []
        }
    }

    /// Selects a stock from search results.
    func selectStock(_ result: SearchResultDTO) {
        selectedTicker = result.symbol.uppercased()
        searchQuery = ""
        searchResults = []

        Task {
            await fetchQuote(for: result.symbol)
        }
    }

    /// Clears the current stock selection.
    func clearSelection() {
        selectedTicker = ""
        quote = nil
        quantityText = ""
        limitPriceText = ""
        searchQuery = ""
        searchResults = []
    }

    /// Toggles between buy and sell.
    func toggleSide(_ newSide: TradeSide) {
        side = newSide
    }

    /// Sets the quantity to buy/sell all available (max shares for sell, max affordable for buy).
    func setMaxQuantity() {
        guard effectivePrice > 0 else { return }

        switch side {
        case .buy:
            let maxShares = floor(cashBalance / effectivePrice)
            quantityText = String(format: "%.0f", maxShares)
        case .sell:
            quantityText = String(format: "%.0f", sharesOwned)
        }
    }

    /// Validates and executes the trade.
    func placeTrade() async {
        guard canPlaceTrade else { return }
        guard let portfolioId else {
            tradeState = .error("No active portfolio found.")
            return
        }

        tradeState = .executing

        do {
            let transaction = try await tradingService.executeTrade(
                portfolioId: portfolioId,
                ticker: selectedTicker,
                side: side,
                quantity: quantity,
                price: effectivePrice
            )

            completedTransaction = transaction
            tradeState = .success(transaction)
            showConfirmation = true

            // Refresh portfolio data
            await portfolioService.refreshAfterTrade()
            if let portfolio = portfolioService.activePortfolio {
                cashBalance = portfolio.cashBalance
                positions = portfolioService.positions
            }

            logger.info("[Trade] Executed \(self.side.rawValue) \(self.quantity) \(self.selectedTicker)")
        } catch {
            logger.error("[Trade] Execution failed: \(error.localizedDescription)")
            tradeState = .error("Trade failed: \(error.localizedDescription)")
        }
    }

    /// Resets the form after a successful trade.
    func resetForm() {
        quantityText = ""
        limitPriceText = ""
        orderType = .market
        tradeState = .idle
        completedTransaction = nil
        showConfirmation = false
    }

    /// Dismisses any error state.
    func dismissError() {
        if case .error = tradeState {
            tradeState = .idle
        }
    }
}
