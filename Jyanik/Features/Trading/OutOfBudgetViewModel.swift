//
//  OutOfBudgetViewModel.swift
//  Jyanik
//
//  View model for the out-of-budget modal.
//  Manages balance display and virtual cash purchase flow.
//

import Foundation
import Observation
import OSLog

@Observable
final class OutOfBudgetViewModel {

    // MARK: - State

    private(set) var currentBalance: Double = 0
    private(set) var isPurchasing = false
    private(set) var purchaseComplete = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let portfolioService: PortfolioService
    private let logger = Logger(subsystem: "com.jyanik", category: "OutOfBudgetViewModel")

    // MARK: - Init

    init(portfolioService: PortfolioService = PortfolioService()) {
        self.portfolioService = portfolioService
    }

    // MARK: - Computed

    /// Formatted current balance for display.
    var formattedBalance: String {
        "$\(currentBalance.formatted(.number.precision(.fractionLength(2))))"
    }

    /// Whether the balance is critically low (below $1,000).
    var isCriticallyLow: Bool {
        currentBalance < 1_000
    }

    // MARK: - Actions

    /// Loads the user's current cash balance from the portfolio.
    func loadBalance() async {
        // Mock data for now; will be replaced with real portfolio fetch.
        currentBalance = 4_230.50
        logger.info("[OutOfBudget] Loaded balance: \(self.currentBalance)")
    }

    /// Initiates a virtual cash purchase via StoreKit.
    func purchaseVirtualCash() async {
        guard !isPurchasing else { return }

        isPurchasing = true
        errorMessage = nil

        do {
            // Simulated purchase delay; will wire to StoreKitService later.
            try await Task.sleep(for: .seconds(1.5))
            purchaseComplete = true
            logger.info("[OutOfBudget] Virtual cash purchase completed")
        } catch {
            logger.error("[OutOfBudget] Purchase failed: \(error.localizedDescription)")
            errorMessage = "Purchase failed. Please try again."
            isPurchasing = false
        }
    }

    /// Clears any displayed error.
    func dismissError() {
        errorMessage = nil
    }
}
