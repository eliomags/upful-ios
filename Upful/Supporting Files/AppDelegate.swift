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
        window?.backgroundColor = .white

        FirebaseApp.configure()
        Mixpanel.initialize(token: Constants.MixPanel.token)
        IAPService().completeTransactions()

        window?.rootViewController = initializeVC()
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
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.tintColor = .appAccent3
            navVC.navigationBar.setValue(true, forKey: "hidesShadow")
            navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .heavy)]
            return navVC
        })
        return tabVC
    }

}

