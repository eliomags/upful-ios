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

    private let savedStockDataManager: SavedStockDataLoaderProtocol
    
    
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
    var sendStateUpdates: ((State) -> Void)?

    var stocks: [Stock] = []
    
    
    init(savedStockDataManager: SavedStockDataLoaderProtocol = SavedStockLoader()) {
        self.savedStockDataManager = savedStockDataManager
    }
    
    
    func loadSavedStocks() {
        state = .loading
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                self.stocks = savedStocks
                self.getPreviewData()
            case .failure(_):
                self.state = .error
            }
            self.refreshState()
        }
    }
    
    func removeTicker(_ ticker: String) {
        self.stocks.removeAll(where: { $0.ticker == ticker })
        savedStockDataManager.removeFavoriteCompany(ticker) {}
    }
    
    func refreshState() {
        state = stocks.isEmpty ? .empty: .loaded
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
            savedStockDataManager.saveCompany(ticker: stock.ticker, companyName: stock.name)
        }
    }
}
