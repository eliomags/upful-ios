//
//  SubscriptionItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 9/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import StoreKit

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
        print(product.description)
        
        priceFormatter.locale = product.priceLocale
        monthlyPricing = priceFormatter.string(from: product.price)! + "/mo"
        setSavingsPercentage(from: product.price.doubleValue)
        switch UpfulProducts.ProductID(rawValue: (product.productIdentifier)) {
            
        case .oneMonth:
            subscriptionDuration = "1"
            setTotalCost(from: product.price.doubleValue, duration: 1)
        case .sixMonth:
            subscriptionDuration = "6"
            setTotalCost(from: product.price.doubleValue, duration: 6)
        case .twelveMonth:
            subscriptionDuration = "12"
            setTotalCost(from: product.price.doubleValue, duration: 12)
        default:
            fatalError("No Product with that Identifier found")
        }
    }

    private func setTotalCost(from monthlyPricing: Double, duration: Int) {
        let subscriptionAnnualCost = monthlyPricing * Double(duration)
        self.totalCost = "$\(subscriptionAnnualCost)"
    }
    
    private func setSavingsPercentage(from monthlyPricing: Double) {
        let standardMonthlyCost = UpfulProductViewModel.oneMonthPricing
        let savings = "\(Int((1-(monthlyPricing/standardMonthlyCost))*100))%"
        self.savingPercentage = savings
    }
    
}






