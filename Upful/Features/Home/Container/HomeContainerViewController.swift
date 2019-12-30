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
    
    // MARK: - Views
    
    private lazy var screenerSelectionButton: CustomRoundButton = {
        let b = CustomRoundButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 50).isActive = true
        b.widthAnchor.constraint(equalToConstant: 50).isActive = true
        b.layer.cornerRadius = 50/2
        b.setupShadow(intensity: .light, color: .secondarySystemGroupedBackground)
        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenerSelectionTap)))
        return b
    }()
    
        
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isScrollEnabled = false
        view.backgroundColor = VersionManager.mainContainerBackground()
        collectionView.backgroundColor = VersionManager.mainContainerBackground()
        configureNavBar()
        setUpViews()
    }
    
    
    // MARK: - View Setup
     
    fileprivate func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Home"
    }
    
    fileprivate func setUpViews() {
        view.addSubview(screenerSelectionButton)
        screenerSelectionButton.anchor(top: nil, leading: nil,
                                 bottom: view.layoutMarginsGuide.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 0, left: 0, bottom: 45, right: 25))
    }
    
    @objc fileprivate func handleScreenerSelectionTap(sender: UIButton) {
        let presenter = ScreenerSelectionPresenter(displayingViewController: self)
        presenter.present()
    }
}


