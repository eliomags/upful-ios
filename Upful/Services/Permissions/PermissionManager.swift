//
//  PermissionManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/23/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

class PermissionManager {
    static let shared = PermissionManager()
    
    // MARK: - Parameters
    
    private let savedScreenerThreshold = 1
    private let savedStockThreshold = 3
    
    var isPremium: Bool {
        return UserDefaults.standard.bool(forKey: "isPremium")
    }

    private init() {}
    
    // MARK: - Core Data Helper
    
    private func getSavedScreenerCount() -> Int? {
        let request = SavedScreener.createfetchRequest()
        var savedScreeners: [SavedScreener] = []
        do {
            savedScreeners = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedScreeners.count
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getSavedStockCount() -> Int? {
        let request = SavedStock.createfetchRequest()
        var savedStocks: [SavedStock] = []
        do {
            savedStocks = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedStocks.count
        } catch let error {
            print("Fetch failed", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - API
    
    typealias PermissionCompletionHandler = (_ permissionGranted: Bool, _ error: Error?) -> Void
    
    func getSaveScreenerPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium, nil)
            return
        }
        if let savedScreenerCount = getSavedScreenerCount() {
            completion(savedScreenerCount < savedScreenerThreshold, nil)
            return
        }
        
        if getSavedScreenerCount() == nil {
            completion(false, NSError())
        }
    }
    
    func getSaveStockPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium, nil)
            return
        }
        if let savedStockCount = getSavedStockCount() {
            completion(savedStockCount < savedStockThreshold, nil)
            return
        }
        
        if getSavedStockCount() == nil {
            completion(false, NSError())
        }
    }
    
}
