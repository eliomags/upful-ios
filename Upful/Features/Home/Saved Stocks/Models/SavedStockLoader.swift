//
//  SavedStockLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol SavedStockDataLoaderProtocol {
    typealias SavedStockFetchCompletion = (Result<[Stock], Error>) -> Void
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion)
    func saveCompany(ticker: String, companyName: String)
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?)
}

class SavedStockLoader: SavedStockDataLoaderProtocol {
    
    let persistenceService = PersistenceService.shared

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
            for object in objects {
                context.delete(object)
            }
            persistenceService.saveContext()
            completion?()
        } catch {
            completion?()
        }
    }
}




