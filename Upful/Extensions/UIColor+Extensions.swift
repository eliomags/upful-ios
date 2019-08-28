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
        return #colorLiteral(red: 0.1770295799, green: 0.6907966137, blue: 0.4686983228, alpha: 1)
    }
    static var red: UIColor {
        return #colorLiteral(red: 1, green: 0.1747880578, blue: 0.2384961247, alpha: 1)
    }
    static var lightGray: UIColor {
        return .lightGray
    }
    static var deepGreen: UIColor {
        return #colorLiteral(red: 0.0005233361735, green: 0.6547558904, blue: 0.6137979031, alpha: 1)
    }
    static var darkBlue: UIColor {
        return #colorLiteral(red: 0.1420197487, green: 0.2013853192, blue: 0.3809607923, alpha: 1)
    }
    static var yellow: UIColor {
        return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
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
        return Pallete.red
    }
    
    static var secondaryText: UIColor {
        return Pallete.deepGreen
    }
    
    static var tertiaryText: UIColor {
        return Pallete.lightGray
    }
    
    static var appAccent: UIColor {
        return Pallete.yellow
    }
}









