//
//  CompanyInfo.swift
//  Jyanik
//
//  Codable API model for detailed company information.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct CompanyInfo: Codable {
    let symbol: String
    let name: String
    let description: String
    let sector: String
    let industry: String
    let exchange: String
    let website: String
    let marketCap: Double
    let peRatio: Double
    let eps: Double
    let dividendYield: Double
    let fiftyTwoWeekHigh: Double
    let fiftyTwoWeekLow: Double
}
