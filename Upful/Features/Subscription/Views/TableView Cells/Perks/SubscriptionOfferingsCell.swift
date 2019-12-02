//
//  SubscriptionOfferingsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 10/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionOfferingCell: UICollectionViewCell {
    
    let offeringImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(offeringImageView)
        offeringImageView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.setupShadow(intensity: .medium, color: .black)
        return view
    }()
    
    let offeringTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Unlimited Saving"
        return label
    }()
    
    let offeringDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Save as many screeners and stocks as you wish"
        return label
    }()
    
    lazy var offeringdDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [offeringTitleLabel, offeringDescriptionLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageBackgroundView)
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -35).isActive = true
        
        addSubview(offeringdDescriptionStackView)
        offeringdDescriptionStackView.anchor(top: imageBackgroundView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                                             padding: .init(top: 16, left: 16, bottom: 8, right: 16))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
