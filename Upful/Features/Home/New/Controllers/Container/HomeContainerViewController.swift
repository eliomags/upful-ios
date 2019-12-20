//
//  HomeContainer.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class HomeContainerViewController: MenuContainerViewController {
    override var menubarControllers: [MenuBarDisplayable] {
        let generalVC = HomeGeneralViewController()
        let savedStocksVC = SavedStocksViewController()
        let savedScreenerVC = SavedScreenerViewController()
        return [generalVC, savedStocksVC, savedScreenerVC]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isScrollEnabled = false
        view.backgroundColor = VersionManager.mainContainerBackground()
        collectionView.backgroundColor = VersionManager.mainContainerBackground()
        configureNavBar()
    }
    
    fileprivate func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = ""
    }
}


