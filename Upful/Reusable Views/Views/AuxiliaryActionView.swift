//
//  AuxiliaryActionView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class AuxiliaryActionView: UIView {
    
    // MARK: - Views
    
    private(set) lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.backgroundColor = UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ?
                UIColor.secondarySystemGroupedBackground :
                UIColor.systemBackground
        }
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentBackgroundView)
        contentBackgroundView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        backgroundColor = UIColor.init { (trait) -> UIColor in
        return trait.userInterfaceStyle == .dark ?
            UIColor.systemBackground :
            UIColor.tertiarySystemGroupedBackground
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
}

