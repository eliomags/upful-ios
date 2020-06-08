//
//  StockPreviewDataFetch.swift
//  Upful
//
//  Created by Yanik Simpson on 12/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class StockViewModel {
    
    // MARK: - Properties
    
    let stock: Stock
    let quoteLoader: QuoteLoader
    let stockFinancialLoader: FinancialLoader
    
    // MARK: - Configuration
    
    var updateHandler: (() -> Void)?

    // MARK: - Initializer
    
    init(stock: Stock,
         quoteLoader: QuoteLoader = StockPriceLoader(),
         stockFinancialLoader: FinancialLoader = StockFinancialLoader()) {
        self.stock = stock
        self.quoteLoader = quoteLoader
        self.stockFinancialLoader = stockFinancialLoader
    }
}

// MARK: - Data Loading
extension StockViewModel {
    func loadPreviewData() {
        loadPriceToEarningsData()
        loadMarketCapData()
        loadQuoteData()
    }
    
    func loadName() {
        if stock.name.isEmpty {
            CompanyNameLoader().loadName(for: stock.ticker) { [weak self] (res) in
                switch res {
                case .success(let companyName):
                    self?.stock.name = companyName
                    DispatchQueue.main.async { self?.updateHandler?() }
                case .failure(_):
                    print("Failed to load name")
                }
            }
        }
    }
    
    func loadQuoteData() {
        quoteLoader.load(for: stock.ticker) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let quote):
                self.stock.stockQuote = quote
            case .failure(_):
                break
            }
            DispatchQueue.main.async { self.updateHandler?() }
        }
    }
    
    fileprivate func loadMarketCapData() {
        stockFinancialLoader.getStockFinancials(ticker: stock.ticker,
                                                financialFrequency: .recent,
                                                financial: .marketcap) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                self.stock.marketcap = Int(companyHistorics.first?.value ?? 0)
            case .failure(_):
                break
            }
            DispatchQueue.main.async { self.updateHandler?() }
        }
    }
    
    fileprivate func loadPriceToEarningsData() {
        stockFinancialLoader.getStockFinancials(ticker: stock.ticker,
                                                financialFrequency: .recent,
                                                financial: .pricetoearnings) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                self.stock.pricetoearnings = companyHistorics.first?.value ?? 0
            case .failure(_):
                break
            }
            DispatchQueue.main.async { self.updateHandler?() }
        }
    }
}

extension StockViewModel: Hashable {
    static func == (lhs: StockViewModel, rhs: StockViewModel) -> Bool {
        return lhs.stock.ticker == rhs.stock.ticker
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(stock.ticker)
    }
}

extension StockViewModel: StockViewable {
    var ticker: String {
        get {
            return stock.ticker
        }
    }
}
