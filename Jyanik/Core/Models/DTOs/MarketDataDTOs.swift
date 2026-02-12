//
//  MarketDataDTOs.swift
//  Jyanik
//
//  Network DTOs for market data endpoints
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

    enum CodingKeys: String, CodingKey {
        case symbol, name, exchange, type, score
    }
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

    enum CodingKeys: String, CodingKey {
        case ticker
        case companyName = "company_name"
        case currentPrice = "current_price"
        case previousClose = "previous_close"
        case openPrice = "open_price"
        case dayHigh = "day_high"
        case dayLow = "day_low"
        case volume
        case marketCap = "market_cap"
        case peRatio = "pe_ratio"
        case dividendYield = "dividend_yield"
        case changeDollar = "change_dollar"
        case changePercent = "change_percent"
        case updatedAt = "updated_at"
    }
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
    let imageURL: String?
    let publishedAt: String?

    var stableID: String { id ?? url }

    enum CodingKeys: String, CodingKey {
        case id, title, summary, url, source
        case imageURL = "image_url"
        case publishedAt = "published_at"
    }
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

    enum CodingKeys: String, CodingKey {
        case symbol, name, price, change
        case changePercent = "change_percent"
        case marketCap = "market_cap"
        case volume, rank
    }
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
