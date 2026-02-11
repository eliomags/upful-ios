//
//  SavedViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 3/25/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedViewController: MenuContainerViewController {
    
    override var menubarControllers: [UIViewController] {
        let savedStocksVC = SavedStocksViewController()
        let savedScreenerVC = SavedScreenerViewController()
        return [savedStocksVC, savedScreenerVC]
    }
    
    // MARK: - Views
    
    private lazy var screenerSelectionButton: CustomRoundButton = {
        let b = CustomRoundButton(imageName: "plus")
        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenerSelectionTap)))
        return b
    }()
    
        
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isScrollEnabled = false
        view.backgroundColor = ThemeManager.mainContainerBackground()
        collectionView.backgroundColor = ThemeManager.mainContainerBackground()
        configureNavBar()
        setUpViews()
    }
    
    // MARK: - View Setup
     
    fileprivate func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Bookmarks"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    fileprivate func setUpViews() {
        view.addSubview(screenerSelectionButton)
        screenerSelectionButton.anchor(top: nil,
                                       leading: nil,
                                       bottom: view.layoutMarginsGuide.bottomAnchor,
                                       trailing: view.layoutMarginsGuide.trailingAnchor,
                                       padding: .init(top: 0, left: 0, bottom: 16, right: 4))
    }
    
    func emphasizeButton() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.screenerSelectionButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.screenerSelectionButton.transform = .identity
            }) { (_) in
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.screenerSelectionButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { (_) in
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.screenerSelectionButton.transform = .identity
                    })
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleScreenerSelectionTap(sender: UIButton) {
        let screenerSelectionVC = ScreenerSelectionContainerView(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(screenerSelectionVC, animated: true)
    }
}

