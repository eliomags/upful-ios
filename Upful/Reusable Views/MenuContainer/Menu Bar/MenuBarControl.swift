//
//  MenuBarControl.swift
//  Upful
//
//  Created by Yanik Simpson on 9/16/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class MenuBarControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                       NSAttributedString.Key.foregroundColor: UIColor.appAccent3
                ], for: .selected)
        selectedSegmentTintColor = UIColor.init { (trait) in
            return trait.userInterfaceStyle == .dark ? .black: .white
        }
        
        backgroundColor = UIColor.init { (trait) in
            return trait.userInterfaceStyle == .dark ? .secondarySystemBackground: .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
