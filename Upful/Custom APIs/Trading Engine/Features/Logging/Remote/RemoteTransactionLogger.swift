//
//  RemoteTransactionLogger.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase

final class RemoteTransactionLogger {
    private static let db = Firestore.firestore()
}

extension RemoteTransactionLogger: TransactionLogger {
    func log(_ transaction: Transaction, of type: TransactionType, completion: (() -> Void)?) {
        RemoteTransactionLogger.db.collection("transactions").document(UUID().uuidString).setData([
            "ticker": transaction.ticker,
            "price": transaction.tradePrice,
            "shares": transaction.numberOfShares,
            "date": transaction.transactionDate ,
            "type": transaction.type ,
            "user": UserProfile.instance.profileID
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            completion?()
        }
    }
}
