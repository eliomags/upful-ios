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
            QuickSearchViewController(analyitcs: AnalyticsLogger(), presetDataLoader: PresetFeedDataLoader()),
            SearchCriteriaTableViewController(style: .grouped)
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
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                collectionView.backgroundColor = .systemBackground
            }
            if traitCollection.userInterfaceStyle == .light { collectionView.backgroundColor = .white }
        } else {
            collectionView.backgroundColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Explore"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}


