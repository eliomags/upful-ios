//
//  FeaturePresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct PreferencePresenter {
    let preferenceDataManager = PreferenceDataManager()
 
    func present(in viewController: UIViewController) {
        let preferenceVC = PreferenceViewController(dataManager: preferenceDataManager)
        
        let navVC = UINavigationController(rootViewController: preferenceVC)

        viewController.present(navVC, animated: true)
    }

}

