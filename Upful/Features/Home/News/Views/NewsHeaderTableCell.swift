//
//  NewsHeaderTableCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/26/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NewsHeaderTableCell: GenericNewsCell {

    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel])
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    

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
        sentimentView.anchor(top: nil,
                                leading: nil,
                                bottom: bottomAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 8, right: 16))
        
        addSubview(detailStackView)
        detailStackView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: .init(top: 12, left: 16, bottom: 0, right: 0))
            
        addSubview(contentStackView)
        contentStackView.anchor(top: detailStackView.bottomAnchor,
                                leading: leadingAnchor,
                                bottom: nil,
                                trailing: trailingAnchor,
                                padding: .init(top: 8, left: 16, bottom: 10, right: 16))
        
        addSubview(articleImageView)
        articleImageView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        articleImageView.bottomAnchor.constraint(equalTo: sentimentView.topAnchor, constant: -8).isActive = true

    }
    
}

