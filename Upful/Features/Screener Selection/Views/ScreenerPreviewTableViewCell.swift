//
//  ScreenerPreviewCollectionVIewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 1/2/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ScreenerPreviewTableViewCell: SavedScreenerTableViewCell {
    
    // MARK: - Views
    
    private var imageIcon: UIImage = UIImage(systemName: "magnifyingglass.circle.fill")?
        .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
        .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: imageIcon)
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var iconImageViewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .appAccent3
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v.addSubview(iconImageView)
        iconImageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        v.layer.cornerRadius = 40/2
        v.layer.masksToBounds = true
        return v
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        titleLabel.text = ""
    }
        
    override func setupViews() {
        addSubview(iconImageViewBackground)
        iconImageViewBackground
            .setLeadingAnchor(padding: 16)
            .setCenterYAnchor(padding: 0)
        addSubview(textStackView)
        textStackView
            .setTopAnchor(padding: 12)
            .setLeadingAnchor(relativeTo: iconImageViewBackground, padding: 16)
            .setTrailingAnchor(padding: 26)
            .setBottomAnchor(padding: 12)
    }

    private func showLoading() {
        titleLabel.backgroundColor = VersionManager.loadingLabelColor()
        descriptionLabel.backgroundColor = VersionManager.loadingLabelColor()
    }
    
    func showLoaded() {
        titleLabel.backgroundColor = .clear
        descriptionLabel.backgroundColor = .clear
    }
}
