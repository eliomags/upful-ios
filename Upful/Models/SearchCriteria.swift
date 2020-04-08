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
    case bookvaluepershare
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
