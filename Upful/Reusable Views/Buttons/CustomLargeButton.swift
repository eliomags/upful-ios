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
        backgroundColor = UIColor(white: 0.5, alpha: 0.9)
        setTitleColor(.appAccent, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.masksToBounds = true
    }
    
    private func setupGradient() {
        gradientLayer.colors = [UIColor.negative.cgColor, UIColor.appAccent.cgColor]
        //            gradientLayer.locations = [0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}











