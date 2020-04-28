//
//  SubscriptionPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionPresenter {
    
    let userDefaults: UserDefaults
    let type: PresenterType
    
    enum PresenterType: String {
        case firstAppOpen = "first_app_open"
        case savedStockLimit = "saved_stock_limit"
        case savedScreenerLimit = "saved_screener_limit"
        case screeningLimit = "screening_navigation_limit"
        case settings
        case fiveYearDataInterest = "5_year_data_interest"
    }
    
    init(type: PresenterType, userDefaults: UserDefaults = UserDefaults.standard) {
        self.type = type
        self.userDefaults = userDefaults
    }
    

    func present(in viewController: SubscriptionViewControllerDelegate) {
        AnalyticsLogger.instance.reportEvents(event: .signUpForPremiumPresented(trigger: type.rawValue))

        switch type {
        case .firstAppOpen:
            if userDefaults.firstAppOpen {
                userDefaults.toggleBool(.firstAppOpen)
                present(vc: viewController)
            }
        default:
            present(vc: viewController)
        }
        
    }
    
    private func present(vc: SubscriptionViewControllerDelegate) {
        let subscriptionVC = SubscriptionViewController(presenterType: type)
        subscriptionVC.delegate = vc
        let navVC = UINavigationController(rootViewController: subscriptionVC)
        navVC.modalPresentationStyle = .automatic
        
        vc.present(navVC, animated: true, completion: nil)
    }
    
}










