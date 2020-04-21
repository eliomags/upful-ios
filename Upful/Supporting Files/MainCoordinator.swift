//
//  MainCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var presenter: UIViewController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {
    var presenter: UIViewController
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func start() {
        presenter = initializeVC()
    }
    
    private func initializeVC() -> UIViewController {
        let homeVC = HomeGeneralViewController()
        let exploreVC = ExploreViewController()
        let saveVC = SavedViewController()
        let settingsVC = SettingsViewController()
        
        let controllers = [homeVC,exploreVC,saveVC,settingsVC]
            
        homeVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house.fill"),
            tag: 0)
        
        exploreVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "magnifyingglass",
                            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            tag: 1)
        
        saveVC.tabBarItem = UITabBarItem(title: "",
            image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            selectedImage: UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)))
        
        settingsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "gear",
                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            tag: 2)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.isTranslucent = true
        if tabVC.traitCollection.userInterfaceStyle == .dark {
            tabVC.tabBar.tintColor = .label
        }
        if tabVC.traitCollection.userInterfaceStyle == .light {
            tabVC.tabBar.tintColor = .label
        }
        
        tabVC.viewControllers = controllers.map({
            let navVC = UINavigationController(rootViewController: $0)
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.shadowImage = UIImage()
            navVC.navigationBar.tintColor = .label

            if navVC.traitCollection.userInterfaceStyle == .dark {
                navVC.navigationBar.backgroundColor = .black
            }
            if navVC.traitCollection.userInterfaceStyle == .light {
                navVC.navigationBar.backgroundColor = .white
            }
            return navVC
        })
        VersionManager.setTabBarColor(in: tabVC)
        return tabVC
    }
}
