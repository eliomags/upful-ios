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
    
    static func buttonColor() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black: .white
        }
    }
    
    static func buttonColor2() -> UIColor {
        return .secondarySystemBackground
    }
        
    // MARK - Containers
    
    static func mainContainerBackground() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black: .white
        }
    }
    
    // MARK: - Cells
    
    static func collectionCellColor() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .secondarySystemGroupedBackground: .systemGroupedBackground
        }
    }
    
    static func collectionCellColor2() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black: .white
        }
    }
    
   // MARK: - Navigation Bar
   
   static func setNavigationBar(in view: UINavigationController?) {
        if let view = view {
            view.navigationBar.isTranslucent = false
            let color = UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .black: .white
            }
            view.navigationBar.backgroundColor = color
        }
    }
    
    static func navigationBarColor(in view: UINavigationController?) {
        if let view = view {
            let app = UINavigationBarAppearance()
            app.shadowImage = nil
            app.shadowColor = nil
            app.backgroundColor = UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .black: .white
            }
            view.navigationBar.standardAppearance = app
            view.navigationBar.scrollEdgeAppearance = app
        }
    }
    
    static func setTabBarColor(in view: UITabBarController?) {
        if let view = view {
            let app = UITabBarAppearance()
            let background = UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .black: .white
            }
            app.backgroundColor = background
            view.tabBar.standardAppearance = app
        }
    }
    
    // MARK: - Labels
    
    static func loadingLabelColor() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .secondarySystemBackground: UIColor(white: 0.92, alpha: 0.8)
        }
    }
    
    static func labelColor() -> UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white: .black
        }
    }
    
}





