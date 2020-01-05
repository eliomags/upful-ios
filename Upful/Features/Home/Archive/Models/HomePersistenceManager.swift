//
//  HomePersistenceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 12/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

// Old

class HomePersistenceManager {
    
    let persistenceService = PersistenceService.shared
    
    func getParameters(named title: String) -> [SavedScreenerParameter] {
        var parameters = [SavedScreenerParameter]()
        let savedParameters = SavedScreenerParameter.createfetchRequest()
        savedParameters.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        do {
            parameters = try PersistenceService.shared.persistentContainer.viewContext.fetch(savedParameters)
        } catch {
            print(error.localizedDescription)
        }
        return parameters
    }
    
    func configureSavedItemsToDisplay(completion: @escaping (Result<[Screener],Error>) -> Void) {
        let request = SavedScreener.createfetchRequest()
        do {
            var screeners: [SavedScreener] = []
            var savedItems: [Screener] = []
            screeners = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            screeners.forEach { (screener) in
                let savedItem = Screener(
                                         title: screener.title,
                                         description: screener.screenDescription ?? "",
                                         urlComponents: [],
                                         imageData: screener.imageData,
                                         manualScreenItems: [])
                savedItems.append(savedItem)
            }
            completion(.success(savedItems))
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadSavedStocks(completion: @escaping (Result<[SavedStock], Error>) -> Void) {
        let request = SavedStock.createfetchRequest()
        do {
            let savedStocks = try persistenceService.persistentContainer.viewContext.fetch(request)
            completion(.success(savedStocks))
        } catch let err {
            completion(.failure(err))
        }
    }
    
    func removeFavoriteCompany(_ ticker: String) {
        let fetchRequest = SavedStock.createfetchRequest()
        let context = PersistenceService.shared.persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", ticker)
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeFavoriteScreener(_ title: String) {
        let context = PersistenceService.shared.persistentContainer.viewContext
        
        /// We need to delete all search parameters corresponding to the deleted Screener title
        let paramRequest = SavedScreenerParameter.createfetchRequest()
        paramRequest.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        do {
            let searchParameters = try context.fetch(paramRequest)
            for parameter in searchParameters { context.delete(parameter) }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
        
        let request = SavedScreener.createfetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
            }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}






















