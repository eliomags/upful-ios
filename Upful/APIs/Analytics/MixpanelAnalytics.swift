//
//  MixpanelAnalytics.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Mixpanel

protocol AnalyticsTracker {
    func log(event: AnalyticsEventName)
}

enum ScreenType: String {
    case quick
    case manual
}

enum AnalyticsEventName {
    case screenForStocks(screenType: ScreenType)
    case searchByName
    case selectedNewsArticle
    case selectedAnalysis(criteria: SearchCriteria)
    case selectedCompanyFiling
    case suggestion(description: String)
    case issue(description: String)
    
    func getName() -> String {
        switch self {
        case .screenForStocks:
            return "screen_for_stocks"
        case .searchByName:
            return "search_by_name"
        case .selectedNewsArticle:
            return "selected_news_article"
        case .selectedAnalysis:
            return "selected_analysis_parameter"
        case .selectedCompanyFiling:
            return "selected_company_filing"
        case .suggestion:
            return "suggestion"
        case .issue:
            return "issue"

        }
    }
}

extension AnalyticsEventName {
    var metaData: [String: String] {
        switch self {
        case .screenForStocks(let screenType):
            return ["screen_type": screenType.rawValue]
        case .searchByName:
            return [:]
        case .selectedNewsArticle:
            return [:]
        case .selectedAnalysis(let criteria):
            return ["analysis_criteria": criteria.rawValue]
        case .selectedCompanyFiling:
            return [:]
        case .suggestion(let description):
            return ["description": description]
        case .issue(let description):
            return ["description": description]

        }
    }
}

class MixPanelAnalytics: AnalyticsTracker {
   
    init() {}
    
    func log(event: AnalyticsEventName) {
        Mixpanel.mainInstance().track(event: event.getName(),
                                      properties: event.metaData)
    }
}











