//
//  LargeGradientButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class LargeGradientButton: CustomButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appAccent3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
