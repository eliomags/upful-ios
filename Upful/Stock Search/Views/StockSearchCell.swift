//
//  StockSearchCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class StockSearchCell: UITableViewCell {
    
    let companyTickerLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        return l
    }()
    let companyNameLabel: UILabel = {
        let l = UILabel()
        l.font = .details2
        return l
    }()
    lazy var companyDescriptionStackView: UIStackView = {
        let l = UIStackView(arrangedSubviews: [companyTickerLabel,companyNameLabel])
        l.axis = .vertical
        l.spacing = 3
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        addSubview(companyDescriptionStackView)
        companyDescriptionStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 12, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


