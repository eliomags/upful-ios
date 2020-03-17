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
    private let db = Firestore.firestore()
}

extension RemoteTransactionLogger: TransactionLogger {
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?) {
        print("REMOTE LOGGING")
        db.collection("transactions").document(UUID().uuidString).setData([
            "ticker": transaction.ticker,
            "currentPrice": transaction.currentPrice,
            "shares": transaction.numberOfShares,
            "date": Date().asString,
            "type": transaction.type ?? "undetermined"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

private extension Date {
    var asString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        return formatter.string(from: self)
    }
}
