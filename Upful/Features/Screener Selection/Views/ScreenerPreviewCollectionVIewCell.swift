//
//  ScreenerPreviewCollectionVIewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 1/2/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ScreenerPreviewCollectionViewCell: UICollectionViewCell {
    
//    var screenerItem: Screener? {
//        didSet {
//            print(screenerItem?.imageData)
//
//        }
//    }
    
    
    // MARK: - Views

    let screenerImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "chart.bar.fill")
        v.backgroundColor = .systemTeal
        return v
    }()
    
    let saveButton: SaveButton = {
        let v = SaveButton()
        return v
    }()
    
    lazy var menuView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.75
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Setup
    
    fileprivate func setupViews() {
        addSubview(screenerImage)
        screenerImage.fillSuperview()
        
        addSubview(menuView)
        menuView.anchor(top: nil,
                        leading: leadingAnchor,
                        bottom: bottomAnchor,
                        trailing: trailingAnchor)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil,
                          leading: nil,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 8, right: 8))
    }
}
