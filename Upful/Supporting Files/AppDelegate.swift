//
//  AppDelegate.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//
// import Firebase // REMOVED: Firebase removed during rebuild
// import FirebaseDynamicLinks // REMOVED: Firebase removed during rebuild
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
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if let incomingURL = userActivity.webpageURL {
//            print("incoming URL ::", incomingURL)
//            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
//                if let error = error {
//                    print("link handling error:", error.localizedDescription)
//                }
//
//                if let dynamicLink = dynamicLink {
//                    print("dynamic link", dynamicLink.url)
//                    UpfulDeepLinkManager.route(from: self.coordinator?.homeVC, incomingURL: dynamicLink.url!)
//                } else {
//                    UpfulDeepLinkManager.route(from: self.coordinator?.homeVC, incomingURL: incomingURL)
//                }
//            }
//
//            return true
//        }
//
//        return false
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
//           let dynamicLinkURL = dynamicLink.url {
//            print("dynamic link URL", dynamicLink.url)
//            UpfulDeepLinkManager.route(from: self.coordinator?.homeVC, incomingURL: dynamicLinkURL)
//        }
//
//        return true
//    }
}
