//
//  ActionView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class InformationView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 230, height: 230)
    }
            
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    fileprivate let blurredEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let v = UIVisualEffectView(effect: blurEffect)
        return v
    }()
    
    lazy var actionImageView: UIImageView = {
        let imageView = UIImageView()
        let constant: CGFloat = 130
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.layer.cornerRadius = constant/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var actionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [actionImageView,descriptionLabel])
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(actionStackView)
        actionStackView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor,
                               padding: .init(top: 8, left: 8, bottom: 8, right: 8)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurredEffectView.frame = bounds
    }
    
}
