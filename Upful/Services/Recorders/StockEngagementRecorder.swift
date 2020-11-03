//
//  StockEngagementRecorder.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import FirebaseFirestore

class StockEngagementRecorder {
    private let ticker: String
    private var startTime = Date()
    
    private let backendService = FirestoreAPI().db
    
    init(ticker: String) {
        self.ticker = ticker
    }
    
    func start() {
        startTime = Date()
    }
    
    func end() {
        let user = UserProfile.instance.profileID
        let duration = Date().timeIntervalSince(startTime)
        let timestamp = Timestamp().dateValue().convertToEST()
        
        let engagementCollection = FirestoreAPI.Collection.engagement.rawValue
        let engagementDocument = backendService.collection(engagementCollection).document(ticker)
        let userCollection = FirestoreAPI.Collection.users.rawValue
        let userDocument = backendService.collection(userCollection).document(user)
        
        let engagement = FieldValue.arrayUnion([[
            "duration": duration,
            "user": user,
            "timestamp": timestamp]])
        engagementDocument.setData(["data": engagement], merge: true)
        userDocument.setData(["engagement": engagement], merge: true)
    }
}
