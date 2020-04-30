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
//    case .totalassets:
//      <#code#>
//    case .totalliabilities:
//      <#code#>
//    case .totalequity:
//      <#code#>
//    case .pricetoearnings:
//      <#code#>
//    case .evtoebit:
//      <#code#>
//    case .pricetobook:
//      <#code#>
//    case .evtofcff:
//      <#code#>
//    case .debttoequity:
//      <#code#>
//    case .ebitdagrowth:
//      <#code#>
//    case .ebitgrowth:
//      <#code#>
//    case .divpayoutratio:
//      <#code#>
//    case .dividendyield:
//      <#code#>
//    case .revenuegrowth:
//      <#code#>
//    case .grossmargin:
//      <#code#>
//    case .ebitmargin:
//      <#code#>
//    case .investedcapitalgrowth:
//      <#code#>
//    case .epsgrowth:
//      <#code#>
//    case .fcffgrowth:
//      <#code#>
//    case .pricetorevenue:
//      <#code#>
//    case .revenueqoqgrowth:
//      <#code#>
    default:
      fatalError("Not a valid SearchCriteria")
    }
  }
}
