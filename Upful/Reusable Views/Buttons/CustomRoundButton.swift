//
//  CustomRoundButton.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CustomRoundButton: UIButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 55, height: 55)
    }
    var buttonColor: UIColor {
        return UIColor(red: 243/255, green: 175/255, blue: 34/255, alpha: 0.75)
    }
    
    var radius: CGFloat {
        return intrinsicContentSize.height / 2
    }
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        backgroundColor = buttonColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SmallRoundButton: CustomButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .appAccent3
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

