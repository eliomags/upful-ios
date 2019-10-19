//
//  UIColor+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit



private struct Pallete {
    static var gray: UIColor {
        return #colorLiteral(red: 0.9308954832, green: 0.9308954832, blue: 0.9308954832, alpha: 1)
    }
    static var green: UIColor {
//        return #colorLiteral(red: 0.1770295799, green: 0.6907966137, blue: 0.4686983228, alpha: 1)
        return #colorLiteral(red: 0.0116204666, green: 0.6127878428, blue: 0.6295601726, alpha: 1)
    }
    static var red: UIColor {
        return #colorLiteral(red: 1, green: 0.1438041242, blue: 0.133959256, alpha: 1)
    }
    static var lightGray: UIColor {
        return .lightGray
    }
    static var deepGreen: UIColor {
        return #colorLiteral(red: 0.01176470588, green: 0.6117647059, blue: 0.631372549, alpha: 1)
    }
    static var deepBlue: UIColor {
        return #colorLiteral(red: 0.006215432659, green: 0.001057554386, blue: 0.2019402385, alpha: 1)
    }
    static var darkBlue: UIColor {
        return #colorLiteral(red: 0.1420197487, green: 0.2013853192, blue: 0.3809607923, alpha: 1)
    }
    static var yellow: UIColor {
        return #colorLiteral(red: 0.9522877336, green: 0.6878936887, blue: 0.1339971721, alpha: 1)
    }
    static var darkGreen: UIColor {
        return #colorLiteral(red: 0.1058823529, green: 0.2078431373, blue: 0.1529411765, alpha: 1)
    }
}

extension UIColor {
    
    static var backgroundColor: UIColor {
        return Pallete.gray
    }
    
    static var secondaryBackground: UIColor {
        return Pallete.darkBlue
    }
    
    static var positive: UIColor {
        return Pallete.green
    }
    
    static var negative: UIColor {
        return .systemRed
    }
    
    static var secondaryText: UIColor {
        return Pallete.deepGreen
    }
    
    static var tertiaryText: UIColor {
        return .lightText
    }
    
    static var appAccent: UIColor {
        return Pallete.yellow
    }
    
    static var appAccent2: UIColor {
        return Pallete.yellow
    }
    
    static var appAccent3: UIColor {
        return Pallete.deepGreen
    }
    static var darkGreen: UIColor {
        return Pallete.darkGreen
    }
}









