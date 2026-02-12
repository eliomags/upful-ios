//
//  TradeEndpoints.swift
//  Jyanik
//
//  Trade execution API endpoints
//

import Foundation

enum TradeEndpoints {

    static func executeTrade(
        portfolioId: String,
        ticker: String,
        side: TradeSide,
        quantity: Double,
        price: Double
    ) -> APIEndpoint {
        APIEndpoint(
            path: "/portfolios/\(portfolioId)/trades",
            method: .post,
            body: TradeBody(
                ticker: ticker,
                side: side,
                quantity: quantity,
                price: price
            )
        )
    }
}

// MARK: - Trade Side

enum TradeSide: String, Codable, Hashable {
    case buy
    case sell
}

// MARK: - Request Body

private struct TradeBody: Encodable {
    let ticker: String
    let side: TradeSide
    let quantity: Double
    let price: Double
}
