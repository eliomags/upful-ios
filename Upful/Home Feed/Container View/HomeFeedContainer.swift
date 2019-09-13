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
            HomeFeedViewController(analyitcs: AnalyticsLogger(), presetDataLoader: PresetFeedDataLoader()),
            SearchCriteriaTableViewController(style: .grouped)
        ]
        controllers.forEach { (controller) in
            controller.delegate = self
        }
        
        return controllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .groupTableViewBackground
        configureNavBar()
        AppStoreReviewHelper.checkAndAskForReview(checkType: .newSession)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Upful"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}


