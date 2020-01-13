//
//  StockPreviewDataFetch.swift
//  Upful
//
//  Created by Yanik Simpson on 12/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class StockViewModel {
    var previewFetchCompletion: (() -> Void)?
    
    let stock: Stock
    var stockPreviewLoader: StockPreviewLoaderProtocol?
    
    init(stock: Stock, stockPreviewLoader: StockPreviewLoaderProtocol) {
        self.stock = stock
        self.stockPreviewLoader = stockPreviewLoader
        self.stockPreviewLoader?.delegate = self
    }
    
    func loadPreviewData() {
        stockPreviewLoader?.start()
    }
    
}

extension StockViewModel: StockPreviewLoaderDelegate {
    func didLoadMarketcap(with value: Int) {
        DispatchQueue.main.async {
            self.stock.marketcap = value
            self.previewFetchCompletion?()
        }
    }
    
    func didLoadPriceToEarnings(with value: Double) {
        DispatchQueue.main.async {
            self.stock.pricetoearnings = value
            self.previewFetchCompletion?()
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

protocol StockPreviewLoaderDelegate: class {
    func didLoadMarketcap(with value: Int)
    func didLoadPriceToEarnings(with value: Double)
}

protocol StockPreviewLoaderProtocol: class {
    var delegate: StockPreviewLoaderDelegate? { get set }
    
    func start()
    func getPriceToEarningsPreviewData()
    func getMarketCapPreviewData()
}

final class StockPreviewLoader: StockPreviewLoaderProtocol {
    let intrinioAPI = IntrinioAPI()
    
    let name: String
    let ticker: String
    weak var delegate: StockPreviewLoaderDelegate?

    init(ticker: String, name: String) {
        self.name = name
        self.ticker = ticker
    }
    
    func start() {
        checkCache { (shouldMakeHTTPRequest) in
            if shouldMakeHTTPRequest {
                /// instantiated only for the first time this function is called, subsequent calls to this function will pull data from cache
                stockToCache = Stock(name: name, ticker: ticker)
                getPriceToEarningsPreviewData()
                getMarketCapPreviewData()
            }
        }
    }
    
    // MARK: - Caching
    
    private var stockToCache: Stock? {
        didSet {
            /// stores cache for first checkCache function call
            Stock.cache.setObject(stockToCache!, forKey: ticker as NSString)
        }
    }
    
    private func checkCache(shouldMakeHTTPRequest: ((Bool) -> Void)) {
        if let cachedStock = Stock.cache.object(forKey: ticker as NSString) {
            delegate?.didLoadMarketcap(with: cachedStock.marketcap ?? 0 )
            delegate?.didLoadPriceToEarnings(with: cachedStock.pricetoearnings ?? 0)
        } else {
            shouldMakeHTTPRequest(true)
        }
    }
    
    // MARK: - Data Fetching
    
    func getPriceToEarningsPreviewData() {
        intrinioAPI.fetchStockSpecificFinancial(ticker: ticker, financial: .pricetoearnings, frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                guard !companyHistorics.isEmpty else { return }
                self.stockToCache?.pricetoearnings = companyHistorics.first?.value
                self.delegate?.didLoadPriceToEarnings(with: companyHistorics.first?.value ?? 0)
            case .failure(_):
                break
            }
        })
    }
        
    func getMarketCapPreviewData() {
        intrinioAPI.fetchStockSpecificFinancial(ticker: ticker, financial: .marketcap, frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let companyHistorics):
                guard !companyHistorics.isEmpty else { return }
                self.stockToCache?.marketcap = Int(companyHistorics.first?.value ?? 0)
                self.delegate?.didLoadMarketcap(with: Int(companyHistorics.first?.value ?? 0))
            case .failure(_):
                break
            }
        })
    }
}
