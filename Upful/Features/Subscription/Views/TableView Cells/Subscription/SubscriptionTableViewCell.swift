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
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12.5
        return iv
    }()

    let monthlyPricingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
        
    private let freeTrialView: UIView = {
        let v = UIView()
        let label = UILabel()
        label.text = "Free Trial"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        v.addSubview(label)
        label.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        v.backgroundColor = UIColor.appAccent3.withAlphaComponent(0.9)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 20).isActive = true
        v.widthAnchor.constraint(equalToConstant: 70).isActive = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8
        return v
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appAccent3.withAlphaComponent(0.4)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addSubview(freeTrialView)
        freeTrialView.anchor(top: nil, leading: nil,
                             bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                             padding: .init(top: 18, left: 18, bottom: 16, right: 18))
        view.addSubview(selectionStateView)
        
        selectionStateView.anchor(top: nil, leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor, trailing: nil,
                                  padding: .init(top: 12, left: 16, bottom: 12, right: 0))
        view.addSubview(monthlyPricingLabel)
        monthlyPricingLabel.anchor(top: view.topAnchor, leading: selectionStateView.trailingAnchor,
                                   bottom: view.bottomAnchor, trailing: freeTrialView.leadingAnchor,
                                   padding: .init(top: 16, left: 16, bottom: 16, right: 0))
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
        self.selectionStateView.image = nil
    }
        
    // MARK: - Actions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.monthlyPricingLabel.textColor = .label
                self.selectionStateView.image = self.selectedStateImage
            }
        }
        if !selected {
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
                self.monthlyPricingLabel.textColor = .gray
                self.selectionStateView.image = nil
            }
        }
    }

}
