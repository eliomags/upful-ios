//
//  StockPreviewDataFetch.swift
//  Upful
//
//  Created by Yanik Simpson on 12/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class StockPreviewDataFetch: Operation {

    private let stock: Stock
    
    enum State: String {
        case isReady, isExecuting, isFinished
    }
    
    private(set) var state: State = .isReady {
        didSet {
            willChangeValue(forKey: state.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    override var isExecuting: Bool {
        return state == .isExecuting
    }
    override var isFinished: Bool {
        return state == .isFinished
    }
    
    var peDataCompleted = false {
        didSet {
            if peDataCompleted && marketcapCompleted {
                state = .isFinished
            }
        }
    }
    var marketcapCompleted = false {
       didSet {
           if peDataCompleted && marketcapCompleted {
               state = .isFinished
           }
       }
   }
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    // MARK: - Operation Methods
    
    override func main() {
        if isCancelled { return }
    }
    
    override func start() {
        state = .isExecuting
        checkCache { (shouldMakeHTTPRequest) in
            if shouldMakeHTTPRequest {
                /// instantiated only for the first time this function is called, subsequent calls to this function will pull data from cache
                stockToCache = Stock(name: stock.name, ticker: stock.ticker)
                
                if isCancelled { return }
                getPriceToEarningsPreviewData()
                if isCancelled { return }
                getMarketCapPreviewData()
            }
        }
    }
    
    // MARK: - Caching
    
    private var stockToCache: Stock? {
        didSet {
            /// stores cache for first checkCache function call
            Stock.cache.setObject(self.stockToCache!, forKey: self.stock.ticker as NSString)
        }
    }
    
    private func checkCache(completion: ((Bool) -> Void)) {
        if let cachedStock = Stock.cache.object(forKey: stock.ticker as NSString) {
            stock.pricetoearnings = cachedStock.pricetoearnings
            stock.marketcap = cachedStock.marketcap
            state = .isFinished
        } else {
            completion(true)
        }
    }
    
    // MARK: - Data Fetching
    
    private func getPriceToEarningsPreviewData() {
        NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: stock.ticker, financial: .pricetoearnings, frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                guard !companyHistorics.isEmpty else { return }
                self.stock.pricetoearnings = companyHistorics.first?.value
                self.stockToCache?.pricetoearnings = companyHistorics.first?.value
            case .failure(_): break
            }
            self.peDataCompleted = true
        })
    }
        
    private func getMarketCapPreviewData() {
        NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: stock.ticker, financial: .marketcap, frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                guard !companyHistorics.isEmpty else { return }
                self.stock.marketcap = Int(companyHistorics.first?.value ?? 0)
                self.stockToCache?.marketcap = Int(companyHistorics.first?.value ?? 0)
            case .failure(_): break
            }
            self.marketcapCompleted = true
        })
    }
    
}
