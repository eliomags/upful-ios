//
//  CancelButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/16/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CancelButton: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray3
        heightAnchor.constraint(equalToConstant: 28).isActive = true
        widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 5, weight: .bold)
        let xImage = UIImage(systemName: "xmark", withConfiguration: smallConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
        
        let cancelImageView = UIImageView(image: xImage)
        cancelImageView.backgroundColor = .clear
        
        addSubview(cancelImageView)
        cancelImageView.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 7, left: 7, bottom: 7, right: 7))
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}
