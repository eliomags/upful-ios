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
    private let localTransactionLogger: TransactionLogger 
    private let remoteTransactionLogger: TransactionLogger
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionLoggerContextManager.shared) {
        self.transactionLogLoader = TransactionLogLoader(container: container)
        self.localTransactionLogger = LocalTransactionLogger(container: container)
        self.remoteTransactionLogger = RemoteTransactionLogger()
    }
    
    func load(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        transactionLogLoader.load(completion: completion)
    }
    
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?) {
        remoteTransactionLogger.log(transaction, of: type, completion: nil)
        localTransactionLogger.log(transaction, of: type, completion: completion)
    }
}
