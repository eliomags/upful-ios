//
//  PaymentService.swift
//  Upful
//
//  Created by Yanik Simpson on 10/21/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
  static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class PaymentService: NSObject {
    private let secret = "0f2f374e72fa4144b1842dd7158f6ebf"
    private let productIdentifiers: Set<String>

    private var purchasedProductIdentifiers: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIDs: Set<String>) {
        self.productIdentifiers = productIDs
        for productIdentifier in productIdentifiers {
          let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
          if purchased {
            purchasedProductIdentifiers.insert(productIdentifier)
            print("Previously purchased: \(productIdentifier)")
          } else {
            print("Not purchased: \(productIdentifier)")
          }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

extension PaymentService {
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
      productsRequest?.cancel()
      productsRequestCompletionHandler = completionHandler
      productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
      productsRequest!.delegate = self
      productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
      print("Buying \(product.productIdentifier)...")
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(_ productIdentifier: String) -> Bool {
      return productIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
      return true
    }
    
    public func restorePurchases() {
      
    }
}

// MARK: - SKProductsRequestDelegate

extension PaymentService: SKProductsRequestDelegate {
 // MARK: - Delegate Methods
  
  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("Loaded list of products...")
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for p in products {
      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }
  
  // MARK: - Helper
  
  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

extension PaymentService: SKPaymentTransactionObserver {
 // MARK: - Delegate Method
  public func paymentQueue(_ queue: SKPaymentQueue,
                           updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
  
  // MARK: - Helper Methods
 
  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
 
    print("restore... \(productIdentifier)")
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
        transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(localizedDescription)")
      }

    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }
 
    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
  }
}
