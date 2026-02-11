//
//  SubcriptionFooterView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionFooterView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 150)
    }
    
    // MARK: - Views
    
    let subscribeButton: LargeGradientButton = {
        let button = LargeGradientButton(type: .system)
        button.setTitle("Start 7-Day Trial", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 45/2
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchase", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    lazy var signUpButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restoreButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let legalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Payment will be charged to your Apple ID account at the confirmation of purchase. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase."
        return label
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.appAccent3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return button
    }()
    
    let termsOfUseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Terms of Use", for: .normal)
        button.setTitleColor(.appAccent3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return button
    }()
    
    lazy var legalButtonStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [privacyButton,termsOfUseButton])
        stackview.spacing = 8
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signUpButtonStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ThemeManager.mainContainerBackground()
        addSubview(contentStackView)
        contentStackView.anchor(top: topAnchor, leading: leadingAnchor,
                                bottom: nil, trailing: trailingAnchor,
                                padding: .init(top: 24, left: 0, bottom: 0, right: 0))
//        subscribeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
//        subscribeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        restoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true

        addSubview(legalButtonStackView)
        legalButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        legalButtonStackView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor).isActive = true
        legalButtonStackView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


