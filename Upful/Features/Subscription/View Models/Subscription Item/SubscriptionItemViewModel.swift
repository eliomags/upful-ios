//
//  SubscriptionItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 9/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct SubscriptionItemViewModel {
    let subscriptionDuration: String
    let monthlyPricing: String
    var savingPercentage: String?
    var totalCost: String?
    
    static let oneMonthPricing = 14.99
    
    init(subscriptionItem: SubscriptionItem) {
        self.subscriptionDuration = "\(subscriptionItem.subscriptionDuration)"
        self.monthlyPricing = "$\(subscriptionItem.monthlyPricing)/mo"
        
        setSavingsPercentage(from: subscriptionItem.monthlyPricing)
        setTotalCost(from: subscriptionItem.monthlyPricing, duration: subscriptionItem.subscriptionDuration)
    }
    
    
    // MARK: - Helpers
    
    private mutating func setSavingsPercentage(from monthlyPricing: Double) {
        let standardMonthlyCost = SubscriptionItemViewModel.oneMonthPricing
        let savings = "\(Int((1-(monthlyPricing/standardMonthlyCost))*100))%"
        self.savingPercentage = savings
    }
    
    private mutating func setTotalCost(from monthlyPricing: Double, duration: Int) {
        let subscriptionAnnualCost = monthlyPricing * Double(duration)
        self.totalCost = "$\(subscriptionAnnualCost)"
    }
}





