//
//  MarketEndpoints.swift
//  Jyanik
//
//  Market data API endpoints
//

import Foundation

enum MarketEndpoints {

    static func search(query: String) -> APIEndpoint {
        APIEndpoint(
            path: "/market/search",
            method: .get,
            queryItems: [
                URLQueryItem(name: "q", value: query)
            ]
        )
    }

    static func getQuote(symbol: String) -> APIEndpoint {
        APIEndpoint(
            path: "/market/quote/\(symbol)",
            method: .get
        )
    }

    static func getChart(symbol: String, range: ChartRange = .oneDay) -> APIEndpoint {
        APIEndpoint(
            path: "/market/chart/\(symbol)",
            method: .get,
            queryItems: [
                URLQueryItem(name: "range", value: range.rawValue)
            ]
        )
    }

    static func getNews(symbol: String? = nil) -> APIEndpoint {
        var queryItems: [URLQueryItem]? = nil
        if let symbol {
            queryItems = [URLQueryItem(name: "symbol", value: symbol)]
        }
        return APIEndpoint(
            path: "/market/news",
            method: .get,
            queryItems: queryItems
        )
    }

    static func getFundamentals(symbol: String) -> APIEndpoint {
        APIEndpoint(
            path: "/market/fundamentals/\(symbol)",
            method: .get
        )
    }

    static func getScreenerResults(filters: ScreenerFilters) -> APIEndpoint {
        APIEndpoint(
            path: "/market/screener",
            method: .post,
            body: filters
        )
    }

    static func getExchanges() -> APIEndpoint {
        APIEndpoint(
            path: "/market/exchanges",
            method: .get
        )
    }

    static func getCrypto() -> APIEndpoint {
        APIEndpoint(
            path: "/market/crypto",
            method: .get
        )
    }
}

// MARK: - Chart Range

enum ChartRange: String {
    case oneDay = "1d"
    case fiveDays = "5d"
    case oneMonth = "1m"
    case threeMonths = "3m"
    case sixMonths = "6m"
    case oneYear = "1y"
    case fiveYears = "5y"
    case max = "max"
}

// MARK: - Screener Filters

struct ScreenerFilters: Encodable {
    var exchange: String?
    var sector: String?
    var marketCapMin: Double?
    var marketCapMax: Double?
    var priceMin: Double?
    var priceMax: Double?
    var sortBy: String?
    var sortOrder: String?
    var page: Int?
    var limit: Int?

    init(
        exchange: String? = nil,
        sector: String? = nil,
        marketCapMin: Double? = nil,
        marketCapMax: Double? = nil,
        priceMin: Double? = nil,
        priceMax: Double? = nil,
        sortBy: String? = nil,
        sortOrder: String? = nil,
        page: Int? = nil,
        limit: Int? = nil
    ) {
        self.exchange = exchange
        self.sector = sector
        self.marketCapMin = marketCapMin
        self.marketCapMax = marketCapMax
        self.priceMin = priceMin
        self.priceMax = priceMax
        self.sortBy = sortBy
        self.sortOrder = sortOrder
        self.page = page
        self.limit = limit
    }
}
