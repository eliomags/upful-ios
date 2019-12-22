//
//  SavedStockLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SavedStockDataManager {
    
    let persistenceService = PersistenceService.shared

    typealias SavedStockFetchCompletion = (Result<[SavedStock], Error>) -> Void
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion) {
        let request = SavedStock.createfetchRequest()
        do {
            let savedStocks = try persistenceService.persistentContainer.viewContext.fetch(request)
            completion(.success(savedStocks))
        } catch let error {
            completion(.failure(error))
        }
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




