//
//  Preference.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct Preference {
    let description: String
    let criteria: SearchCriteria
    let parameter: SearchParameter
    let value: String
    let id: PreferenceType
}

enum PreferenceCategory: Int {
    case industry
    case growth
    case dividend
    case profitability
}

enum PreferenceType: String, CaseIterable {
    case industryAny = "0"
    case industryRetail = "Retail"
    case industryDrug = "Drug"
    case industryFinancialServices = "Financial Services"
    case industryBanking = "Banking"
    case industryRealEstate = "Real Estate"
    case insurance = "Insurance"
    case industryHealthServices = "Health Services"
    case computerSoftware = "Computer Software & Services"
    case computerHardware = "Computer Hardware"
    case electronics = "Electronics"
    case consumerNonDurable = "Consumer NonDurables"
    case wholesale = "Wholesale"
    case foodBeverage = "Food & Beverage"
    case manufacturing = "Manufacturing"
    case telecommunications = "Telecommunications"
    case energy = "Energy"
    case utilities = "Utilities"
    case media = "Media"
    case leisure = "Leisure"
    case automotive = "Automotive"
    case transportation = "Transportation"
    case defense = "Aerospace/Defense"
    
    case growthAny
    case growthHigh
    case growthMedium
    case growthLow
    case growthNegative
    
    case profitabilityAny
    case profitabilityHigh
    case profitabilityMedium
    case profitabilityLow
    case profitabilityNegative

    case dividendAny
    case dividendNone
    case dividendHigh
    case dividendMedium
    case dividendLow
}

extension PreferenceType {
    func category() -> PreferenceCategory {
        switch self {
        case .industryAny: return .industry
        case .industryRetail: return .industry
        case .industryDrug: return .industry
        case .industryFinancialServices: return .industry
        case .industryBanking: return .industry
        case .industryRealEstate: return .industry
        case .insurance: return .industry
        case .industryHealthServices: return .industry
        case .computerSoftware: return .industry
        case .computerHardware: return .industry
        case .electronics: return .industry
        case .consumerNonDurable: return .industry
        case .wholesale: return .industry
        case .foodBeverage: return .industry
        case .manufacturing: return .industry
        case .telecommunications: return .industry
        case .energy: return .industry
        case .utilities: return .industry
        case .media: return .industry
        case .leisure: return .industry
        case .automotive: return .industry
        case .transportation: return .industry
        case .defense: return .industry
        case .growthAny: return .growth
        case .growthHigh: return .growth
        case .growthMedium: return .growth
        case .growthLow: return .growth
        case .growthNegative: return .growth
        case .profitabilityAny: return .profitability
        case .profitabilityHigh: return .profitability
        case .profitabilityMedium: return .profitability
        case .profitabilityLow: return .profitability
        case .profitabilityNegative: return .profitability
        case .dividendAny: return .dividend
        case .dividendNone: return .dividend
        case .dividendHigh: return .dividend
        case .dividendMedium: return .dividend
        case .dividendLow: return .dividend
        }
    }
}


