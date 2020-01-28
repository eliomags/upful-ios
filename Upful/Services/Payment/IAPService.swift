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


/*
 This can be broken into a dataLoader and PurchaseHandler
    This will be injected into the IAPService
 */
protocol IAPServiceProtocol {
    typealias PurchaseCompletionHandler = (_ success: Bool, _ error: SKError.Code?) -> Void
    var purchaseCompletionHandler: PurchaseCompletionHandler? { get set }
    
    // DataLoader
    func retreiveProducts(completion: @escaping (Result<[SKProduct],Error>) -> Void)
    
    // PurchaseHandler
    func completeTransactions()
    func purchaseProduct(_ product: SKProduct)
    func restorePurchases(completion: @escaping (_ success: Bool) -> Void)
    func verifyProductSubscription(_ product: SKProduct)
}

class IAPService: IAPServiceProtocol {
    
    private let productIdentifiers: Set<String>
    private let secret = "0f2f374e72fa4144b1842dd7158f6ebf"
    
    var isPremium = UserDefaults.standard.bool(forKey: PermissionManager.Constants.UserDefaults.isPremium) {
        didSet {
            UserDefaults.standard.set(isPremium, forKey: PermissionManager.Constants.UserDefaults.isPremium)
        }
    }
        
    init() {
        self.productIdentifiers = UpfulProducts.productIds
    }
    
    // MARK: - API
    
    // MARK:  Product DataLoader
    
    func retreiveProducts(completion: @escaping (Result<[SKProduct],Error>) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers) { result in
            guard !result.retrievedProducts.isEmpty else {
                completion(.failure(NSError()))
                return
            }
            completion(.success(Array(result.retrievedProducts)))

        }
    }
    
    // MARK:  Product PurchaseHandler

    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    self.isPremium = true
                    
                case .failed, .purchasing, .deferred:
                    self.isPremium = false
                @unknown default:
                    break
                }
            }
        }
    }
    
    typealias PurchaseCompletionHandler = (_ success: Bool, _ error: SKError.Code?) -> Void
    var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    func purchaseProduct(_ product: SKProduct) {
        SwiftyStoreKit.purchaseProduct(product.productIdentifier, quantity: 1, atomically: true) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let purchase):
                self.verifyProductSubscription(purchase.product)
                self.purchaseCompletionHandler?(true, nil)
                self.isPremium = true

            case .error(let error):
                self.purchaseCompletionHandler?(false, error.code)
            }
        }
    }
        
    func restorePurchases(completion: @escaping (_ success: Bool) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let self = self else { return }

            if results.restoredPurchases.count > 0 {
                self.isPremium = true
                self.purchaseCompletionHandler?(true, nil)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: - Verification
    
    func verifyProductSubscription(_ product: SKProduct) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
            guard let self = self else { return }

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







