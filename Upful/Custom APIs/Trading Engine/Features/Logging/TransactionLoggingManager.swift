//
//  TransactionLoggingManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

class TransactionLoggingManager {
    private let transactionLogLoader: TransactionLogLoader
    private let localTransactionLogger: TransactionLogger 
    private let remoteTransactionLogger: TransactionLogger
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext = TransactionContainerManager.shared.managedObjectContext) {
        self.transactionLogLoader = TransactionLogLoader(context: context)
        self.localTransactionLogger = LocalTransactionLogger(context: context)
        self.remoteTransactionLogger = RemoteTransactionLogger()
    }
    
    func load(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        transactionLogLoader.load(completion: completion)
    }
    
    func log(_ transaction: Transaction, of type: TransactionType, completion: @escaping ((Error?) -> Void)) {
        transaction.type = type.rawValue
        transaction.transactionDate = Date().asString
        
        remoteTransactionLogger.log(transaction, of: type, completion: { _ in
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
