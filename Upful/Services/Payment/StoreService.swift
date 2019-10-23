//
//  StoreService.swift
//  Upful
//
//  Created by Yanik Simpson on 10/23/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

class IAPService {
    private let productIdentifiers: Set<String>
    private let secret = "0f2f374e72fa4144b1842dd7158f6ebf"
    
    var isPremium = false {
        didSet {
            saveSubscription()
        }
    }
    
    private func saveSubscription() {
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }

    
    init() {
        self.productIdentifiers = UpfulProducts.productIds
    }


    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: - Product Management
    
    func retreiveProducts(completion: @escaping (Result<[SKProduct],Error>) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers) { result in
            if let _ = result.retrievedProducts.first {
                completion(.success(Array(result.retrievedProducts)))
            }
            else {
                completion(.failure(NSError()))
            }
        }
    }
    
    typealias PurchaseCompletionHandler = (_ success: Bool, _ error: SKError.Code?) -> Void
    var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    func purchaseProduct(_ product: SKProduct) {
        SwiftyStoreKit.purchaseProduct(product.productIdentifier, quantity: 1, atomically: true) { result in
            switch result {
                
            case .success(let purchase):
                self.verifyProductSubscription(purchase.product)
                self.purchaseCompletionHandler?(true, nil)
            case .error(let error):
                self.purchaseCompletionHandler?(true, error.code)
            }
        }
    }
    
    // MARK: - Restoring Purchase
    
    func restorePurchases(completion: @escaping ((_ success: Bool) -> Void)) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoredPurchases.count > 0 {
                self.isPremium = true
                completion(true)
            }
            else {
                print("Nothing to Restore")
                completion(false)
            }
        }
    }
    
    // MARK: - Verification
    
    func verifyProductSubscription(_ product: SKProduct) {
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
                
            case .success(let receipt):
                let productId = product.productIdentifier
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                    
                case .purchased:
                    self.isPremium = true
                case .expired:
                    self.isPremium = false
                case .notPurchased:
                    self.isPremium = false
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
}







