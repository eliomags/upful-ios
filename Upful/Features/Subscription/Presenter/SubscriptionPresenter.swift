//
//  SubscriptionPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionPresenter {
    
    let type: PresenterType
    
    init(type: PresenterType) {
        self.type = type
    }
    
    enum PresenterType: String {
        case savedStockLimit = "saved_stock_limit"
        case savedScreenerLimit = "saved_screener_limit"
        case screeningLimit = "screening_navigation_limit"
        case settings
    }
    
    func present(in viewController: PresentationControllerDelegate) {
        let subscriptionVC = SubscriptionViewController(presenterType: type)
        subscriptionVC.presentationDelegate = viewController
        let navVC = UINavigationController(rootViewController: subscriptionVC)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true, completion: nil)
    }
}










