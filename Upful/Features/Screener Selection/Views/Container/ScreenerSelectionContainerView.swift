//
//  ScreenerSelectionContainerView.swift
//  Upful
//
//  Created by Yanik Simpson on 1/2/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ScreenerSelectionContainerView: MenuContainerViewController {

    override var menubarControllers: [UIViewController] {
        let preBuiltScreenerVC = PrebuiltScreenerViewController()
        let customSearchVC = SearchCriteriaTableViewController()
        return [preBuiltScreenerVC, customSearchVC]
    }
        
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
        
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Screeners"
    }
}
