//
//  SubscriptionViewModel.swift
//  Jyanik
//
//  View model for subscription management using StoreKit 2
//

import Foundation
import StoreKit

/// View model for subscription management
@Observable
final class SubscriptionViewModel {

    // MARK: - Dependencies

    private let storeKitService: StoreKitService

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case purchased
        case error(String)
    }

    private(set) var state: State = .idle
    private(set) var selectedProduct: Product?

    // MARK: - Computed Properties

    var subscriptionProducts: [Product] {
        storeKitService.subscriptionProducts
    }

    var isPremium: Bool {
        storeKitService.isPremium
    }

    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        return nil
    }

    // MARK: - Initialization

    init(storeKitService: StoreKitService = StoreKitService()) {
        self.storeKitService = storeKitService

        // Auto-select yearly subscription by default
        if let yearly = storeKitService.subscriptionProducts.first(where: {
            $0.id == StoreKitService.ProductID.premiumYearly
        }) {
            self.selectedProduct = yearly
        }
    }

    // MARK: - Public Methods

    /// Load available products from StoreKit
    func loadProducts() async {
        guard !storeKitService.isLoading else { return }

        state = .loading

        await storeKitService.loadProducts()

        // Auto-select yearly if not already selected
        if selectedProduct == nil,
           let yearly = subscriptionProducts.first(where: {
               $0.id == StoreKitService.ProductID.premiumYearly
           }) {
            selectedProduct = yearly
        }

        state = .idle
    }

    /// Select a subscription product
    func selectProduct(_ product: Product) {
        guard state != .loading else { return }
        selectedProduct = product
    }

    /// Purchase the selected subscription
    func purchase() async {
        guard let product = selectedProduct else {
            state = .error("Please select a subscription plan")
            return
        }

        guard state != .loading else { return }

        state = .loading

        do {
            _ = try await storeKitService.purchase(product)

            // Sync subscription status with backend
            await syncWithBackend()

            // Update subscription status
            await storeKitService.checkSubscriptionStatus()

            state = .purchased

            // Reset to idle after a delay to show success state
            try? await Task.sleep(for: .seconds(2))
            state = .idle

        } catch StoreKitError.userCancelled {
            state = .idle
        } catch {
            state = .error("Purchase failed: \(error.localizedDescription)")
        }
    }

    /// Restore previous purchases
    func restore() async {
        guard state != .loading else { return }

        state = .loading

        await storeKitService.restorePurchases()

        // Sync with backend
        await syncWithBackend()

        // Check if any subscriptions were restored
        if storeKitService.isPremium {
            state = .purchased

            // Reset to idle after showing success
            try? await Task.sleep(for: .seconds(2))
            state = .idle
        } else {
            state = .error("No purchases found to restore")
        }
    }

    /// Clear error state
    func clearError() {
        if case .error = state {
            state = .idle
        }
    }

    // MARK: - Private Methods

    /// Sync subscription status with backend
    private func syncWithBackend() async {
        do {
            let endpoint = UserEndpoints.updateSubscription(
                isPremium: storeKitService.isPremium
            )
            try await APIClient.shared.requestNoContent(endpoint)
        } catch {
            // Log error but don't fail the purchase flow
            print("Failed to sync subscription with backend: \(error)")
        }
    }
}
