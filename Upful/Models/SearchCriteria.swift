//
//  IntrinioModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/18/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

enum SearchCriteria: String, CaseIterable {
    case none
    case industrycategory = "industry_category"
    case name
    case marketcap
    case totalrevenue
    case netincome
    case totalassets
    case totalliabilities
    case totalequity
    
    // Value
    case pricetoearnings
    case evtoebit
    case pricetobook
    case evtofcff
    case debttoequity
    case ebitdagrowth
    case ebitgrowth
    
    // Dividend
    case divpayoutratio
    case dividendyield
    
    // Growth
    case revenuegrowth
    case grossmargin
    case ebitmargin
    case investedcapitalgrowth
    case epsgrowth
    case fcffgrowth
    case pricetorevenue
    case revenueqoqgrowth
}

enum SearchParameter: String, Equatable, CaseIterable {
    case lt = "~lt"
    case gt = "~gt"
    case none
    case contains = "~contains"
    
    var explicit: String {
        switch self {
        case .lt: return "<"
        case .gt: return ">"
        case .none: return "Add Parameter"
        case .contains: return "="
        }
    }
}

extension SearchCriteria {
  var definition: String {
    
    switch self {
    case .none, .industrycategory, .name, .totalliabilities,
         .totalequity, .totalassets, .netincome, .totalrevenue:
      fatalError("Shouldn't be able to get a definition of \(rawValue)")
        
    case .marketcap:
      return "For example, a company with 20 million shares selling at $50 a share would have a market cap of $1 billion."
    case .pricetoearnings:
      return "For example, a p/e of 15 would mean a payback period of 15 years. This metric is often looked at with earnings growth and revenue growth."
    case .evtoebit:
      return "Metric used for valuing a company. Where EV is how much money to buy the whole company."
    case .pricetobook:
        return ""
    case .evtofcff:
        return ""
    case .pricetorevenue:
        return "Price/Sales compares a company's market capitalization to its revenue. This ratio is especially useful for companies that are not yet profitable."
        
    case .debttoequity:
        return ""
    case .divpayoutratio:
      return "The percentage of a company's earnings paid out as dividends. Example a value 100% means all earnings are paid out as dividends."
    case .dividendyield:
      return "The amount of money paid over one year for owning a stock."
    case .grossmargin:
        return "Percentage of revenue remaining after Cost of Goods Sold."
    case .ebitmargin:
        return ""
    case .investedcapitalgrowth:
        return ""
      
    case .ebitdagrowth:
        return "1 Year change Earnings Before Interest, Tax, Depreciation and Ammortization."
    case .ebitgrowth:
        return "1 Year change Earnings Before Interest and Tax."
    case .revenuegrowth:
        return "1 Year Percent change in Revenue."
    case .epsgrowth:
        return "1 Year Percent change in Earnings Per Share."
    case .fcffgrowth:
        return "1 Year Percent change in Free Cash Flow."
    case .revenueqoqgrowth:
        return ""
    }
  }
  
  var equation: String? {
    
    switch self {
    case .marketcap:
      return "Number of shares outstanding * Share Price"
    case .pricetoearnings:
      return "Share Price / Earnings per share"
    case .evtoebit:
      return "Enterprise Value(EV) = Market Cap + Total Debt - Cash\n\nEnterprise Value / Operating Income"
    case .pricetobook:
      return "Share Price / Book Value Per Share"
    case .evtofcff:
      return "Enterprise Value / Free Cash Flow"
    case .pricetorevenue:
        return "Share Price / Revenue per share"
        
    case .debttoequity:
      return "Total Liabilites / Total Stockholder's Equity"
    case .divpayoutratio:
      return "Total Dividends Paid Out / Net Income"
    case .dividendyield:
      return "Annual Dividend / Share Price"
    case .grossmargin:
      return "((Revenue - Cost of Goods Sold) / Revenue) * 100"
    case .ebitmargin:
      return "Earnings Before Interest and Tax / Revenue"
    case .investedcapitalgrowth:
      return "1 Year Percent change in Invested Capital"
            
    case .ebitdagrowth:
        return "(EBITDA (Last Year) / EBITDA (2 Years ago)) * 100"
    case .ebitgrowth:
        return "(EBIT (Last Year) / EBIT (2 Years ago)) * 100"
    case .revenuegrowth:
        return "(Revenue (Last Year) / Revenue (2 Years ago)) * 100"
    case .epsgrowth:
        return "(EPS (Last Year) / EPS (2 Years ago)) * 100"
    case .fcffgrowth:
        return "(Free Cash Flow (Last Year) / Free Cash Flow (2 Years ago)) * 100"
    case .revenueqoqgrowth:
        return ""
    default:
      return nil
    }
  }
}
