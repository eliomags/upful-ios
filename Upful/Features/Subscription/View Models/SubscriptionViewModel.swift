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
    
    // MARK: - State
    
    enum State {
        case awaiting
        case loading
        case loaded(products: [SKProduct])
        case error
    }
    
    var state: State = .awaiting {
        didSet {
            handleStateChange()
            stateChanged?(state)
        }
    }
    
    var productViewModels: [[UpfulProductViewModel]] = [[]] {
        didSet {
            print(productViewModels)
        }
    }
    
    var stateChanged: ((State) -> Void)?
    
    private func handleStateChange() {
        switch state {
            
        case .loaded(let fetchedProducts):
            let sortedProducts = fetchedProducts.sorted { (product1, product2) -> Bool in
                return product1.price.doubleValue > product2.price.doubleValue
            }
            productViewModels.append(contentsOf: sortedProducts.compactMap({ [UpfulProductViewModel(product: $0)] }))
        default:
            break
        }
    }
    
    let suscriptionDataService = SubscriptionDataService()
    
    // MARK: - Initializer
    
    init() {
        UpfulProducts.store.requestProducts { [weak self] (success, products) in
            guard let self = self else { return }
            if success {
                self.state = .loaded(products: products ?? [])
            } else {
                self.state = .error
            }
        }
    }
    
}
