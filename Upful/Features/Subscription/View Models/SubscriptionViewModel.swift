//
//  SubscriptionViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 10/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionViewModel {
    
    // MARK - Dependencies
    
    let suscriptionDataService = SubscriptionDataService()
    let iAPService: IAPService = IAPService()
    
    // MARK: - State
    
    enum State {
        case awaiting
        case loading
        case loaded(products: [SKProduct])
        case error
        case paymentError(error: SKError.Code)
        case paymentSuccess
    }
    
    private(set) var state: State = .awaiting {
        didSet {
            handleStateChange()
            stateChanged?(state)
        }
    }
    
    var stateChanged: ((State) -> Void)?
    
    private func handleStateChange() {
        switch state {
            
        case .loaded(let fetchedProducts):
            let sortedProducts = fetchedProducts.sorted { (product1, product2) -> Bool in
                return product1.price.doubleValue < product2.price.doubleValue
            }
            productViewModels.append(contentsOf: sortedProducts.compactMap({ [UpfulProductViewModel(product: $0)] }))
            selectedProduct = sortedProducts.first
        default:
            break
        }
    }
    
    private var selectedProduct: SKProduct?
    var productViewModels: [[UpfulProductViewModel]] = [[]]
    
    // MARK: - Initializer
    
    init() {
        iAPService.retreiveProducts { (result) in
            switch result {
            case .success(let fetchedProducts):
                self.state = .loaded(products: fetchedProducts)

            case .failure(_):
                self.state = .error
            }
        }
        listenForPurchaseCompletion()
    }
    
    func setSelectedProduct(_ product: SKProduct) {
        self.selectedProduct = product
        iAPService.verifyProductSubscription(product)
    }
    
    func buySelectedProduct() {
        guard let selectedProduct = selectedProduct else { return }
        iAPService.purchaseProduct(selectedProduct)
    }
    
    func listenForPurchaseCompletion() {
        iAPService.purchaseCompletionHandler = { [weak self] (success, error) in
            guard let self = self else { return }
            if let error = error {
                self.state = .paymentError(error: error)
            }
            if success {
                self.state = .paymentSuccess
            }
        }
    }
    
    func restorePurchase(completion: @escaping (Bool) -> Void) {
        iAPService.restorePurchases(completion: completion)
    }

}
