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
        .withAlignmentRectInsets(.init(top: -7, left: -7, bottom: -7, right: -7))
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
        v.heightAnchor.constraint(equalToConstant: 55).isActive = true
        v.widthAnchor.constraint(equalToConstant: 55).isActive = true
        v.addSubview(iconImageView)
        iconImageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        v.layer.cornerRadius = 55/2
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [textStackView, iconImageViewBackground])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fill
        return sv
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
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
        ])
        
        NSLayoutConstraint.activate([
            iconImageViewBackground.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
