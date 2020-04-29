//
//  GeneralEmptyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GeneralEmptyCell: UITableViewCell {
    
    var emptyImage: UIImage {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        let im = UIImage(systemName: "tray.fill", withConfiguration: largeConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            ?? UIImage()
        return im
    }
        
    var emptyHeaderText: String {
        return String()
    }
     
    var emptyDescriptionText: String {
        return String()
    }
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: emptyImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = emptyHeaderText
        label.textColor = .label
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = emptyDescriptionText
        label.textColor = .lightGray
        return label
    }()
    
    private let contentBackground: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 16
        v.backgroundColor = VersionManager.collectionCellColor()
        return v
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupImageView()
        setupContentView()
        setupContentStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupImageView() {
        addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.heightAnchor.constraint(equalToConstant: 250),
            cellImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 50),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }

    fileprivate func setupContentView() {
        addSubview(contentBackground)
        NSLayoutConstraint.activate([
            contentBackground.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 24),
            contentBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            contentBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            contentBackground.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -100)
        ])
    }
    
    fileprivate func setupContentStackView() {
        contentBackground.addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
}


