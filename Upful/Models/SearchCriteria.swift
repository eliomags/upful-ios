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
    case .none, .industrycategory, .name:
      fatalError("Shouldn't be able to get a definition of \(self.rawValue)")
    case .marketcap:
      return "Total number of outstanding shares x Current share price. For example, a company with 20 million shares selling at $50 a share would have a market cap of $1 billion."
    case .totalrevenue:
      return "Total value sales of goods and services. It is the top line or gross income figure from which costs are subtracted to determine net income."
    case .netincome:
      return "The amount of revenue left after subtracting all expenses, taxes and costs."
    case .totalassets:
      return "Resources of economic value that can "
    case .pricetoearnings:
      return "Expressed as Price per share/Earnings per share (TTM).\nThis can also be looked at as a payback period.\nExample a p/e of 15 would mean a payback period of 15 years.\nThis metric is often looked at with earnings growth and revenue growth.\nThis metric can also be compared to similar stocks and the market as a whole."
    case .evtoebit:
      return ""
//    case .pricetobook:
//      <#code#>
//    case .evtofcff:
//      <#code#>
//    case .debttoequity:
//      <#code#>
    case .ebitdagrowth:
      return "1 Year change Earnings Before Interest, Tax, Depreciation and Ammortization"
    case .ebitgrowth:
      return "1 Year change Earnings Before Interest and Tax"
    case .divpayoutratio:
      return "The percentage of a company's earnings paid out as dividends.\nExample a value 100% means all earnings are paid out as dividends."
    case .dividendyield:
      return "The amount of money paid over one year for owning a stock."
    case .revenuegrowth:
      return "1 Year Percent change in Revenue"
//    case .grossmargin:
//      <#code#>
//    case .ebitmargin:
//      <#code#>
//    case .investedcapitalgrowth:
//      <#code#>
    case .epsgrowth:
      return "1 Year Percent change in Earnings Per Share"
    case .fcffgrowth:
      return "1 Year Percent change in Free Cash Flow"
//    case .pricetorevenue:
//      <#code#>
    default:
      fatalError("Not a valid SearchCriteria")
    }
  }
  
  var equation: String? {
    
    switch self {
    case .marketcap:
      return "Number of shares outstanding * Share Price"
    case .pricetoearnings:
      return "Share Price / Earnings per share"
    case .evtoebit:
      return "Enterprise Value / Earning Before Interest and Tax"
    case .pricetobook:
      return "Share Price / Book Value Per Share"
    case .evtofcff:
      return "Enterprise Value / Free Cash Flow"
    case .debttoequity:
      return "Total Liabilites / Total Stockholder's Equity"
    case .divpayoutratio:
      return "Total Dividends / Net Income"
    case .dividendyield:
      return "Annual Dividend / Share Price"
    case .revenuegrowth:
      return "1 Year Percent change in revenue"
    case .grossmargin:
      return "(Revenue - Cost of Goods Sold) / Revenue"
    case .ebitmargin:
      return "Earnings Before Interest and Tax / Revenue"
    case .investedcapitalgrowth:
      return "1 Year Percent change in Invested Capital"
    case .pricetorevenue:
      return "Share Price / Revenue per share"
    default:
      return nil
    }
  }
}
