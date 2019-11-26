//
//  FeaturePresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PreferencePresenter {
    var preferenceVC: PreferenceViewController!
    let preferenceDataManager: PreferenceDataManager!
    
    init(preferenceDataManager: PreferenceDataManager = .init()) {
        self.preferenceDataManager = preferenceDataManager
        self.preferenceVC = PreferenceViewController(dataManager: preferenceDataManager)
    }
 
    func present(in viewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: preferenceVC)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true)
    }
    
}

