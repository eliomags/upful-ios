//
//  AppDelegate.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Firebase
import Mixpanel
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = initializeVC()

        if #available(iOS 13.0, *) {
            if window?.rootViewController?.traitCollection.userInterfaceStyle == .dark {
                window?.backgroundColor = .black
            }
            if window?.rootViewController?.traitCollection.userInterfaceStyle == .light {
                window?.backgroundColor = .white
            }
        } else {
            window?.backgroundColor = .white
        }

        FirebaseApp.configure()
        Mixpanel.initialize(token: Constants.MixPanel.token)
        IAPService().completeTransactions()

        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func initializeVC() -> UIViewController {
        let homeVC = SaveViewController()
        let exploreVC = HomeFeedContainer(collectionViewLayout: UICollectionViewFlowLayout())
        let settingsVC = SettingsViewController(style: .grouped)
        
        let controllers = [homeVC,exploreVC,settingsVC]
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icons8-home-page-30"), tag: 0)
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: #imageLiteral(resourceName: "icons8-search-30"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "icons8-settings-25"), tag: 2)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.tintColor = .appAccent3
        tabVC.tabBar.isTranslucent = true

        tabVC.viewControllers = controllers.map({
            let navVC = UINavigationController(rootViewController: $0)
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.tintColor = .appAccent3
            navVC.navigationBar.setValue(true, forKey: "hidesShadow")
            if #available(iOS 13.0, *) {
                navVC.navigationBar.isTranslucent = true
                if navVC.traitCollection.userInterfaceStyle == .dark {
                    navVC.navigationBar.backgroundColor = .black
                }
                if navVC.traitCollection.userInterfaceStyle == .light {
                    navVC.navigationBar.backgroundColor = .white
                }
            } else {
                navVC.navigationBar.isTranslucent = false
                navVC.navigationBar.backgroundColor = .white
            }
            return navVC
        })
        VersionManager.setTabBarColor(in: tabVC)
        return tabVC
    }

}

