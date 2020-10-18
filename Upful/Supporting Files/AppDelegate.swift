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
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(presenter: navigationController)
        coordinator?.start()
        
        window = UIWindow()
        window?.rootViewController = coordinator?.presenter
        window?.backgroundColor = .systemBackground

        FirebaseApp.configure()
        
        Mixpanel.initialize(token: Constants.MixPanel.token)
        Mixpanel.mainInstance().userId = UserProfile.instance.profileID
        
        IAPService().completeTransactions()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
