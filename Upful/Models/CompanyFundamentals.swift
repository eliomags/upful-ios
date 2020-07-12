//
//  IntrinioLookup.swift
//  Upful
//
//  Created by Yanik Simpson on 8/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct HistoricalDataSearch: Decodable {
    let historicalData: [CompanyHistoricalDatum]
}

// MARK: - HistoricalDatum
struct CompanyHistoricalDatum: Decodable {
    let date: String
    let value: Double
}


/// MARK: - CompanyFundamentals
struct CompanyFundamentals: Decodable {
    let standardizedFinancials: [StandardizedFinancial]
    let fundamental: Fundamental?
    
    enum CodingKeys: String, CodingKey {
        case standardizedFinancials = "standardized_financials"
        case fundamental
    }
}

// MARK: StandardizedFinancial which contains the value of the financial
struct StandardizedFinancial: Decodable {
    let dataTag: DataTag?
    let value: Double?
}

// MARK: DataTag - contains name of metric
struct DataTag: Decodable {
    let id, name, tag: String
}

struct Fundamental: Decodable {
    let id, statementCode: String
    let fiscalYear: Int
    let fiscalPeriod: String
    let startDate, endDate: String
    let company: Company
}

struct Companies: Decodable {
    let companies: [Company]
}

struct Company: Decodable {
    let id, ticker, name, lei: String?
    let cik: String?
}

