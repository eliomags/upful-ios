//
//  SavedScreenerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol SavedScreenerLoaderProtocol {
    typealias SavedScreenerLoadingCompletion = (Result<[Screener],Error>) -> Void
    func loadSavedScreeners(completion: @escaping SavedScreenerLoadingCompletion)
    func removeScreenerParameters(with title: String)
    func removeScreener(with title: String)
    func saveScreener(screener: Screener)
}

class SavedScreenerLoader: SavedScreenerLoaderProtocol {
    
    let persistenceService = PersistenceService.shared
    
    func loadSavedScreeners(completion: @escaping SavedScreenerLoadingCompletion) {
        let request = SavedScreener.createfetchRequest()
        completion(Result {
            let savedScreeners = try persistenceService.persistentContainer.viewContext.fetch(request)
            return mapToScreener(savedScreeners)
        })
    }
    
    fileprivate func getParameters(for title: String) -> [SavedScreenerParameter] {
        let savedParameters = SavedScreenerParameter.createfetchRequest()
        savedParameters.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        let parameters = try? persistenceService.persistentContainer.viewContext.fetch(savedParameters)
        return parameters ?? []
    }
    
    // MARK: - Removing
    
    func removeScreenerParameters(with title: String) {
        let context = persistenceService.persistentContainer.viewContext
        let parameterRequest = SavedScreenerParameter.createfetchRequest()
        
        parameterRequest.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        let searchParameters = try? context.fetch(parameterRequest)
        searchParameters?.forEach({ context.delete($0) })
        persistenceService.saveContext()
    }
    
    func removeScreener(with title: String) {
        let context = persistenceService.persistentContainer.viewContext
        let savedScreenerRequest = SavedScreener.createfetchRequest()
        
        savedScreenerRequest.predicate = NSPredicate(format: "title = %@", title)
        let savedScreeners = try? context.fetch(savedScreenerRequest)
        savedScreeners?.forEach({ context.delete($0) })
        persistenceService.saveContext()
    }
    
    // MARK: - Saving
    
    func saveScreener(screener: Screener) {
        let context = persistenceService.persistentContainer.viewContext
        let savingScreener = SavedScreener(context: context)
        
        savingScreener.title = screener.title
        savingScreener.screenDescription = ""
        
        // TODO: - Handle saving image data
        
        saveParameters(for: savingScreener, manualScreeningParameters: screener.manualScreenItems)

        persistenceService.saveContext()
    }
    
    fileprivate func saveParameters(for screener: SavedScreener, manualScreeningParameters: [ManualScreenItem]) {
        let context = persistenceService.persistentContainer.viewContext
        
        manualScreeningParameters.forEach { (screenerItem) in
            let savingParameter = SavedScreenerParameter(context: context)
            savingParameter.value = screenerItem.value ?? 0
            savingParameter.parameter = screenerItem.parameter.rawValue
            savingParameter.criteria = screenerItem.criteria.rawValue
            savingParameter.savedScreener = screener
            persistenceService.saveContext()
        }
    }
    
    // MARK: - Fileprivate Functions
    
    fileprivate func mapToScreener(_ savedScreeners: [SavedScreener]) -> [Screener] {        
        let screeners = savedScreeners.map { (screener) -> Screener in
            let parameters = getParameters(for: screener.title)
            
            return Screener(title: screener.title,
                            description: parameters.configureDescription(),
                            urlComponents: parameters.configureURLComponents(),
                            imageUrlString: screener.imageUrlString,
                            manualScreenItems: parameters.mapToManualScreenItems())
        }
        return screeners
    }
}
