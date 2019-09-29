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
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Mixpanel.initialize(token: Constants.MixPanel.token)
        
        window?.rootViewController = initializeVC()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func initializeVC() -> UIViewController {
        let homeVC = SaveViewController(style: .grouped)
        let exploreVC = HomeFeedContainer(collectionViewLayout: UICollectionViewFlowLayout())
        let settingsVC = SettingsViewController()
        
        let controllers = [homeVC,exploreVC,settingsVC]
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icons8-home-page-30"), tag: 0)
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: #imageLiteral(resourceName: "icons8-search-30"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "icons8-settings-25"), tag: 2)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.tintColor = .appAccent        
        tabVC.tabBar.barTintColor = .backgroundColor
        
        tabVC.viewControllers = controllers.map({
            let navVC = UINavigationController(rootViewController: $0)
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.tintColor = .appAccent
            navVC.navigationBar.backgroundColor = .white
            navVC.navigationBar.barTintColor = .white
            navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .heavy)]
            return navVC
        })
        
        return tabVC
    }

}

