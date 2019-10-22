//
//  SubscriptionDataManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SubscriptionDataService: SubscriptionFeatureDataSource {
    
    var subscriptionOfferings: [SubscriptionFeatureViewModel] = []

    
    init() {
        loadSubscriptionFeatures()
    }
        
    
    fileprivate func loadSubscriptionFeatures() {
        let features = [
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Unlimited Saving", description: "Save as many screeners and stocks as you want"), feature: .saving),
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Unlimited Daily Screens", description: "Screen for as many stocks as you want each day"), feature: .screens),
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Notes Access", description: "Get access to notes"), feature: .notes)
        ]
        self.subscriptionOfferings = features
    }
    
}












