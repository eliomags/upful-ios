//
//  HomeFeedContainer.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class HomeFeedContainer: MenuContainerViewController {
    
    override var menubarControllers: [MenuBarDisplayable] {
        let controllers: [MenuBarDisplayable] = [
            QuickSearchViewController(presetDataLoader: PresetFeedDataLoader()),
            SearchCriteriaTableViewController()
        ]
        controllers.forEach { (controller) in
            controller.delegate = self
        }
        return controllers
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        AppStoreReviewHelper.checkAndAskForReview(checkType: .newSession)
        collectionView.backgroundColor = VersionManager.mainContainerBackground(in: self)
        view.backgroundColor = VersionManager.mainContainerBackground(in: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        VersionManager.setNavigationBar(in: navigationController)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Explore"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
}


