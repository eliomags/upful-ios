//
//  LedgerPersistence.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataModelContainerManager {
    var persistentContainer: NSPersistentContainer { get set }
}
extension CoreDataModelContainerManager {
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class TransactionLedgerContextManager: CoreDataModelContainerManager {
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



// MARK: - Persistence

class TransactionLedgerPersistence {
    // MARK: - Dependencies
    
    let container: CoreDataModelContainerManager
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionLedgerContextManager.shared) {
        self.container = container
    }
    
    // MARK: - Methods
    
    func save(_ transaction: TransactionDataType) {
        let savingTransaction = PersistedTransaction(context: container.persistentContainer.viewContext)
        savingTransaction.averagePrice = transaction.averagePrice
        savingTransaction.currentPrice = transaction.currentPrice
        savingTransaction.ticker = transaction.ticker
        savingTransaction.numberOfShares = transaction.numberOfShares
        savingTransaction.transactionDate = transaction.transactionDate
        container.saveContext()
    }
    
    func delete(_ transaction: TransactionDataType) {
        let fetchRequest = PersistedTransaction.createFetchRequest()
        let context = container.persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", transaction.ticker)
        let persistedTransactions = (try? context.fetch(fetchRequest)) ?? []
        for persistedTransaction in persistedTransactions {
            context.delete(persistedTransaction)
        }
        container.saveContext()
    }
}


// MARK: - Loader
protocol TransactionLedgerLoader {
    func load(completion: @escaping (Result<[TransactionDataType], Error>)-> Void)
}

class LocalTransactionLedgerLoader: TransactionLedgerLoader {
    
    // MARK: - Dependencies

    let container: CoreDataModelContainerManager

    // MARK: - Initializer

    init(container: CoreDataModelContainerManager = TransactionLedgerContextManager.shared) {
        self.container = container
    }
    
    // MARK: - Methods
    
    func load(completion: @escaping (Result<[TransactionDataType], Error>)-> Void) {
        DispatchQueue.global().async {
            let request = PersistedTransaction.createFetchRequest()
            completion(Result {
                let persistedTransactions = try self.container.persistentContainer.viewContext.fetch(request)
                return persistedTransactions
            })
        }
    }
        
    func loadPrevious(transaction: TransactionDataType, completion: @escaping (Result<TransactionDataType?, Error>)-> Void) {
        load { (result) in
            switch result {
            case .success(let storedTransactions):
                let previousTransaction = storedTransactions.first(where: { $0.ticker == transaction.ticker })
                completion(.success(previousTransaction))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
