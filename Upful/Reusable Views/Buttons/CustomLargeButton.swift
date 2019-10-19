//
//  CustomLargeButton.swift
//  Upful
//
//  Created by Yanik Simpson on 8/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    let gradientLayer = CAGradientLayer()
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 40)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.95, alpha: 0.97)
        setTitleColor(.appAccent3, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    

}











