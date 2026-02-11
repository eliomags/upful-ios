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
    
    var imageIcon: UIImage = UIImage(systemName: "pencil")?
        .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
        .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: imageIcon)
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var imageViewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .appAccent3
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 45).isActive = true
        v.widthAnchor.constraint(equalToConstant: 45).isActive = true
        v.addSubview(imageView)
        imageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        v.layer.cornerRadius = 45/2
        v.layer.masksToBounds = true
        return v
    }()
    
    fileprivate lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = ThemeManager.collectionCellColor()
        v.addSubview(imageViewBackground)
        imageViewBackground
            .setCenterYAnchor(padding: 0)
            .setLeadingAnchor(padding: 16)
        v.addSubview(contentStackView)
        contentStackView
            .setTopAnchor(padding: 22)
            .setLeadingAnchor(relativeTo: imageViewBackground, padding: 16)
            .setBottomAnchor(padding: 16)
            .setTrailingAnchor(padding: 16)
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
