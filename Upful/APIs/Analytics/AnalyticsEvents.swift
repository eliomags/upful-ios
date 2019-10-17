//
//  MixpanelAnalytics.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

// MARK: - Stock selection type

enum StockSelectionType: String {
    case preference
    case savedStock = "saved_stock"
    case popular
    case searchResult = "search_result"
    case nameSearch = "name_search"
}

// MARK: - Screening Types

enum ScreenType: String {
    case quick
    case manual
}

// MARK: - Analytics Events

enum AnalyticsEventName {
    case screenForStocks(screenType: ScreenType)
    case selectedNewsArticle
    case selectedAnalysis(criteria: SearchCriteria)
    case selectedStock(selectionType: StockSelectionType)
    case selectedCompanyFiling
    case preferencesSet
    case suggestion(description: String)
    case issue(description: String)
    case noteSaved(description: String)
    case savedTicker(ticker: String)
    
    func getName() -> String {
        switch self {
        case .screenForStocks:
            return "screen_for_stocks"
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
        case .preferencesSet:
            return "preference_set"
        case .selectedStock:
            return "selected_stock"
        case .noteSaved:
            return "saved_note"
        case .savedTicker:
            return "saved_ticker"
        }
    }
}

extension AnalyticsEventName {
    var metaData: [String: String] {
        switch self {
        case .screenForStocks(let screenType):
            return ["screen_type": screenType.rawValue]
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
        case .preferencesSet:
            return [:]
        case .selectedStock(let selectionType):
            return ["selection_type": selectionType.rawValue]
        case .noteSaved(let description):
            return ["note": description]
        case .savedTicker(let ticker):
            return ["ticker": ticker]
        }
    }
}











