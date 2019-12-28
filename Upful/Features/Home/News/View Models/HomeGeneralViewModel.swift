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
    
    let savedStockDataManager: SavedStockDataLoaderProtocol
    
    let stockNewsLoader = StockNewsLoader()
    
    // MARK: - State
    
    private(set) var stockNews: [StockNewsViewModel] = [] {
        didSet {
            sendUpdates?()
        }
    }

    var sendUpdates: (() -> ())?
    
    // MARK: - Initializer
    
    init(savedStockDataManager: SavedStockDataLoaderProtocol = SavedStockLoader()) {
        self.savedStockDataManager = savedStockDataManager
    }
    
    
    // MARK: - Functions
    
    // TODO: - Cache View Models
    // TODO: - Check if view models are in the cache before performing the networking
    
    func loadSavedStocks() {
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                self.loadNews(savedStocks)
            case .failure(_):
                break
            }
        }
    }
        
    fileprivate func loadNews(_ savedStocks: [Stock]) {
        if savedStocks.isEmpty { getNewsForTickers() }
        if !savedStocks.isEmpty { getGeneralMarketNews(savedStocks) }
    }
    
    fileprivate func getNewsForTickers() {
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
    
    fileprivate func getGeneralMarketNews(_ savedStocks: [Stock])  {
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
