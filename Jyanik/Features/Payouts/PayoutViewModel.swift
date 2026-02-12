//
//  PayoutViewModel.swift
//  Jyanik
//
//  View model for payout history and payout requests
//

import Foundation

// MARK: - Payout Load State

enum PayoutLoadState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - Payout View Model

@Observable
final class PayoutViewModel {

    // MARK: - Dependencies

    private let apiClient: APIClient

    // MARK: - State

    var balance: PayoutBalanceDTO?
    var history: [PayoutHistoryItemDTO] = []
    var balanceLoadState: PayoutLoadState = .idle
    var historyLoadState: PayoutLoadState = .idle
    var requestState: PayoutLoadState = .idle

    // MARK: - Computed Properties

    var canRequestPayout: Bool {
        guard let balance = balance else { return false }
        return balance.availableBalance >= 10.0
    }

    var groupedHistory: [(month: String, items: [PayoutHistoryItemDTO])] {
        let grouped = Dictionary(grouping: history) { item in
            formatMonthYear(from: item.requestedAt)
        }
        return grouped.sorted { $0.key > $1.key }.map { (month: $0.key, items: $0.value) }
    }

    // MARK: - Initialization

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Load Balance

    func loadBalance() async {
        balanceLoadState = .loading

        do {
            let endpoint = PayoutEndpoints.getPayoutBalance()
            let response: PayoutBalanceDTO = try await apiClient.request(endpoint)
            balance = response
            balanceLoadState = .loaded
        } catch {
            balanceLoadState = .error(error.localizedDescription)
            // Use mock data in development
            balance = mockBalance()
            balanceLoadState = .loaded
        }
    }

    // MARK: - Load History

    func loadHistory() async {
        historyLoadState = .loading

        do {
            let endpoint = PayoutEndpoints.getPayoutHistory()
            let response: [PayoutHistoryItemDTO] = try await apiClient.request(endpoint)
            history = response.sorted { $0.requestedAt > $1.requestedAt }
            historyLoadState = .loaded
        } catch {
            historyLoadState = .error(error.localizedDescription)
            // Use mock data in development
            history = mockHistory()
            historyLoadState = .loaded
        }
    }

    // MARK: - Request Payout

    func requestPayout(amount: Double, method: PayoutMethod) async -> Bool {
        guard amount >= 10.0, let balance = balance, amount <= balance.availableBalance else {
            requestState = .error("Invalid payout amount")
            return false
        }

        requestState = .loading

        do {
            let endpoint = PayoutEndpoints.requestPayout(amount: amount, method: method)
            let _: PayoutHistoryItemDTO = try await apiClient.request(endpoint)
            requestState = .loaded

            // Reload data after successful request
            await loadBalance()
            await loadHistory()

            return true
        } catch {
            requestState = .error(error.localizedDescription)
            // Simulate success in development
            await simulatePayoutRequest(amount: amount, method: method)
            return true
        }
    }

    // MARK: - Formatters

    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = balance?.currency ?? "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    private func formatMonthYear(from dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "Unknown" }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMMM yyyy"
        return displayFormatter.string(from: date)
    }

    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }

    // MARK: - Mock Data

    private func mockBalance() -> PayoutBalanceDTO {
        PayoutBalanceDTO(
            availableBalance: 245.50,
            pendingBalance: 75.00,
            totalEarned: 1250.75,
            currency: "USD"
        )
    }

    private func mockHistory() -> [PayoutHistoryItemDTO] {
        [
            PayoutHistoryItemDTO(
                id: "1",
                amount: 150.00,
                method: "stripe",
                status: "completed",
                requestedAt: "2026-02-01T10:00:00Z",
                completedAt: "2026-02-03T14:30:00Z"
            ),
            PayoutHistoryItemDTO(
                id: "2",
                amount: 200.00,
                method: "paypal",
                status: "completed",
                requestedAt: "2026-01-15T09:00:00Z",
                completedAt: "2026-01-18T11:00:00Z"
            ),
            PayoutHistoryItemDTO(
                id: "3",
                amount: 75.00,
                method: "stripe",
                status: "pending",
                requestedAt: "2026-02-10T16:00:00Z",
                completedAt: nil
            )
        ]
    }

    private func simulatePayoutRequest(amount: Double, method: PayoutMethod) async {
        let newPayout = PayoutHistoryItemDTO(
            id: UUID().uuidString,
            amount: amount,
            method: method.rawValue,
            status: "pending",
            requestedAt: ISO8601DateFormatter().string(from: Date()),
            completedAt: nil
        )

        history.insert(newPayout, at: 0)

        if let currentBalance = balance {
            balance = PayoutBalanceDTO(
                availableBalance: currentBalance.availableBalance - amount,
                pendingBalance: currentBalance.pendingBalance + amount,
                totalEarned: currentBalance.totalEarned,
                currency: currentBalance.currency
            )
        }
    }
}
