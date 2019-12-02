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
    
    enum PresenterType {
        case savedStockLimit
        case savedScreenerLimit
        case screeningLimit
        case settings
    }
    
    func present(in viewController: PresentationControllerDelegate) {
        let subscriptionVC = SubscriptionViewController(presenterType: type)
        subscriptionVC.presentationDelegate = viewController
        let navVC = UINavigationController(rootViewController: subscriptionVC)

        viewController.present(navVC, animated: true, completion: nil)
    }
}










