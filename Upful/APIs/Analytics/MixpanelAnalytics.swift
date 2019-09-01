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
    
    func getName() -> String {
        switch self {
        case .screenForStocks:
            return "screen_for_stocks"
        case .searchByName:
            return "search_by_name"
        case .selectedNewsArticle:
            return "selected_news_article"
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











