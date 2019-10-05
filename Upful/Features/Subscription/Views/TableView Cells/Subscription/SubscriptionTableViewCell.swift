//
//  SubscriptionTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    // Duration
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "months"
        return label
    }()
    lazy var durationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [durationLabel,monthLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    // Pricing
    let monthlyPricingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    let dueNowPricingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .gray
        return label
    }()
    lazy var pricingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dueNowPricingLabel,monthlyPricingLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    // Savings
    let savingsValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    let saveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "savings"
        return label
    }()
    lazy var savingsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [savingsValueLabel,saveLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.addSubview(durationStackView)
        durationStackView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil,
            padding: .init(top: 12, left: 16, bottom: 12, right: 0))

        view.addSubview(pricingStackView)
        pricingStackView.translatesAutoresizingMaskIntoConstraints = false
        pricingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pricingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 8, left: 40, bottom: 8, right: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setSavingsViews() {
        contentBackgroundView.addSubview(savingsStackView)
        savingsStackView.anchor(
            top: contentBackgroundView.topAnchor, leading: nil, bottom: contentBackgroundView.bottomAnchor, trailing: contentBackgroundView.trailingAnchor,
            padding: .init(top: 12, left: 0, bottom: 12, right: 16))
    }
    
    
    // MARK: - Actions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.contentBackgroundView.backgroundColor = UIColor(red: 243/255, green: 175/255, blue: 34/255, alpha: 0.3)
                self.contentBackgroundView.layer.borderWidth = 1
                self.contentBackgroundView.layer.borderColor = UIColor.appAccent.cgColor
                
                if #available(iOS 13.0, *) {
                    self.durationLabel.textColor = .label
                    self.monthLabel.textColor = .label
                    self.dueNowPricingLabel.textColor = .label
                    self.monthlyPricingLabel.textColor = .label
                    self.savingsValueLabel.textColor = .label
                    self.saveLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                    self.durationLabel.textColor = .black
                    self.monthLabel.textColor = .black
                    self.dueNowPricingLabel.textColor = .black
                    self.monthlyPricingLabel.textColor = .black
                    self.savingsValueLabel.textColor = .black
                    self.saveLabel.textColor = .black
                }
            }
        }
        if !selected {
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
                self.contentBackgroundView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                self.contentBackgroundView.layer.borderWidth = 0
                self.durationLabel.textColor = .gray
                self.monthLabel.textColor = .gray
                self.dueNowPricingLabel.textColor = .gray
                self.monthlyPricingLabel.textColor = .gray
                self.savingsValueLabel.textColor = .gray
                self.saveLabel.textColor = .gray
            }
        }
    }

}
