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





struct CompanyFundamentals: Decodable {
    let standardizedFinancials: [StandardizedFinancial]
    let fundamental: Fundamental
}

// MARK: - StandardizedFinancial
struct StandardizedFinancial: Decodable {
    let dataTag: DataTag
    let value: Double
}

// MARK: - DataTag - contains name of metric
struct DataTag: Decodable {
    let id, name, tag: String
}

// MARK: - Fundamental
struct Fundamental: Decodable {
    let id, statementCode: String
    let fiscalYear: Int
    let fiscalPeriod: String
    let startDate, endDate: String
    let company: Company
}

// MARK: - Company
struct Company: Codable {
    let id, ticker, name, lei: String
    let cik: String
}

