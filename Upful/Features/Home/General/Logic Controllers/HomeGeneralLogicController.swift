//
//  HomeGeneralViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class HomeGeneralLogicController {
    
    // MARK: - Dependencies
    
    private let preferenceDataManager: PreferenceDataManager
    private let stockScreeningService = StockScreeningService()
    
    private let savedStockDataManager: LocalStockDataLoaderProtocol
    private let stockNewsLoader = NewsLoader()
    
    // MARK: - State
    
    enum PreferenceState {
        case new
        case loading
        case loaded
        case error
    }
    
    private(set) var stocksYouMayLike: [Stock] = []
    private(set) var preferenceState: PreferenceState = .loading {
        didSet {
            handlePreferenceStateChange()
        }
    }
    
    private(set) var stockNews: [StockNewsViewModel] = []

    var sendPreferenceStateUpdates: ((PreferenceState) -> Void)?
    var sendNewsStateUpdates: (() -> Void)?
    
    // MARK: - Initializer
    
    init(savedStockDataManager: LocalStockDataLoaderProtocol = LocalStockLoader(),
         preferenceDataManager: PreferenceDataManager = .init()) {
        self.preferenceDataManager = preferenceDataManager
        self.savedStockDataManager = savedStockDataManager
    }
    
    // MARK: - Handle State Changes
    
    fileprivate func handlePreferenceStateChange() {
        switch preferenceState {
        case .loaded:
            sendPreferenceStateUpdates?(preferenceState)
        default:
            break
        }
    }
    
    // MARK: - API Methods
    
    func fetchTableData() {
        startPreferenceLoad()
        startNewsLoad()
    }
    
    /*
     Gets a random combination of search parameters to perform search for Show More
     */
    func getRandomPreferenceGroup() -> [String] {
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty { return [] }
        
        let randomElement = Int.random(in: 0...(groupedPreferences.count-1))
        return groupedPreferences[randomElement]
    }
    
    // MARK: - Stock Preference Loading
        
    let preferenceFetchGroup = DispatchGroup()
    
    func startPreferenceLoad() {
        preferenceState = .loading
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty {
            preferenceState = .new
            return
        }
        groupedPreferences.forEach { (preferenceArray) in
            let preferenceParameters = preferenceArray.joined(separator: ",")
            fetchSuggestedStocks(parameters: preferenceParameters)
        }
        preferenceFetchGroup.notify(queue: .main) {
            self.preferenceState = .loaded
        }
    }
    
    fileprivate func fetchSuggestedStocks(parameters: String) {
        preferenceFetchGroup.enter()
        
        stockScreeningService.get(router: .getScreeningResults(parameters: parameters, numberOfResults: 8), completion: {
            (result) in
            switch result {
            case .success(let fetchedStocks):
                self.handlePreferenceFetchSuccess(with: fetchedStocks)
            case .failure(_):
                self.preferenceState = .error
            }
            self.preferenceFetchGroup.leave()
        })
    }
    
    fileprivate func randomizeSuggestedStocks(stocks: [Stock]) -> [Stock] {
        var duplicateStocks = stocks
        
        duplicateStocks.removeDuplicates()
        if duplicateStocks.count > 3 { duplicateStocks = Array(duplicateStocks[0...2]) }
        return duplicateStocks
    }
    
    fileprivate func handlePreferenceFetchSuccess(with fetchedStocks: [Stock]) {
        if self.preferenceState == .error { return }
        if fetchedStocks.isEmpty {
            self.fetchSuggestedStocks(parameters: "")
        } else {
            stocksYouMayLike = randomizeSuggestedStocks(stocks: fetchedStocks)
        }
    }
    
    // MARK: - News Loading
        
    func startNewsLoad() {
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                self.loadNews(savedStocks)
            case .failure(_):
                self.getGeneralMarketNews()
            }
        }
    }
        
    fileprivate func loadNews(_ savedStocks: [Stock]) {
        if !savedStocks.isEmpty { getNewsForTickers(savedStocks)  }
        if savedStocks.isEmpty { getGeneralMarketNews() }
    }
    
    fileprivate func getGeneralMarketNews() {
        stockNewsLoader.get(router: .getMarketNews) { (result) in
            switch result {
            case.success(let news):
                self.handleNewsFetchCompletion(news: news)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func getNewsForTickers(_ savedStocks: [Stock])  {
        let stocks = savedStocks.map({ $0.ticker }).joined(separator: ",")
        stockNewsLoader.get(router: .getTickerNews(tickers: stocks)) { (result) in
            switch result {
            case .success(let news):
                self.handleNewsFetchCompletion(news: news)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func handleNewsFetchCompletion(news: [StockNews]) {
        let mappedNews = news.map({ StockNewsViewModel(stockNews: $0 )})
        self.stockNews = mappedNews
        sendNewsStateUpdates?()
    }
}
