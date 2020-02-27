//
//  StockOverviewViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 2/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class StockOverviewViewModel {

    // MARK: - Properties
    
    let ticker: String
    let companyName: String
    private(set) var stockQuote: StockQuote?
    private(set) var historicalRevenue = [CompanyHistoricalDatum]()
    private(set) var historicalEarnings = [CompanyHistoricalDatum]()
    private(set) var calcData = [StandardizedFinancial]()
    private(set) var stockNews = [StockNewsViewModel]()
    private(set) var stockDetail: StockDetail?
    private(set) var financialLookup: [SearchCriteria: Double] = [:]

    // MARK: - Dependencies
    
    let stockQuoteLoader: QuoteLoader
    let financialLoader: FinancialLoader
    let batchFinancialLoader: BatchFinancialLoader
    let stockNewsLoader: NewsLoaderProtocol
    let descriptionLoader: DescriptionLoader
    
    // MARK: - Configuration
     
    var loadingCompletionHandler: (() -> Void)?
    var errorHandler: (() -> Void)?

    // MARK: - Initializer
    
    init(ticker: String, companyName: String,
         priceLoader: QuoteLoader = StockPriceLoader(),
         financialLoader: FinancialLoader = StockFinancialLoader(),
         batchFinancialLoader: BatchFinancialLoader = StockBatchFinancialLoader(),
         stockNewsLoader: NewsLoaderProtocol = NewsLoader(),
         descriptionLoader: DescriptionLoader = StockDescriptionLoader()
    ) {
        self.ticker = ticker
        self.companyName = companyName
        self.stockQuoteLoader = priceLoader
        self.financialLoader = financialLoader
        self.batchFinancialLoader = batchFinancialLoader
        self.stockNewsLoader = stockNewsLoader
        self.descriptionLoader = descriptionLoader
    }
    
    // MARK: - Operations
    
    private let loadingOperations = DispatchGroup()
    
    // MARK: - API
    
    func loadData() {
        loadStockPrice()
        loadRevenueData()
        loadEarningsData()
        loadCalculationsData()
        loadAdditionalCalculationsData()
        loadNewsData()
        loadStockDescription()
        
        loadingOperations.notify(queue: .main) {
            self.loadingCompletionHandler?()
        }
    }
    
    fileprivate func loadStockPrice() {
        loadingOperations.enter()
        
        stockQuoteLoader.load(for: ticker) { (result) in
            switch result {
            case .success(let stockQuote):
                self.stockQuote = stockQuote
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }
        
    fileprivate func loadRevenueData() {
        loadingOperations.enter()
        
        financialLoader.getStockFinancials(ticker: ticker, financialFrequency: .fiveYear,
                                     financial: .totalrevenue) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let historicalRevenue):
                self.historicalRevenue = historicalRevenue
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }
    
    fileprivate func loadEarningsData() {
        loadingOperations.enter()
        
        financialLoader.getStockFinancials(ticker: ticker, financialFrequency: .fiveYear,
                                     financial: .netincome) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let historicalEarnings):
                self.historicalEarnings = historicalEarnings
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }
    
    fileprivate func loadCalculationsData() {
        loadingOperations.enter()
        
        batchFinancialLoader.fetchStockBatchFinancials(ticker: ticker) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let financialData):
                self.calcData = financialData
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }

    fileprivate func loadAdditionalCalculationsData() {
        [
            SearchCriteria.marketcap, .pricetoearnings,
             .pricetobook, .pricetorevenue,
             .dividendyield
        ]
        .forEach { criteria in
            loadingOperations.enter()
            
            financialLoader.getStockFinancials(ticker: ticker, financialFrequency: .recent,
                                         financial: criteria) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let recentFinancials):
                    self.financialLookup[criteria] = recentFinancials.first?.value
                    self.loadingOperations.leave()
                case .failure(let err):
                    if err == .connection { self.errorHandler?() }
                }
            }
        }
    }
    
    fileprivate func loadNewsData() {
        loadingOperations.enter()

        stockNewsLoader.get(router: .getTickerNews(tickers: ticker)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let stockNews):
                self.stockNews = stockNews.map { StockNewsViewModel(stockNews: $0) }
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }
    
    fileprivate func loadStockDescription() {
        loadingOperations.enter()

        descriptionLoader.loadDescription(for: ticker) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let stockDetail):
                self.stockDetail = stockDetail
                self.loadingOperations.leave()
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
        }
    }
}
