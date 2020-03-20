//
//  TransactionLogLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class TransactionLogLoader {
    
    // MARK: - Dependencies
    
    private let container: CoreDataModelContainerManager
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.container = container
    }
}

extension TransactionLogLoader: TransactionLoader {    
    func load(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        let request = LoggedTransaction.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "transactionDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        completion(Result {
            let persistedTransactions = try self.container.persistentContainer.viewContext.fetch(request)
            return persistedTransactions
        })
    }
}
