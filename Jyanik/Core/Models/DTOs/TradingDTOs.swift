//
//  TradingDTOs.swift
//  Jyanik
//
//  Network DTOs for trading endpoints
//  Note: TradeSide is defined in TradeEndpoints.swift
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
//

import Foundation

// MARK: - Asset Type

enum AssetType: String, Codable, Hashable {
    case stock
    case crypto
    case etf
    case bond
    case option
    case future
    case forex
}

// MARK: - Trade Request

struct TradeRequestBody: Encodable {
    let ticker: String
    let assetType: AssetType
    let side: TradeSide
    let quantity: Double

    enum CodingKeys: String, CodingKey {
        case ticker
        case assetType = "asset_type"
        case side, quantity
    }
}

// MARK: - Trade Response

struct TradeResponseDTO: Decodable {
    let trade: TransactionDTO
    let portfolioSummary: PortfolioSummaryDTO
}

struct PortfolioSummaryDTO: Decodable {
    let cashBalance: Double
    let totalEquity: Double
}

// MARK: - Trade Validation

enum TradeValidationError: Error, LocalizedError {
    case insufficientFunds(required: Double, available: Double)
    case insufficientShares(required: Double, available: Double)
    case invalidQuantity
    case invalidPrice
    case marketClosed

    var errorDescription: String? {
        switch self {
        case .insufficientFunds(let required, let available):
            return "Insufficient funds. Required: $\(String(format: "%.2f", required)), Available: $\(String(format: "%.2f", available))"
        case .insufficientShares(let required, let available):
            return "Insufficient shares. Trying to sell \(String(format: "%.2f", required)), but only \(String(format: "%.2f", available)) available"
        case .invalidQuantity:
            return "Quantity must be greater than zero"
        case .invalidPrice:
            return "Price must be greater than zero"
        case .marketClosed:
            return "Market is currently closed"
        }
    }
}
