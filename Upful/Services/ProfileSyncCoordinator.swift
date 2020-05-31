//
//  ProfileSyncCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 5/31/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase

class ProfileSyncCoordinator {
    
    static let shared = ProfileSyncCoordinator()
    private init() {}
    
    private enum Collection {
        static let users = "users"
    }
    
    private let db = Firestore.firestore()
    
    func sync(holdings: [Holding], equityBalance: Double) {
        let currentUserID = UserProfile.instance.profileID
        let mappableHoldings = ProfileSyncCoordinator.createMappableHoldings(from: holdings)
        let performance = ProfileSyncCoordinator.calculateTotalPerformance(from: equityBalance)

        db.collection(Collection.users).document(currentUserID).setData([
            "userID": currentUserID,
            "lastSync": Timestamp(date: Date()),
            "performanceAsPercent": performance,
            "holdings": mappableHoldings
        ])
    }
    
    // MARK: Helpers
    
    private static func calculateTotalPerformance(from equityBalance: Double) -> Double {
        return ((equityBalance / 25_000) - 1) * 100
    }
    
    private static func createMappableHoldings(from holdings: [Holding]) -> [[String: Any]] {
        var result = [[String: Any]]()
        holdings.forEach { (holding) in
            var appending: [String: Any] = [:]
            appending["ticker"] = holding.ticker
            appending["shares"] = holding.totalShareCount
            appending["avgPrice"] = holding.averagePrice
            result.append(appending)
        }
        return result
    }
}
