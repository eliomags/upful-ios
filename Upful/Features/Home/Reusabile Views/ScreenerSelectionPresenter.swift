//
//  ScreenerSelectionPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct ScreenerSelectionPresenter {
    let displayingViewController: ScreenerSelectionDelegate
    
    func present() {
        let screenerSelectionVC = ScreenerSelectionContainerView(collectionViewLayout: UICollectionViewFlowLayout())
        screenerSelectionVC.screenerSelectionDelegate = displayingViewController
        let navVC = UINavigationController(rootViewController: screenerSelectionVC)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationItem.largeTitleDisplayMode = .never
        navVC.navigationBar.tintColor = .appAccent3

        displayingViewController.present(navVC, animated: true, completion: nil)
    }
}
