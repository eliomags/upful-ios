//
//  SubscriptionItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 9/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import StoreKit

extension Double {
    func roundToTwoDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

class UpfulProductViewModel {
    private static let oneMonthPricing = 8.99
    private let priceFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.formatterBehavior = .behavior10_4
      formatter.numberStyle = .currency
      return formatter
    }()

    let product: SKProduct
    
    var subscriptionDuration: String?
    var monthlyPricing: String?
    var totalCost: String?
    var savingPercentage: String?

    
    init(product: SKProduct) {
        self.product = product
        
        setValues()
    }
    
    private func setValues() {        
        priceFormatter.locale = product.priceLocale
        totalCost = priceFormatter.string(from: product.price)!
        
        switch UpfulProducts.ProductID(rawValue: (product.productIdentifier)) {
            
        case .oneMonth:
            subscriptionDuration = "1"
            setMonthlyCost(from: product.price.doubleValue, duration: 1)
        default:
            fatalError("No Product with that Identifier found")
        }
    }

    private func setMonthlyCost(from totalPricing: Double, duration: Int) {
        let subscriptionMonthlyCost = totalPricing / Double(duration)
        self.monthlyPricing = "$\(subscriptionMonthlyCost.roundToTwoDecimal())" + "/mo"
    }
    
    private func setSavingsPercentage(from pricing: Double, duration: Int) {
        let standardMonthlyCost = UpfulProductViewModel.oneMonthPricing
        let savings = "\(Int((1-((pricing / Double(duration))/standardMonthlyCost))*100))%"
        self.savingPercentage = savings
    }
    
}






