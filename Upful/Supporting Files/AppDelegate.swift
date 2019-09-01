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
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Mixpanel.initialize(token: "4c98f5b13d5d0f1371814a91f6738335")
        
        window?.rootViewController = initializeVC()
        window?.makeKeyAndVisible()
        
        return true
    }

    private func initializeVC() -> UIViewController {
        
        let homeVC = HomeFeedViewController(analyitcs: AnalyticsLogger())
        let settingsVC = UIViewController()
        let searchVC = StockSearchViewController(networkingAPI: IntrinioAPI())
        let controllers = [homeVC,searchVC, settingsVC]
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "icons8-home-page-30"), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "icons8-search-30"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "icons8-settings-30"), tag: 2)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.tintColor = .appAccent

        //        tabVC.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2691890967)
        tabVC.tabBar.barTintColor = .backgroundColor
        tabVC.viewControllers = controllers.map({ UINavigationController(rootViewController: $0)})
        return tabVC
    }

}

