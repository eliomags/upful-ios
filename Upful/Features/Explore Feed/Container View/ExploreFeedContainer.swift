//
//  HomeFeedContainer.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ExploreFeedContainer: MenuContainerViewController {
    
    override var menubarControllers: [MenuBarDisplayable] {
        let controllers: [MenuBarDisplayable] = [
            QuickSearchViewController(presetDataLoader: PresetFeedDataLoader()),
            SearchCriteriaTableViewController()
        ]
        return controllers
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        AppStoreReviewHelper.checkAndAskForReview(checkType: .newSession)
        collectionView.backgroundColor = VersionManager.mainContainerBackground()
        view.backgroundColor = VersionManager.mainContainerBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VersionManager.setNavigationBar(in: navigationController)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Explore"
    }
    
}


