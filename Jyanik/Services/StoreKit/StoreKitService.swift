//
//  StoreKitService.swift
//  Jyanik
//
//  Manages in-app purchases and subscriptions using StoreKit 2
//

import Foundation
import Observation
import StoreKit
import OSLog

@Observable
final class StoreKitService {

    // MARK: - Product IDs

    enum ProductID {
        static let premiumMonthly = "com.jyanik.premium.monthly"
        static let premiumYearly = "com.jyanik.premium.yearly"
        static let cashSmall = "com.jyanik.cash.small"
        static let cashLarge = "com.jyanik.cash.large"

        static let subscriptions: Set<String> = [premiumMonthly, premiumYearly]
        static let consumables: Set<String> = [cashSmall, cashLarge]
        static let all: Set<String> = subscriptions.union(consumables)
    }

    // MARK: - State

    private(set) var products: [Product] = []
    private(set) var purchasedSubscriptions: [Product] = []
    private(set) var isPremium = false
    private(set) var isLoading = false

    // MARK: - Private

    private let logger = Logger(subsystem: "com.jyanik", category: "StoreKit")
    private var transactionListener: Task<Void, Error>?

    // MARK: - Init / Deinit

    init() {
        transactionListener = listenForTransactionUpdates()
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    /// Fetches available products from the App Store.
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let storeProducts = try await Product.products(for: ProductID.all)

            // Sort: subscriptions first (monthly, yearly), then consumables
            products = storeProducts.sorted { lhs, rhs in
                let order: [String: Int] = [
                    ProductID.premiumMonthly: 0,
                    ProductID.premiumYearly: 1,
                    ProductID.cashSmall: 2,
                    ProductID.cashLarge: 3
                ]
                return (order[lhs.id] ?? 99) < (order[rhs.id] ?? 99)
            }

            logger.info("[StoreKit] Loaded \(storeProducts.count) products")
        } catch {
            logger.error("[StoreKit] Failed to load products: \(error.localizedDescription)")
        }
    }

    // MARK: - Purchase

    /// Initiates a purchase for the given product.
    @discardableResult
    func purchase(_ product: Product) async throws -> StoreKit.Transaction {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await checkSubscriptionStatus()

            logger.info("[StoreKit] Purchase successful: \(product.id)")
            return transaction

        case .userCancelled:
            throw StoreKitError.userCancelled

        case .pending:
            throw StoreKitError.pending

        @unknown default:
            throw StoreKitError.unknown
        }
    }

    // MARK: - Subscription Status

    /// Checks the current subscription status from verified transactions.
    func checkSubscriptionStatus() async {
        var activeSubscriptions: [Product] = []

        for await result in StoreKit.Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }

            if ProductID.subscriptions.contains(transaction.productID) {
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    activeSubscriptions.append(product)
                }
            }
        }

        purchasedSubscriptions = activeSubscriptions
        isPremium = !activeSubscriptions.isEmpty

        logger.info("[StoreKit] Premium status: \(self.isPremium)")
    }

    // MARK: - Restore Purchases

    /// Restores previous purchases by syncing with the App Store.
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
            logger.info("[StoreKit] Purchases restored")
        } catch {
            logger.error("[StoreKit] Restore failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Transaction Listener

    /// Listens for transaction updates in the background.
    /// This catches transactions that complete outside the app (e.g., Ask to Buy).
    func listenForTransactionUpdates() -> Task<Void, Error> {
        Task.detached(priority: .background) { [weak self] in
            for await result in StoreKit.Transaction.updates {
                guard let self else { return }

                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                    await self.checkSubscriptionStatus()
                    self.logger.info("[StoreKit] Transaction update processed: \(transaction.productID)")
                } catch {
                    self.logger.error("[StoreKit] Transaction update failed: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Helpers

    /// Subscription products only.
    var subscriptionProducts: [Product] {
        products.filter { ProductID.subscriptions.contains($0.id) }
    }

    /// Consumable products only.
    var consumableProducts: [Product] {
        products.filter { ProductID.consumables.contains($0.id) }
    }

    // MARK: - Verification

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            logger.error("[StoreKit] Verification failed: \(error.localizedDescription)")
            throw StoreKitError.verificationFailed
        case .verified(let item):
            return item
        }
    }
}

// MARK: - StoreKit Errors

enum StoreKitError: Error, LocalizedError {
    case userCancelled
    case pending
    case verificationFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .userCancelled:
            return "Purchase was cancelled."
        case .pending:
            return "Purchase is pending approval."
        case .verificationFailed:
            return "Transaction verification failed."
        case .unknown:
            return "An unknown StoreKit error occurred."
        }
    }
}
