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
    
    private(set) var stockNews: [StockNews] = [] {
        didSet {
            sendUpdates?()
        }
    }

    var sendUpdates: (() -> ())?
    
    // MARK: - Initializer
    
    init(savedStockDataManager: SavedStockDataLoaderProtocol = SavedStockLoader()) {
        self.savedStockDataManager = savedStockDataManager
    }
    
    
    // MARK: -
    
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
        if savedStocks.isEmpty {
            stockNewsLoader.get(router: .getMarketNews) { (result) in
                switch result {
                case.success(let news):
                    print(news.map({ $0.title }))
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        if !savedStocks.isEmpty {
            let stocks = savedStocks.map({ $0.ticker }).joined(separator: ",")
            stockNewsLoader.get(router: .getTickerNews(tickers: stocks)) { (result) in
                switch result {
                case .success(let news):
                    self.stockNews = news
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}
