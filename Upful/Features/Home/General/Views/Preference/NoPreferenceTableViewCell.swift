//
//  NoPreferenceTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/31/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NoPreferenceTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Set up your preferences to start getting recommendations."
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .appAccent
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                                padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(top: topAnchor, leading: leadingAnchor,
                                     bottom: bottomAnchor, trailing: trailingAnchor,
                                     padding: .init(top: 8, left: 12, bottom: 8, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
