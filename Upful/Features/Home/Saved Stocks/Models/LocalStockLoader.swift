//
//  SavedStockLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol LocalStockDataLoaderProtocol {
    typealias SavedStockFetchCompletion = (Result<[Stock], Error>) -> Void
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion)
    func saveCompany(ticker: String, companyName: String)
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?)
}

protocol LocalStockCountLoaderProtocol {
    var savedStockCount: Int? { get set }
    
    func updateSavedStockCount()
}

final class LocalStockLoader: LocalStockDataLoaderProtocol, LocalStockCountLoaderProtocol {
    // MARK: - Dependencies
    
    private let persistenceService = PersistenceService.shared
    
    // MARK: - Properties
    
    lazy var savedStockCount: Int? = {
        var count: Int? = 0
        
        self.loadSavedStocks { (res) in
            switch res {
            case .success(let savedStocks):
                count = savedStocks.count
            case .failure(_):
                count = nil
            }
        }
        return count
    }()
    
    // MARK: - Methods
    
    func updateSavedStockCount() {
        self.loadSavedStocks { (res) in
            switch res {
            case .success(let savedStocks):
                self.savedStockCount = savedStocks.count
            case .failure(_):
                self.savedStockCount = nil
            }
        }
    }
    
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion) {
        let request = SavedStock.createfetchRequest()
        completion(Result {
            let savedStocks = try persistenceService.persistentContainer.viewContext.fetch(request)
            return mapToStocks(savedStocks)
        })
    }
    
    func mapToStocks(_ savedStocks: [SavedStock]) -> [Stock] {
        return savedStocks.map{ Stock(name: $0.companyName, ticker: $0.ticker) }
    }
    
    func saveCompany(ticker: String, companyName: String) {
        let stockToSave = SavedStock(context: persistenceService.persistentContainer.viewContext)
        stockToSave.notes = ""
        stockToSave.ticker = ticker
        stockToSave.companyName = companyName
        persistenceService.saveContext()
    }
    
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?) {
        let fetchRequest = SavedStock.createfetchRequest()
        let context = PersistenceService.shared.persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", ticker)
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects { context.delete(object) }
            persistenceService.saveContext()
            completion?()
        } catch {
            completion?()
        }
    }
}
