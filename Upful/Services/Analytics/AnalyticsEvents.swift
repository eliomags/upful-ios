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
    case saved = "currently_saved"
    case popular
}

// MARK: - Analytics Events

enum AnalyticsEventName {
    case performServerUpdate(lastUpdate: Date)
    case signUpForPremiumPresented(trigger: String)
    case signUpAttempt
    case selectedPremium
    case castedSuggestionVote
    case pushNotificationSelected
    case selectedNewsArticle
    case screenForStocks(screenType: ScreenType)
    case selectedAnalysis(criteria: SearchCriteria)
    case selectedCompareTicker(String)
    case selectedStock(selectionType: StockSelectionType)
    case selectedCompanyFiling
    case preferencesSet
    case suggestion(description: String)
    case issue(description: String)
    case noteSaved(description: String)
    case savedScreener(description: String)
    case savedTicker(ticker: String)
    case submitPromotorScore(score: Int)
    case performedTransaction(type: TransactionType)
    
    func getName() -> String {
        switch self {
        case .performServerUpdate:
            return "perform_server_update"
        case .screenForStocks:
            return "screen_for_stocks"
        case .selectedNewsArticle:
            return "selected_news_article"
        case .selectedAnalysis:
            return "selected_analysis_parameter"
        case .selectedCompareTicker(_):
            return "selected_compare_ticker"
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
        case .savedScreener:
            return "saved_screener"
        case .selectedPremium:
            return "premium_selected"
        case .castedSuggestionVote:
            return "suggestion_vote"
        case .pushNotificationSelected:
            return "selected_push_notification"
        case .signUpAttempt:
            return "sign_up_attempty"
        case .signUpForPremiumPresented(_):
            return "sign_up_presented"
        case .submitPromotorScore(_):
            return "net_promotor_score"
        case .performedTransaction(_):
            return "trade"
        }
    }
}

extension AnalyticsEventName {
    var metaData: [String: String] {
        switch self {
        case .performServerUpdate(let lastUpdate):
            return ["lastRefresh": "\(lastUpdate)"]
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
        case .savedScreener(let description):
            return ["screener": description]
        case .selectedPremium:
            return [:]
        case .castedSuggestionVote:
            return [:]
        case .pushNotificationSelected:
            return [:]
        case .signUpAttempt:
            return ["current_status": "\(PermissionManager.shared.isPremium)"]
        case .signUpForPremiumPresented(let trigger):
            return ["trigger_event": trigger]
        case .submitPromotorScore(let score):
            return ["score": "\(score)"]
        case .performedTransaction(let type):
            return ["type": "\(type.rawValue)"]
        case .selectedCompareTicker(let ticker):
            return ["ticker": ticker]
        }
    }
}











