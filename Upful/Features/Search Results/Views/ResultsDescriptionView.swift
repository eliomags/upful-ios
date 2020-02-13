//
//  ResultsDescriptionView.swift
//  Upful
//
//  Created by Yanik Simpson on 2/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ResultsDescriptionView: UIView {
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 165)
    }
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Some Title"
        l.textColor = .label
        l.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Some Description"
        l.textColor = .label
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.numberOfLines = 4
        return l
    }()
    
    fileprivate lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.isBaselineRelativeArrangement = true
        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 16
        sv.distribution = .fill
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "pencil")?
            .withAlignmentRectInsets(.init(top: -6, left: -6, bottom: -6, right: -6))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var imageViewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .appAccent3
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 55).isActive = true
        v.widthAnchor.constraint(equalToConstant: 55).isActive = true
        v.addSubview(imageView)
        imageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        v.layer.cornerRadius = 55/2
        v.layer.masksToBounds = true
        return v
    }()
    
    fileprivate lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = VersionManager.collectionCellColor()
        v.addSubview(imageViewBackground)
        imageViewBackground.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imageViewBackground.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -12).isActive = true
        
        v.addSubview(contentStackView)
        contentStackView.anchor(top: v.topAnchor, leading: v.leadingAnchor,
                                bottom: v.bottomAnchor, trailing: imageView.leadingAnchor,
                                padding: .init(top: 22, left: 22, bottom: 16, right: 12))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 6
        v.setupShadow(intensity: .light, color: .label)
        return v
    }()
    
    // MARK: - Initialier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDescriptionViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
        
    fileprivate func setupDescriptionViews() {
        addSubview(contentView)
        contentView.fillSuperview(padding: .init(top: 20, left: 16, bottom: 8, right: 16))
    }
}
