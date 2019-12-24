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
        
        savingScreener.title = screener.savedScreener.title
        savingScreener.screenDescription = ""
        saveParameters(for: savingScreener, manualScreeningParameters: mapToManualSearchItems(screener: screener))

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
        return savedScreeners.map({ Screener(savedScreener: $0,
                                             savedParameters: getParameters(for: $0.title))
                })
    }
    
    fileprivate func mapToManualSearchItems(screener: Screener) -> [ManualScreenItem] {
        let manualScreeningParameters = screener.savedParameters.map { (param) -> ManualScreenItem in
            let criteria = SearchCriteria(rawValue: param.criteria)
            let parameter = SearchParameter(rawValue: param.parameter)
            
            return ManualScreenItem(criteria: criteria ?? SearchCriteria.dividendyield, parameter: parameter ?? SearchParameter.lt, value: param.value )
        }
        
        return manualScreeningParameters
    }
}
