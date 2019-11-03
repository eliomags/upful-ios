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
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                selectedSegmentTintColor = .black
                backgroundColor = .secondarySystemBackground
            }
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                       NSAttributedString.Key.foregroundColor: UIColor.appAccent3
                ], for: .selected)
        } else {
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                           NSAttributedString.Key.foregroundColor: UIColor.gray
                   ], for: .normal)
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                              NSAttributedString.Key.foregroundColor: UIColor.black
                    ], for: .selected)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
