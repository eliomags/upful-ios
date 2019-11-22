//
//  ColorManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/31/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct VersionManager {
    
    // MARK: - Components
    
    static func buttonColor(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .black }
            if UITraitCollection.current.userInterfaceStyle == .light { return .white }
        }
        return .white
    }
    
    static func buttonColor2(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .secondarySystemBackground }
            if UITraitCollection.current.userInterfaceStyle == .light { return .secondarySystemBackground }
        }
        return .darkGray
    }
        
    // MARK - Containers
    
    static func mainContainerBackground(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .black }
            if UITraitCollection.current.userInterfaceStyle == .light { return .white }
        } 
        return .white
    }
    
    
    // MARK: - Cells
    
    static func collectionCellColor(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .secondarySystemGroupedBackground }
            if UITraitCollection.current.userInterfaceStyle == .light { return .systemGroupedBackground }
        }
        return .systemGroupedBackground
    }
    
    static func collectionCellColor2(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .black }
            if UITraitCollection.current.userInterfaceStyle == .light { return .white }
        }
        return .white
    }
    
   // MARK: - Navigation Bar
   
   static func setNavigationBar(in view: UINavigationController?) {
        if let view = view {
            if #available(iOS 13.0, *) {
             view.navigationBar.isTranslucent = false
                if UITraitCollection.current.userInterfaceStyle == .dark {
                     view.navigationBar.backgroundColor = .black
                 }
                if UITraitCollection.current.userInterfaceStyle == .light {
                     view.navigationBar.backgroundColor = .white
                 }
            } else {
                 view.navigationBar.isTranslucent = false
                 view.navigationBar.backgroundColor = .white
            }
        }
    }
    
    static func navigationBarColor(in view: UINavigationController?) {
        if let view = view {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    let app = UINavigationBarAppearance()
                    app.backgroundColor = .black
                    view.navigationBar.standardAppearance = app
                    view.navigationBar.scrollEdgeAppearance = app
                }
                if UITraitCollection.current.userInterfaceStyle == .light {
                    let app = UINavigationBarAppearance()
                    app.backgroundColor = .white
                    view.navigationBar.standardAppearance = app
                    view.navigationBar.scrollEdgeAppearance = app
                }
            } else {
                view.navigationBar.backgroundColor = .white
            }
        }
    }
    
    static func setTabBarColor(in view: UITabBarController?) {
        if let view = view {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    let app = UITabBarAppearance()
                    app.backgroundColor = .black
                    view.tabBar.standardAppearance = app
                }
                if UITraitCollection.current.userInterfaceStyle == .light {
                    let app = UITabBarAppearance()
                    app.backgroundColor = .white
                    view.tabBar.standardAppearance = app
                }
            } else {
                view.tabBar.backgroundColor = .white
            }
        }
    }
    
    // MARK: - Labels
    
    static func loadingLabelColor(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return .secondarySystemBackground
            }
            if UITraitCollection.current.userInterfaceStyle == .light {
                return UIColor(white: 0.92, alpha: 0.8)
            }
        }
        return UIColor(white: 0.92, alpha: 0.8)
    }
    
    static func labelColor(in view: UITraitEnvironment) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark { return .white }
            if UITraitCollection.current.userInterfaceStyle == .light { return .black }
        }
        return .black
    }
    
}





