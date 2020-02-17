//
//  SavedScreenerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol LocalScreenerLoaderProtocol {
    typealias SavedScreenerLoadingCompletion = (Result<[Screener],Error>) -> Void
    func load(completion: @escaping SavedScreenerLoadingCompletion)
    func delete(with id: String)
    func save(screener: Screener)
}

class LocalScreenerLoader: LocalScreenerLoaderProtocol {
    let persistenceService = PersistenceService.shared
         
    func load(completion: @escaping SavedScreenerLoadingCompletion) {
        let request = SavedScreener.createfetchRequest()
        completion(Result {
            let savedScreeners = try persistenceService.persistentContainer.viewContext.fetch(request)
            return mapSavedScreenerToScreener(savedScreeners)
        })
    }
        
    func delete(with id: String) {
        let context = persistenceService.persistentContainer.viewContext
        let savedScreenerRequest = SavedScreener.createfetchRequest()
        savedScreenerRequest.predicate = NSPredicate(format: "id = %@", id)
        let savedScreeners = try? context.fetch(savedScreenerRequest)
        savedScreeners?.forEach({ context.delete($0) })
        persistenceService.saveContext()
    }
        
    func save(screener: Screener) {
        let context = persistenceService.persistentContainer.viewContext
        let savingScreener = SavedScreener(context: context)
        savingScreener.title = screener.title
        savingScreener.screenDescription = screener.description
        savingScreener.id = screener.id
        savingScreener.searchParameters = screener.urlComponents.joined(separator: ",")
        savingScreener.colorMap = screener.colorMap
        savingScreener.symbol = screener.symbol ?? "pencil"
        persistenceService.saveContext()
    }
    
    // MARK: - Fileprivate Functions
    
    fileprivate func mapSavedScreenerToScreener(_ savedScreeners: [SavedScreener]) -> [Screener] {        
        let screeners = savedScreeners.map { (savedScreener) -> Screener in
            return Screener(
                title: savedScreener.screenerTitle,
                description: savedScreener.screenDescription ?? "",
                urlComponents: mapURLComponents(from: savedScreener.searchParameters),
                symbol: savedScreener.symbol,
                colorMap: savedScreener.colorMap,
                id: savedScreener.id)
        }
        return screeners
    }
    
    func mapURLComponents(from components: String) -> [String] {
        var res = [String]()
        let arr = Array(components)
        var foll = 0
        for i in 0..<arr.count {
            if arr[i] == "," {
                res.append(String(arr[foll...i-1]))
                foll = i + 1
            } else if i == arr.count - 1 {
                res.append(String(arr[foll...i]))
            }
        }
        return res
    }
}
