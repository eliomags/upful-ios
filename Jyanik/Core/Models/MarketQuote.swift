//
//  MarketQuote.swift
//  Jyanik
//
//  Codable API model for a stock market quote.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct MarketQuote: Codable, Identifiable, Hashable {
    let ticker: String
    let companyName: String
    let assetType: String
    let currentPrice: Double
    let previousClose: Double
    let openPrice: Double
    let dayHigh: Double
    let dayLow: Double
    let volume: Int
    let marketCap: Double?
    let peRatio: Double?
    let dividendYield: Double?
    let changeDollar: Double
    let changePercent: Double
    let updatedAt: String

    var id: String { ticker }

    // MARK: - Computed Properties

    var isPositive: Bool {
        changeDollar >= 0
    }

    var formattedPrice: String {
        String(format: "$%.2f", currentPrice)
    }

    var formattedChange: String {
        let sign = changeDollar >= 0 ? "+" : ""
        return String(format: "%@$%.2f", sign, changeDollar)
    }

    var formattedChangePercent: String {
        let sign = changePercent >= 0 ? "+" : ""
        return String(format: "%@%.2f%%", sign, changePercent)
    }
}
