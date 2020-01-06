//
//  ScreenerSelectionContainerView.swift
//  Upful
//
//  Created by Yanik Simpson on 1/2/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ScreenerSelectionContainerView: MenuContainerViewController {

    override var menubarControllers: [MenuBarDisplayable] {
        let preBuiltScreenerVC = PrebuiltScreenerViewController()
        let customSearchVC = SearchCriteriaTableViewController()
        return [preBuiltScreenerVC, customSearchVC]
    }
    
    weak var screenerSelectionDelegate: ScreenerSelectionDelegate?
    
    // MARK: - Views
    
    private lazy var cancelButton: CancelButton = {
         let button = CancelButton()
         button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
         return button
     }()
     
    // MARK: - Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
        
    // MARK: - Actions
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true)
    }
    
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Screeners"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
}
