//
//  TransactionLedgerContextManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class TransactionContainerManager: CoreDataModelContainerManager {
    static let shared = TransactionContainerManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                assertionFailure("Failed to load persistent store: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }()
}

