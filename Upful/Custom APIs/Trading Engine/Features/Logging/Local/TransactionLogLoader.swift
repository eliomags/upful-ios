//
//  TransactionLogLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class TransactionLogLoader {
    
    // MARK: - Dependencies
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext = TransactionContainerManager.shared.backgroundContext) {
        self.context = context
    }
}

extension TransactionLogLoader: TransactionLoader {    
    func load(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let request = LoggedTransaction.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "transactionDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        completion(Result {
            let persistedTransactions = try self.context.fetch(request)
            return persistedTransactions
        })
    }
}
