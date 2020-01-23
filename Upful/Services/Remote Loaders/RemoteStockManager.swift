//
//  RemoteStockManager.swift
//  Upful
//
//  Created by Yanik Simpson on 1/9/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase

class RemoteStockManager {
    private static let backendService = FirestoreAPI().db

    static func updateInterest(for ticker: String, name: String) {
//        print("Incrementing", ticker)
        let popularStockCollection = FirestoreAPI.Collection.popularStocks.rawValue
        let docRef = backendService.collection(popularStockCollection).document(ticker)

        docRef.updateData([
            "ticker": ticker,
            "name": name,
            "vote": FieldValue.increment(Int64(1))
        ]) { (error) in
            if let _ = error { createDocument(withTitle: ticker, name: name) }
        }
    }
    
    private static func createDocument(withTitle ticker: String, name: String) {
        let popularStockCollection = FirestoreAPI.Collection.popularStocks.rawValue
        let docRef = backendService.collection(popularStockCollection).document(ticker)
        docRef.setData([
            "ticker": ticker,
            "name": name,
            "vote": 1
        ]) { (error) in
            if let err = error { print(err.localizedDescription) }
        }
    }
}

