//
//  SmallNewsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SmallNewsCell: GenericNewsCell {
        
    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupViews() {
        addSubview(sentimentView)
        sentimentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        sentimentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(detailStackView)
        detailStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        detailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        addSubview(articleImageView)
        articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        articleImageView.topAnchor.constraint(equalTo: detailStackView.bottomAnchor, constant: 8).isActive = true
        articleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        addSubview(textContextStackView)
        textContextStackView.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12).isActive = true
        textContextStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        textContextStackView.topAnchor.constraint(equalTo: articleImageView.topAnchor).isActive = true
        textContextStackView.bottomAnchor.constraint(equalTo: sentimentView.topAnchor, constant: -6).isActive = true
    }
}

