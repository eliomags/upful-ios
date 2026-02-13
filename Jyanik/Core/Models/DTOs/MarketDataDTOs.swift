//
//  MarketDataDTOs.swift
//  Jyanik
//
//  Network DTOs for market data endpoints
//  NOTE: No manual CodingKeys on Decodable structs — APIClient's decoder uses .convertFromSnakeCase
//

import Foundation

// MARK: - Search

struct SearchResultDTO: Decodable, Identifiable {
    let symbol: String
    let name: String
    let exchange: String?
    let type: String?
    let score: Double?

    var id: String { symbol }
}

struct SearchResponseDTO: Decodable {
    let results: [SearchResultDTO]
}

// MARK: - Quote

struct MarketQuoteDTO: Decodable {
    let ticker: String
    let companyName: String
    let currentPrice: Double
    let previousClose: Double?
    let openPrice: Double?
    let dayHigh: Double?
    let dayLow: Double?
    let volume: Int?
    let marketCap: Double?
    let peRatio: Double?
    let dividendYield: Double?
    let changeDollar: Double
    let changePercent: Double
    let updatedAt: String?
}

// MARK: - Chart

struct ChartDataPointDTO: Decodable, Identifiable {
    let timestamp: Double?
    let date: String?
    let open: Double?
    let high: Double?
    let low: Double?
    let close: Double
    let volume: Int?

    var id: String { date ?? "\(timestamp ?? 0)" }
}

struct ChartResponseDTO: Decodable {
    let symbol: String
    let range: String
    let data: [ChartDataPointDTO]
}

// MARK: - News

struct NewsArticleDTO: Decodable, Identifiable {
    let id: String?
    let title: String
    let summary: String?
    let url: String
    let source: String?
    let imageUrl: String?
    let publishedAt: String?

    var stableID: String { id ?? url }
}

struct NewsResponseDTO: Decodable {
    let news: [NewsArticleDTO]
}

// MARK: - Crypto

struct CryptoAssetDTO: Decodable, Identifiable {
    let symbol: String
    let name: String
    let price: Double
    let change: Double?
    let changePercent: Double?
    let marketCap: Double?
    let volume: Double?
    let rank: Int?

    var id: String { symbol }
}

struct CryptoResponseDTO: Decodable {
    let crypto: [CryptoAssetDTO]
}

// MARK: - Exchange

struct ExchangeDTO: Decodable, Identifiable {
    let code: String
    let name: String
    let country: String

    var id: String { code }
}

struct ExchangesResponseDTO: Decodable {
    let exchanges: [ExchangeDTO]
}
