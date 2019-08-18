//
//  UIFont+Exteions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var sectionHeader: UIFont {
//        return UIFont(name: "AvenirNext-Bold", size: 16) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        return UIFont.systemFont(ofSize: 13, weight: .heavy)

    }
    
    static var viewHeader: UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .bold)
    }
}









