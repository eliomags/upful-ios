//
//  SavedStockVCViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SavedStockVCViewModel {
    
    // MARK: - Dependencies

    private let savedStockDataManager = SavedStockDataManager()
    
    // MARK: - State

    enum State {
        case new
        case loading
        case loaded
        case empty
        case error
    }
    
    private(set) var state: State = .new {
        didSet {
            sendStateUpdates?(state)
        }
    }

    var stocks: [Stock] = [] {
        didSet {
            state = stocks.isEmpty ? .empty: .loaded
        }
    }
    
    var sendStateUpdates: ((State) -> Void)?
    
    
    func loadSavedStocks() {
        state = .loading
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                self.mapToStocks(savedStocks)
                self.getPreviewData()
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func removeTicker(_ ticker: String) {
        savedStockDataManager.removeFavoriteCompany(ticker) { [weak self] in
            self?.loadSavedStocks()
        }
    }

    func mapToStocks(_ savedStocks: [SavedStock]) {
        var newStocks: [Stock] = []
        savedStocks.forEach { stock in
            let newStock = Stock(name: stock.companyName, ticker: stock.ticker)
            newStocks.append(newStock)
        }
        self.stocks = newStocks
    }
    
    fileprivate func getPreviewData() {
        for stock in stocks {            
            loadOperations(for: stock)
        }
    }
    
    // MARK: - Fetch Preview Data
    
    lazy var pendingPreviewDataFetch: [String: StockPreviewDataFetch] = [:]
    lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Stock Financial Preview Fetch Queue"
        return queue
    }()
    
    func loadOperations(for stock: Stock) {
        if !pendingPreviewDataFetch.contains(where: { $0.key == stock.ticker }) {
            let operation = StockPreviewDataFetch(stock: stock)
            operation.completionBlock = { [weak self] in
                guard let self = self else { return }
                self.pendingPreviewDataFetch = self.pendingPreviewDataFetch.filter({ $0.value.isFinished != true })
                DispatchQueue.main.async { self.state = .loaded }
            }
            pendingPreviewDataFetch[stock.ticker] = operation
            operationQueue.addOperation(operation)
        }
    }
    
    func saveDatasourceConfiguration() {
        stocks.forEach { (stock) in
            savedStockDataManager.removeFavoriteCompany(stock.ticker) {}
        }
        stocks.forEach { (stock) in
            savedStockDataManager.saveCompany(ticker: stock.ticker, companyName: stock.name)
        }
    }
}
