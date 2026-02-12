//
//  WatchlistEndpoints.swift
//  Jyanik
//
//  Watchlist management API endpoints
//

import Foundation

enum WatchlistEndpoints {

    static func getWatchlist() -> APIEndpoint {
        APIEndpoint(
            path: "/watchlist",
            method: .get
        )
    }

    static func addToWatchlist(ticker: String) -> APIEndpoint {
        APIEndpoint(
            path: "/watchlist",
            method: .post,
            body: WatchlistItemBody(ticker: ticker)
        )
    }

    static func removeFromWatchlist(ticker: String) -> APIEndpoint {
        APIEndpoint(
            path: "/watchlist/\(ticker)",
            method: .delete
        )
    }

    static func reorderWatchlist(tickers: [String]) -> APIEndpoint {
        APIEndpoint(
            path: "/watchlist/reorder",
            method: .put,
            body: ReorderBody(tickers: tickers)
        )
    }
}

// MARK: - Request Bodies

private struct WatchlistItemBody: Encodable {
    let ticker: String
}

private struct ReorderBody: Encodable {
    let tickers: [String]
}
