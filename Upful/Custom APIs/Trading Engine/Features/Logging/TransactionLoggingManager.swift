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
    
    func load(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        transactionLogLoader.load(completion: completion)
    }
    
    func log(_ transaction: Transaction, of type: TransactionType, completion: (() -> Void)?) {
        transaction.type = type.rawValue
        transaction.transactionDate = Date().asString
        
        remoteTransactionLogger.log(transaction, of: type, completion: { [unowned self] in
            self.localTransactionLogger.log(transaction, of: type, completion: completion)
        })
    }
}

extension Date {
    var asString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter.string(from: self)
    }
    
    func convertToEST() -> Date {
        let string = self.asString
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter.date(from: string) ?? self
    }
}
