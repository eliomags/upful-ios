//
//  CoreDataUseCase.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 9/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
import CoreData

class CoreDataUseCase: XCTestCase {
    
    var transactionViewContext: NSManagedObjectContext {
        return MockTransactionContainerManager.shared.viewContext
    }
    
    
    private class MockTransactionContainerManager {
        static let shared = MockTransactionContainerManager()
        
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TransactionDataModel")
            let description = NSPersistentStoreDescription()
            
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    assertionFailure("Failed to load persistent store: \(error.localizedDescription)")
                }
            })
            return container
        }()
        
        var viewContext: NSManagedObjectContext {
            return persistentContainer.viewContext
        }
    }
}
