//
//  Transaction.swift
//  Jyanik
//
//  Codable API model for a trade transaction.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct Transaction: Codable, Identifiable {
    let id: String
    let portfolioId: String
    let ticker: String
    let companyName: String?
    let side: String
    let orderType: String
    let quantity: Double
    let price: Double
    let totalAmount: Double
    let executedAt: String

    // MARK: - Computed Properties

    var isBuy: Bool {
        side == "buy"
    }
}
