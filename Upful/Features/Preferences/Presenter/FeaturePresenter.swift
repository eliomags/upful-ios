//
//  FeaturePresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol PreferenceDelegate: class {
    func didCompleteSaving()
}

struct PreferencePresenter {
    let presentingViewController: PreferenceDelegate
    var preferenceVC: PreferenceViewController!
    let preferenceDataManager: PreferenceDataManager!
    
    init(presentingViewController: PreferenceDelegate, preferenceDataManager: PreferenceDataManager = .init()) {
        self.preferenceDataManager = preferenceDataManager
        self.preferenceVC = PreferenceViewController(dataManager: preferenceDataManager)
        self.presentingViewController = presentingViewController
    }
 
    func present() {
        guard let vc = presentingViewController as? UIViewController else { return }
        preferenceVC.delegate = presentingViewController
        let navVC = UINavigationController(rootViewController: preferenceVC)
        navVC.modalPresentationStyle = .fullScreen
        vc.present(navVC, animated: true)
    }
}

