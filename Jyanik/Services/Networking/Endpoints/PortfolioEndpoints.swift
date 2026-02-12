//
//  PortfolioEndpoints.swift
//  Jyanik
//
//  Portfolio management API endpoints
//

import Foundation

enum PortfolioEndpoints {

    static func createPortfolio() -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios",
            method: .post
        )
    }

    static func getActivePortfolio() -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/active",
            method: .get
        )
    }

    static func getPortfolio(id: String) -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/\(id)",
            method: .get
        )
    }

    static func getPositions(portfolioId: String) -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/\(portfolioId)/positions",
            method: .get
        )
    }

    static func getTransactions(
        portfolioId: String,
        page: Int = 1,
        limit: Int = 20
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/\(portfolioId)/transactions",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }

    static func getPerformance(
        portfolioId: String,
        range: PerformanceRange = .oneWeek
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/\(portfolioId)/performance",
            method: .get,
            queryItems: [
                URLQueryItem(name: "range", value: range.rawValue)
            ]
        )
    }
}

// MARK: - Performance Range

enum PerformanceRange: String {
    case oneDay = "1d"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case threeMonths = "3m"
    case sixMonths = "6m"
    case oneYear = "1y"
    case all = "all"
}
