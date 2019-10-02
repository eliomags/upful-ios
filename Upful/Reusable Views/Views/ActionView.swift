//
//  ActionView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ActionView: UIView, Animatable {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 45)
    }
    
    let animation = Animator()
    
    var actionImage: UIImage {
        return #imageLiteral(resourceName: "icons8-checkmark").withRenderingMode(.alwaysOriginal)
    }
    
    
    lazy var actionImageView: SmallImageView = {
        let imageView = SmallImageView(image: actionImage)
        let constant: CGFloat = 20
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.layer.cornerRadius = constant/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var actionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [actionImageView,descriptionLabel])
        sv.axis = .horizontal
        sv.spacing = 22
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 243/255, green: 175/255, blue: 34/255, alpha: 1)
        addSubview(actionStackView)
        actionStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        animation.displayAnimation(view: self)
    }
    
}
