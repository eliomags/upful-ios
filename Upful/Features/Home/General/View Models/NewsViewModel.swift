//
//  NewsViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    // MARK: - Dependencies
    
    private let savedStockDataManager: SavedStockDataLoaderProtocol
    private let stockNewsLoader = StockNewsLoader()
    
    
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
        stockNewsLoader.get(router: .getBatchMarketNews) { (result) in
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
        stockNewsLoader.get(router: .getTickerBatchNews(tickers: stocks)) { (result) in
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
