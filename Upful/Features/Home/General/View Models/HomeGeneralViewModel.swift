//
//  HomeGeneralViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class HomeGeneralViewModel {
    
    // MARK: - Dependencies
    
    private let preferenceDataManager: PreferenceDataManager
    private let stockScreeningService = StockScreeningService()
    
    private let savedStockDataManager: SavedStockDataLoaderProtocol
    private let stockNewsLoader = StockNewsLoader()
    
    
    // MARK: - State
    
    private(set) var stocksYouMayLike: [Stock] = [] {
        didSet {
            sendUpdates?()
        }
    }
    private(set) var stockNews: [StockNewsViewModel] = [] {
        didSet {
            sendUpdates?()
        }
    }

    var sendUpdates: (() -> ())?
    
    
    // MARK: - Initializer
    
    init(savedStockDataManager: SavedStockDataLoaderProtocol = SavedStockLoader(),
         preferenceDataManager: PreferenceDataManager = .init()) {
        self.preferenceDataManager = preferenceDataManager
        self.savedStockDataManager = savedStockDataManager
    }
    
    
    // MARK: - Stock Preference Loading
    
    func startPreferenceLoad() {
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty { fetchSuggestedStocks(parameters: "") }
        
        guard !groupedPreferences.isEmpty else { return }
        
        groupedPreferences.forEach { (preferenceArray) in
            let preferenceParameters = preferenceArray.joined(separator: ",")
            print(preferenceParameters)
            fetchSuggestedStocks(parameters: preferenceParameters)
        }
    }

    fileprivate func fetchSuggestedStocks(parameters: String) {
        self.stockScreeningService.get(router: .getScreeningResults(parameters: parameters, numberOfResults: 8), completion: {
            (result) in
            switch result {
            case .success(let fetchedStocks):
                self.configureStockChoices(fetchedStocks)
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    fileprivate func configureStockChoices(_ stocks: [Stock]) {
        // randomize the stocks
        // get the top 4 results
        // add them to stocks you may like
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
                let mappedNews = news.map({ StockNewsViewModel(stockNews: $0 )})
                self.stockNews = mappedNews
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
                let mappedNews = news.map({ StockNewsViewModel(stockNews: $0 )})
                self.stockNews = mappedNews
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
