//
//  MainCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var viewController: UIViewController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func start() {
        viewController = initializeVC()
    }
    
    private func initializeVC() -> UIViewController {
        let homeVC = HomeContainerViewController()
        let exploreVC = ExploreViewController()
        let settingsVC = SettingsViewController()
        
        let controllers = [homeVC,exploreVC,settingsVC]
            
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0)
        exploreVC.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass",
                            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            tag: 1)
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear",
                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            tag: 2)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.tintColor = .appAccent3
        tabVC.tabBar.isTranslucent = true

        tabVC.viewControllers = controllers.map({
            let navVC = UINavigationController(rootViewController: $0)
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.tintColor = .appAccent3
            navVC.navigationBar.shadowImage = UIImage()
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
    
    private func setupTest() -> UIViewController {
        return RecommendationViewController()
    }
}
