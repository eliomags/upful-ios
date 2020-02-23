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
    var chartRevenueData: [CompanyHistoricalDatum]?
    var chartEarningsData: [CompanyHistoricalDatum]?
    var calcData: [StandardizedFinancial]?
    var stockNews: [StockNewsViewModel]?
    var stockDetail: StockDetail?

    // MARK: - Dependencies
    
    let priceLoader: QuoteLoader
    let financialLoader: FinancialLoader
    let stockNewsLoader: NewsLoaderProtocol
    let descriptionLoader: StockDescriptionLoader
    
    // MARK: - State
     
    var stateHandler: (() -> Void)?
    var errorHandler: (() -> Void)?

    // MARK: - Initializer
    
    init(ticker: String, companyName: String,
         priceLoader: QuoteLoader = StockPriceLoader(),
         financialLoader: FinancialLoader = StockFinancialLoader(),
         stockNewsLoader: NewsLoaderProtocol = NewsLoader(),
         descriptionLoader: StockDescriptionLoader = StockDescriptionLoader()
    ) {
        self.ticker = ticker
        self.companyName = companyName
        self.priceLoader = priceLoader
        self.financialLoader = financialLoader
        self.stockNewsLoader = stockNewsLoader
        self.descriptionLoader = descriptionLoader
    }
    
    // MARK: - API
    
    func loadDescription() {
        
    }
}
