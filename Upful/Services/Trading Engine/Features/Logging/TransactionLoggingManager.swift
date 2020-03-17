//
//  TransactionLoggingManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct TransactionLoggingManager {
    private let transactionLogLoader: TransactionLogLoader
    private let transactionLogger: TransactionLogger // TODO: Replace with local with remote logger
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionLoggerContextManager.shared) {
        self.transactionLogLoader = TransactionLogLoader(container: container)
        self.transactionLogger = LocalTransactionLogger(container: container)
    }
    
    func load(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        transactionLogLoader.load(completion: completion)
    }
    
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?) {
        transactionLogger.log(transaction, of: type, completion: completion)
    }
}
