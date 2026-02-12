//
//  TradingService.swift
//  Jyanik
//
//  Handles trade execution and client-side validation
//

import Foundation
import Observation
import OSLog

@Observable
final class TradingService {

    // MARK: - State

    private(set) var isExecuting = false

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "TradingService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Execute Trade

    /// Sends a trade to the backend and returns the resulting transaction.
    @discardableResult
    func executeTrade(
        portfolioId: String,
        ticker: String,
        side: TradeSide,
        quantity: Double,
        price: Double
    ) async throws -> TransactionDTO {
        isExecuting = true
        defer { isExecuting = false }

        let endpoint = TradeEndpoints.executeTrade(
            portfolioId: portfolioId,
            ticker: ticker,
            side: side,
            quantity: quantity,
            price: price
        )
        let response: TradeResponseDTO = try await apiClient.request(endpoint)

        logger.info("[Trade] Executed \(side.rawValue) \(quantity) \(ticker) @ $\(price)")
        return response.trade
    }

    // MARK: - Client-Side Validation

    /// Validates a trade before submission. Returns `.success` if valid, or a typed error.
    func validateTrade(
        side: TradeSide,
        quantity: Double,
        price: Double,
        cashBalance: Double,
        currentPosition: PositionDTO? = nil
    ) -> Result<Void, TradeValidationError> {

        // Validate quantity
        guard quantity > 0 else {
            return .failure(.invalidQuantity)
        }

        // Validate price
        guard price > 0 else {
            return .failure(.invalidPrice)
        }

        switch side {
        case .buy:
            let totalCost = quantity * price
            guard cashBalance >= totalCost else {
                return .failure(.insufficientFunds(required: totalCost, available: cashBalance))
            }

        case .sell:
            let availableShares = currentPosition?.quantity ?? 0
            guard availableShares >= quantity else {
                return .failure(.insufficientShares(required: quantity, available: availableShares))
            }
        }

        return .success(())
    }
}
