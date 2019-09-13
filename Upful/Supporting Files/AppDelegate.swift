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
        let homeVC = HomeFeedContainer(collectionViewLayout: UICollectionViewFlowLayout())
        let searchVC = StockSearchViewController(networkingAPI: IntrinioAPI())
        let controllers = [homeVC,searchVC]
        homeVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "icons8-home-page-30"), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "icons8-search-30"), tag: 1)
        
        let tabVC = UITabBarController()
        tabVC.tabBar.tintColor = .appAccent        
        tabVC.tabBar.barTintColor = .backgroundColor
        tabVC.viewControllers = controllers.map({
            let navVC = UINavigationController(rootViewController: $0)
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.tintColor = .black
            navVC.navigationBar.backgroundColor = .white
            navVC.navigationBar.barTintColor = .white
            if #available(iOS 11.0, *) { navVC.navigationBar.prefersLargeTitles = true }
            navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
            
            return navVC
        })
        return tabVC
    }

}

