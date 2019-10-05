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
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark { backgroundColor = .systemBackground }
            if traitCollection.userInterfaceStyle == .light { backgroundColor = .white }
        } else {
            backgroundColor = .white
        }
        
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                    NSAttributedString.Key.foregroundColor: UIColor.label
            ], for: .normal)
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                       NSAttributedString.Key.foregroundColor: UIColor.label
                ], for: .selected)
        } else {
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                           NSAttributedString.Key.foregroundColor: UIColor.black
                   ], for: .normal)
            setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                              NSAttributedString.Key.foregroundColor: UIColor.black
                    ], for: .selected)
        }
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = .clear
        }
        backgroundColor = .clear
        tintColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
