//
//  SearchResult.swift
//  Jyanik
//
//  Codable API model for a stock/asset search result.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct SearchResult: Codable, Identifiable {
    let ticker: String
    let name: String
    let type: String
    let exchange: String

    var id: String { ticker }
}
