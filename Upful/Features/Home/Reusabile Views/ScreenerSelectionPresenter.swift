//
//  ScreenerSelectionPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct ScreenerSelectionPresenter {
    let displayingViewController: UIViewController
    
    func present() {
        let screenerSelectionVC = ScreenerSelectionViewController()
        let navVC = UINavigationController(rootViewController: screenerSelectionVC)
        displayingViewController.present(navVC, animated: true, completion: nil)
    }
}
