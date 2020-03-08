//
//  SavedStockVCViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SavedStockLogicController {
    
    // MARK: - Dependencies

    private let localStockDataLoader: LocalStockDataLoaderProtocol
    
    // MARK: - State

    enum State {
        case new
        case loading
        case loaded
        case empty
        case error
    }
    
    var sendStateUpdates: ((State) -> Void)?

    private(set) var state: State = .new {
        didSet {
            sendStateUpdates?(state)
        }
    }
    private(set) var stockViewModels: [StockViewModel] = []
    
    // MARK: - Initializer
    
    init(savedStockDataManager: LocalStockDataLoaderProtocol = LocalStockLoader()) {
        self.localStockDataLoader = savedStockDataManager
    }
    
    // MARK: - API Methods
    
    func loadSavedStocks() {
        state = .loading
        localStockDataLoader.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                let mappedViewModels = savedStocks.map { StockViewModel(stock: $0) }
                self.stockViewModels = mappedViewModels
                self.getPreviewData()
                self.refreshState()
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func removeTicker(_ ticker: String) {
        stockViewModels.removeAll(where: { $0.stock.ticker == ticker })
        localStockDataLoader.removeFavoriteCompany(ticker) {}
    }
    
    func refreshState() {
        state = stockViewModels.isEmpty ? .empty : .loaded
    }
    
    fileprivate func getPreviewData() {
        stockViewModels.forEach { stockViewModel in
            stockViewModel.updateHandler = { [weak self] in self?.state = .loaded }
            stockViewModel.loadPreviewData()
        }
    }
        
    func saveDatasourceConfiguration(from sourceIndexPath: Int, to destinationIndexPath: Int) {
        stockViewModels.moveItem(from: sourceIndexPath, to: destinationIndexPath)
        
        stockViewModels.forEach { (vm) in
            localStockDataLoader.removeFavoriteCompany(vm.stock.ticker) {}
            localStockDataLoader.saveCompany(ticker: vm.stock.ticker, companyName: vm.stock.name)
        }
    }
}
