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
        let sv = UIStackView(arrangedSubviews: [titleLabel, articleImageView])
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
        articleImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        addSubview(sentimentView)
        sentimentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        sentimentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(detailStackView)
            detailStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
            detailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            
        addSubview(contentStackView)
        contentStackView.anchor(top: detailStackView.bottomAnchor,
                                leading: leadingAnchor,
                                bottom: sentimentView.topAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 8, left: 16, bottom: 6, right: 16))
    }
    
}
