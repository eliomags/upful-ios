//
//  SubscriptionTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    func configure(with product: UpfulProductViewModel) {
        monthlyPricingLabel.text = product.description
    }
        
    private let monthlyPricingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appAccent3
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        view.addSubview(monthlyPricingLabel)
        monthlyPricingLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                                   padding: .init(top: 5, left: 8, bottom: 5, right: 8))
        return view
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(top: topAnchor, leading: layoutMarginsGuide.leadingAnchor,
                                     bottom: bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor,
                                     padding: .init(top: 14, left: 24, bottom: 14, right: 24),
                                     size: .init(width: 0, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
