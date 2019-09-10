//
//  CompanyNewsModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

// MARK: - INTRINIO SEARCH RESULTS MODEL
struct ScreeningResponse: Decodable {
    var data: [Stock]
    var resultCount: Int?
    var pageSize: Int?
}

class Stock: Decodable {
    let name: String?
    let ticker: String?
    let marketcap: Int?
    var divyield: Double?
    var pricetoearnings: Double?
    var ebitgrowth: Double?
    var standardizedFinancials: [StandardizedFinancial]?
    var news: [CompanyNewsModel]?
}

struct CompanyNewsModel: Decodable {
    let title: String
    let publicationDate: String
    let url: String
    let summary: String
}









