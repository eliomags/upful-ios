//
//  ScreenerSelectionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ScreenerSelectionViewController: UITableViewController {
    
    
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = VersionManager.mainContainerBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Selection"
    }
    
}
