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
    var companyName: String
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
         descriptionLoader: DescriptionLoader = StockDescriptionLoader()) {
        self.ticker = ticker
        self.companyName = companyName
        self.stockQuoteLoader = priceLoader
        self.financialLoader = financialLoader
        self.batchFinancialLoader = batchFinancialLoader
        self.stockNewsLoader = stockNewsLoader
        self.descriptionLoader = descriptionLoader
    }
    
    // MARK: - API

    let loadingOperations = DispatchGroup()
    
    func loadData() {
        loadName()
        loadNewsData()
        loadStockPrice()
        loadRevenueData()
        loadEarningsData()
        loadCalculationsData()
        loadStockDescription()
        loadAdditionalCalculationsData()
    }
    
    func listenForUpdates() {
        loadingOperations.notify(queue: .main) {
            self.loadingCompletionHandler?()
        }
    }
    
    // MARK: - Private Functions
    
    fileprivate func loadName() {
        loadingOperations.enter()

        if companyName.isEmpty {
            CompanyNameLoader().loadName(for: ticker) { result in
                switch result {
                case .success(let name):
                    self.companyName = name
                case .failure(let error):
                    print("failed", error)
                }
                
                self.loadingOperations.leave()
            }
        }
    }
    
    fileprivate func loadStockPrice() {
        loadingOperations.enter()
        
        stockQuoteLoader.load(for: ticker) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let stockQuote):
                self.stockQuote = stockQuote
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
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
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
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
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
        }
    }
    
    fileprivate func loadCalculationsData() {
        loadingOperations.enter()

        batchFinancialLoader.fetchStockBatchFinancials(ticker: ticker) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let financialData):
                self.calcData = financialData
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
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
                case .failure(let err):
                    if err == .connection { self.errorHandler?() }
                }
                self.loadingOperations.leave()
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
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
        }
    }
    
    fileprivate func loadStockDescription() {
        loadingOperations.enter()

        descriptionLoader.loadDescription(for: ticker) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let stockDetail):
                self.stockDetail = stockDetail
            case .failure(let err):
                if err == .connection { self.errorHandler?() }
            }
            self.loadingOperations.leave()
        }
    }
}
