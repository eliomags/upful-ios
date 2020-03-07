//
//  SearchResultsViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 2/26/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol SearchResultsViewModelDelegate: AnyObject {
    func didCompleteStockFetch(fetchedStocks: [Stock])
    func didFailStockFetch(with error: NetworkError, for stock: Stock?)
    func didCompleteScreenerSave()
    func didFailScreenerSave()
}

class SearchResultsViewModel {
    
    // MARK: - Dependencies
        
    var stockScreener: StockScreener
    let localScreenerLoader: LocalScreenerLoaderProtocol

    // MARK: - Properties
    
    weak var delegate: SearchResultsViewModelDelegate?

    var screener: ScreenerViewModel?
    var searchParameters: [String] = .init()
    var stockViewModels: [StockViewModel] = []
    
    // MARK: - Configuration
    
    var updateHandler: (() -> Void)?
    
    // Default value for saving screener
    lazy var saveScreenerPermission: (@escaping (Bool) -> Void) -> Void = {
        return PermissionManager.shared.getSaveScreenerPermission
    }()

    // MARK: - Initializer

    init(localScreenerLoader: LocalScreenerLoaderProtocol = LocalScreenerLoader(),
         stockScreener: StockScreener = StockScreeningService()
    ){
        self.localScreenerLoader = localScreenerLoader
        self.stockScreener = stockScreener
    }
    
    // MARK: - API
        
    func screenForStocks() {
        let searchKeys = searchParameters.joined(separator: ",").filter { $0 != " " }
        stockScreener.get(router: .getScreeningResults(
            parameters: searchKeys, numberOfResults: 15,
            page: stockScreener.screenerPage,
            order: stockScreener.screenerSortDirection)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedStocks):
                let vms = fetchedStocks.map { StockViewModel(stock: $0) }
                vms.forEach { (vm) in
                    vm.updateHandler = { [weak self] in self?.updateHandler?() }
                    vm.loadPreviewData()
                }
                self.stockViewModels.append(contentsOf: vms)
                self.delegate?.didCompleteStockFetch(fetchedStocks: fetchedStocks)
            case .failure(let err):
                self.delegate?.didFailStockFetch(with: err, for: nil)
            }
        }
    }

    func changeScreenerDirection() {
//        let searchKeys = searchParameters.joined(separator: ",").filter { $0 != " " }
//        stockScreener.changeDirection(router: .getScreeningResults(
//            parameters: searchKeys, numberOfResults: 20,
//            page: stockScreener.screenerPage,
//            order: stockScreener.screenerSortDirection)) { [weak self] (result) in
//                guard let self = self else { return }
//                switch result {
//                case .success(let fetchedStocks):
//                    self.searchResults.removeAll()
//                        self.searchResults.append(contentsOf: fetchedStocks)
//                        self.searchResults.forEach { (stock) in
//                            self.getPriceToEarningsData(for: stock)
//                        }
//                    self.delegate?.didCompleteStockFetch(fetchedStocks: fetchedStocks)
//                case .failure(let err):
//                    self.delegate?.didFailStockFetch(with: err, for: nil)
//                }
//        }
    }
        
    // MARK: Persistence
    
    func checkIfScreenerCurrentlySaved(completion: @escaping ((Bool) -> Void)) {
        localScreenerLoader.load(completion: { (res) in
            switch res {
            case .success(let screeners):
                completion(screeners.contains(where: { $0.id == self.screener?.documentID ?? UUID().uuidString }))
            case .failure(_):
                completion(false)
            }
        })
    }
    
    func deleteScreener() {
        guard let id = screener?.documentID else { return }
        localScreenerLoader.delete(with: id)
    }
    
    func handleSaveCompletion(with title: String) {
        saveScreenerPermission { [weak self] (isAuthorized) in
            guard let self = self else { return }
            if isAuthorized {
                self.delegate?.didCompleteScreenerSave()
                guard var screenerViewModel = self.screener else { return }
                screenerViewModel.title = title
                self.localScreenerLoader.save(screener: screenerViewModel.toScreener())
                
                AnalyticsLogger.instance.reportEvents(
                    event: .savedScreener(
                        description:
                            screenerViewModel
                            .searchParameters
                            .joined(separator: ",")
                    ))
            } else {
                self.delegate?.didFailScreenerSave()
            }
        }
    }
}
