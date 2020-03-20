//
//  TransactionLoggingManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class TransactionLoggingManager {
    private let transactionLogLoader: TransactionLogLoader
    private let localTransactionLogger: TransactionLogger 
    private let remoteTransactionLogger: TransactionLogger
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.transactionLogLoader = TransactionLogLoader(container: container)
        self.localTransactionLogger = LocalTransactionLogger(container: container)
        self.remoteTransactionLogger = RemoteTransactionLogger()
    }
    
    func load(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        transactionLogLoader.load(completion: completion)
    }
    
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?) {
        transaction.type = type.rawValue
        transaction.transactionDate = Date().asString
        
        remoteTransactionLogger.log(transaction, of: type, completion: { [unowned self] in
            self.localTransactionLogger.log(transaction, of: type, completion: completion)
        })
    }
}

private extension Date {
    var asString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        return formatter.string(from: self)
    }
}
