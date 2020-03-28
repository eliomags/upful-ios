//
//  CompanyNewsModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct CompanyNewsModel: Decodable {
    let title: String
    let publicationDate: String
    let url: String
    let summary: String
}

/*
 Stock Data for a specified ticker
 */
struct StockData: Decodable {
    var standardizedFinancials: [StandardizedFinancial]?
    var news: [CompanyNewsModel]?
}


// MARK: - INTRINIO SEARCH RESULTS MODEL

struct ScreeningResponse: Decodable {
    var data: [Stock]
    var resultCount: Int?
    var pageSize: Int?
}

final class Stock {
    var name: String
    let ticker: String
    var marketcap: Int?
    var divyield: Double?
    var pricetoearnings: Double?
    var ebitgrowth: Double?
    var stockQuote: StockQuote?
    
    init(name: String,ticker: String) {
        self.name = name
        self.ticker = ticker
    }
}

extension Stock: Decodable {}

extension Stock: Hashable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
    }
}

extension Stock {
    static let cache = NSCache<NSString,Stock>()
}









