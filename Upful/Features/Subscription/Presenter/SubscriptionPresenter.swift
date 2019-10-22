//
//  SubscriptionPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct SubscriptionPresenter {
    func present(in viewController: UIViewController) {
        let subscriptionVC = SubscriptionViewController()
        let navVC = UINavigationController(rootViewController: subscriptionVC)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true, completion: nil)
    }
}










