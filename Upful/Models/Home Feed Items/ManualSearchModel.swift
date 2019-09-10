//
//  ManualSearchItem.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct ParameterItem {
    let parameter: SearchParameter
    let value: Double
}

struct ManualScreenItem {
    let criteria: SearchCriteria
    var parameter: SearchParameter
    var value: Double?
}

enum ScreenerParameterType {
    case ratio, percentage, other, number
}

enum CriteriaClassification: Int {
    case valuation = 0
    case financial = 1
    case performance = 2
    case other
}

extension SearchCriteria {
    var explicit: String {
        switch self {
        case .name: return "Name"
        case .pricetoearnings: return "Price/Earnings"
        case .pricetobook: return "Price/Book"
        case .evtoebit: return "EV/EBIT"
        case .marketcap: return "Market Cap"
        case .divpayoutratio: return "Payout Ratio"
        case .dividendyield: return "Dividend Yield"
        case .revenuegrowth: return "Revenue Growth"
        case .grossmargin: return "Gross Margin"
        case .ebitmargin: return "EBIT Margin"
        case .fcffgrowth: return "FCF Growth"
        case .ebitdagrowth: return "EBITDA Growth"
        case .ebitgrowth: return "EBIT Growth"
        case .investedcapitalgrowth: return "Invested Capital"
        case .epsgrowth: return "EPS Growth"
        case .pricetorevenue: return "Price to Sales"
        case .revenueqoqgrowth: return "Sales Q/Q Growth"
        case .bookvaluepershare: return "Book Value/Share"
        case .evtofcff: return "EV/FCF"
        case .debttoequity: return "Debt/Equity"
        case .totalrevenue: return "Revenue"
        case .netincome: return "Net Income"
        case .totalassets: return "Total Assets"
        case .totalliabilities: return "Total Liabilities"
        case .totalequity: return "Total Equity"
        }
    }
    
    var parameterType: ScreenerParameterType {
        switch self {
        case .name: return .other
        case .marketcap: return .number
        case .pricetoearnings: return .ratio
        case .evtoebit: return .ratio
        case .pricetobook: return .ratio
        case .fcffgrowth: return .percentage
        case .ebitdagrowth: return .percentage
        case .ebitgrowth: return .percentage
        case .divpayoutratio: return .percentage
        case .dividendyield: return .percentage
        case .revenuegrowth: return .percentage
        case .grossmargin: return .percentage
        case .ebitmargin: return .percentage
        case .investedcapitalgrowth: return .percentage
        case .epsgrowth: return .percentage
        case .pricetorevenue: return .ratio
        case .revenueqoqgrowth: return .percentage
        case .bookvaluepershare: return .ratio
        case .evtofcff: return .ratio
        case .debttoequity: return .ratio
        case .totalrevenue: return .number
        case .netincome: return .number
        case .totalassets: return .number
        case .totalliabilities: return .number
        case .totalequity: return .number
        }
    }
    
    var classification: CriteriaClassification {
        switch self {
        case .name: return .other
        case .marketcap: return .valuation
        case .pricetoearnings: return .valuation
        case .evtoebit: return .valuation
        case .pricetobook: return .valuation
        case .fcffgrowth: return .performance
        case .ebitdagrowth: return .performance
        case .ebitgrowth: return .performance
        case .divpayoutratio: return .financial
        case .dividendyield: return .financial
        case .revenuegrowth: return .performance
        case .grossmargin: return .financial
        case .ebitmargin: return .financial
        case .investedcapitalgrowth: return .financial
        case .epsgrowth: return .performance
        case .pricetorevenue: return .valuation
        case .revenueqoqgrowth: return .performance
        case .bookvaluepershare: return .valuation
        case .evtofcff: return .valuation
        case .debttoequity: return .financial
        case .totalrevenue: return .other
        case .netincome: return .other
        case .totalassets: return .other
        case .totalliabilities: return .other
        case .totalequity: return .other
        }
    }

}












