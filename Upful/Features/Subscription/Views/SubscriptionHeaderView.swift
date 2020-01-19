//
//  SubscriptionDescriptionView.swift
//  Upful
//
//  Created by Yanik Simpson on 1/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionHeaderView: UIView {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 200)
    }
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "revenueGraph")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 300),
            v.widthAnchor.constraint(equalToConstant: 225)
        ])
        return v
    }()
    
    private let headerLabel: UILabel = {
        let l = UILabel()
        l.text = "Subscribe To Premium"
        l.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .center
        return l
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnlimitedScreeningStackView()
        setupUnlimitedSavingStackView()
        setupStopTrackingStackView()
        setupIndieDeveloperStackView()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupUnlimitedScreeningStackView() {
        let atString1 = NSMutableAttributedString(string: "Unlimited screening 🔍")
        
        contentStackView.addArrangedSubview(makeStackView(with: atString1))
    }
    
    fileprivate func setupUnlimitedSavingStackView() {
        let atString2 = NSMutableAttributedString(string: "Save unlimited stocks and screeners ")
        let heartAttachment = NSTextAttachment()
        let heartImage = UIImage(systemName: "heart.fill")?
                        .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
                        .resizeImage(22, opaque: false)
        heartAttachment.image = heartImage
        let heartString = NSAttributedString(attachment: heartAttachment)
        atString2.append(heartString)
        
        contentStackView.addArrangedSubview(makeStackView(with: atString2))
    }
    
    fileprivate func setupStopTrackingStackView() {
        let atString3 = NSMutableAttributedString(string: "Stop tracking! 🔦")
        
        contentStackView.addArrangedSubview(makeStackView(with: atString3))
    }
    
    fileprivate func setupIndieDeveloperStackView() {
        let indieString = NSMutableAttributedString(string: "Support an Indie Developer! 🧔🏾\n")
        let restOfIndieString = NSMutableAttributedString(string: "Hi, I'm Yanik. I developed this app to...\n\nSubscribing will help support ongoing development...")
        
//        let yanikImageAttachment = NSTextAttachment()
//        let yanikImage = UIImage(named: "yanik-memoji")?.resizeImage(22, opaque: false)
//        yanikImageAttachment.image = yanikImage
//        let imageString = NSAttributedString(attachment: yanikImageAttachment)
//        indieString.append(imageString)
        indieString.append(restOfIndieString)
        
        contentStackView.addArrangedSubview(makeStackView(with: indieString))
    }
    
    fileprivate func setupContentView() {
        addSubview(imageView)
         NSLayoutConstraint.activate([
             imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
             imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
         ])
        
         addSubview(contentStackView)
         NSLayoutConstraint.activate([
             contentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
             contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
             contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
             contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
         ])
    }
    
    // MARK: - Helper Functions
    
    fileprivate func makeStackView(with description: NSMutableAttributedString) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")?
                                .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .gray
        descriptionLabel.attributedText = description
        descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
        stackView.alignment = .leading
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }
}

