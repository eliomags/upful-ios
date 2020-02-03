//
//  SubscriptionTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    // MARK: - Views

    let selectedStateImage = UIImage(systemName: "checkmark.circle.fill")?
                                    .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
    private let selectionStateView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12.5
        return iv
    }()
    
    private let oneWeekFreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "Try 1 week free."
        label.textColor = .white
        return label
    }()
    
    let monthlyPricingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var pricingStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [oneWeekFreeLabel, monthlyPricingLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appAccent3
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.addSubview(pricingStackView)
        pricingStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                                padding: .init(top: 10, left: 16, bottom: 10, right: 16))
        return view
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(top: topAnchor, leading: leadingAnchor,
                                     bottom: bottomAnchor, trailing: trailingAnchor,
                                     padding: .init(top: 14, left: 24, bottom: 14, right: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
