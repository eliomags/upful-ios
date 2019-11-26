//
//  LargeGradientButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class LargeGradientButton: CustomButton {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.2388166206, green: 0.6182424726, blue: 0.8588109212, alpha: 1))
    }
    
    func setupGradient(color1: UIColor, color2: UIColor) {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        //            gradientLayer.locations = [0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override var isSelected: Bool {
        didSet {
            isHighlighted ? highlightAnimation(): unhighlightAnimation()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? highlightAnimation(): unhighlightAnimation()
        }
    }
    
    private func highlightAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    private func unhighlightAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
}
