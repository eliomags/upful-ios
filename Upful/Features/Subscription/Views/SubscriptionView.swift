//
//  SubscriptionDescriptionView.swift
//  Upful
//
//  Created by Yanik Simpson on 1/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionView: UIView {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 220)
    }
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "revenueGraph")
        v.translatesAutoresizingMaskIntoConstraints = false
        let height = (UIScreen.main.bounds.height / 4) - 50
        
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: height),
            v.widthAnchor.constraint(equalToConstant: (height * 0.8))
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
    
    private lazy var indieIntroductionView: UIView = {
        let attributedString = NSMutableAttributedString(string: "Hi, I'm Yanik!")
        let restOfIndieString = NSMutableAttributedString(string: "\nI developed this app to help me find stocks to invest in.\n\nSubscribing helps to support this app's ongoing development!")

        let yanikImageAttachment = NSTextAttachment()
        let yanikImage = UIImage(named: "yanik-memoji")?.resizeImage(37, opaque: false)
        yanikImageAttachment.image = yanikImage
        let imageString = NSAttributedString(attachment: yanikImageAttachment)
        
        attributedString.append(imageString)
        attributedString.append(restOfIndieString)
        
        let v = makeBlurbTextView(with: attributedString)
        return v
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnlimitedScreeningStackView()
        setupUnlimitedSavingStackView()
        setupGetFiveYearData()
        setupIndieDeveloperStackView()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupUnlimitedScreeningStackView() {
        let attributedString = NSMutableAttributedString(string: "Unlimited stock screening ")
        let chartImageAttachment = NSTextAttachment()
        let barChartImage = UIImage(systemName: "magnifyingglass")?
                        .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
                        .resizeImage(22, opaque: false)
        chartImageAttachment.image = barChartImage
        
        let chartString = NSAttributedString(attachment: chartImageAttachment)
        attributedString.append(chartString)
        
        contentStackView.addArrangedSubview(makeStackView(with: attributedString))
    }
    
    fileprivate func setupUnlimitedSavingStackView() {
        let attributedString = NSMutableAttributedString(string: "Save unlimited stocks and screeners ")
        let heartAttachment = NSTextAttachment()
        let heartImage = UIImage(systemName: "heart.fill")?
                        .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
                        .resizeImage(22, opaque: false)
        heartAttachment.image = heartImage
        
        let heartString = NSAttributedString(attachment: heartAttachment)
        attributedString.append(heartString)
        
        contentStackView.addArrangedSubview(makeStackView(with: attributedString))
    }
    
    fileprivate func setupGetFiveYearData() {
        let attributedString = NSMutableAttributedString(string: "Get 5 year analysis data ")
        let chartImageAttachment = NSTextAttachment()
        let barChartImage = UIImage(systemName: "chart.bar.fill")?
                        .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
                        .resizeImage(22, opaque: false)
        chartImageAttachment.image = barChartImage
        
        let chartString = NSAttributedString(attachment: chartImageAttachment)
        attributedString.append(chartString)
        
        contentStackView.addArrangedSubview(makeStackView(with: attributedString))
    }
    
    fileprivate func setupIndieDeveloperStackView() {
        let attributedString = NSMutableAttributedString(string: "Support an Indie Developer!")
        
        contentStackView.addArrangedSubview(makeStackView(with: attributedString))
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
             contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
             contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
         ])
        
        addSubview(indieIntroductionView)
        NSLayoutConstraint.activate([
            indieIntroductionView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 16),
            indieIntroductionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            indieIntroductionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            indieIntroductionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Helper Functions
    
    fileprivate func makeBlurbTextView(with description: NSMutableAttributedString) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.appAccent3.withAlphaComponent(0.1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = description
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        contentView.addSubview(label)
        label.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        
        return contentView
    }
    
    fileprivate func makeStackView(with description: NSMutableAttributedString) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")?
                                .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .label
        descriptionLabel.attributedText = description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
        stackView.alignment = .leading
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }
}

