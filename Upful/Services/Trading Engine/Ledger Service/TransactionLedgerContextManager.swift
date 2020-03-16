//
//  TransactionLedgerContextManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class TransactionLedgerContextManager: CoreDataModelContainerManager {
    static let shared = TransactionLedgerContextManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionLedgerDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                assertionFailure("Failed to load persistent store: \(error.localizedDescription)")
            }
        })
        return container
    }()
}
