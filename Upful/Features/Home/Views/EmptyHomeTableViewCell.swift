//
//  EmptyStockHoldingCell.swift
//  Upful
//
//  Created by Yanik Simpson on 3/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyHomeTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var headerText: String {
        return "placeHolder"
    }
    var descriptionText: String {
        return "placeholder"
    }
    var cellImage: UIImage? {
        return UIImage(named: "holdingsImage")
    }
    var actionButtonTitle: String {
        return "Get Started"
    }
    
    // MARK: - Views
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = headerText
        label.numberOfLines = 0
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.numberOfLines = 0
        label.text = descriptionText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var cellImageView: UIImageView = {
        let view = UIImageView(image: cellImage)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        button.backgroundColor = .appAccent3
        button.setTitleColor(.white, for: .normal)
        button.setTitle(actionButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        return button
    }()
    
    private lazy var contentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.collectionCellColor3()
        
        let imageBackground = cellImageView.insertOnBackgroundView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        imageBackground.backgroundColor = .clear
        imageBackground.layer.cornerRadius = 12
        imageBackground.layer.masksToBounds = true
        
        view.addSubview(imageBackground)
        imageBackground.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil,
                               bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor,
                               padding: .init(top: 12, left: 0, bottom: 0, right: 12),
                               size: CGSize(width: 44, height: 44))
        view.addSubview(headerLabel)
        headerLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor,
                           bottom: nil, trailing: imageBackground.leadingAnchor,
                           padding: .init(top: 12, left: 12, bottom: 0, right: 12))
        view.addSubview(actionButton)
        actionButton.anchor(top: nil, leading: nil,
                            bottom: view.layoutMarginsGuide.bottomAnchor, trailing: nil,
                            padding: .init(top: 12, left: 28, bottom: 12, right: 28))
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: headerLabel.layoutMarginsGuide.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor,
                                bottom: actionButton.layoutMarginsGuide.topAnchor, trailing: view.layoutMarginsGuide.trailingAnchor,
                                padding: .init(top: 26, left: 12, bottom: 32, right: 8))
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.setupShadow(intensity: .light, color: .gray)
        return view
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(contentBackground)
        contentBackground.translatesAutoresizingMaskIntoConstraints = false
        contentBackground.anchor(top: contentView.layoutMarginsGuide.topAnchor, leading: contentView.layoutMarginsGuide.leadingAnchor,
                                 bottom: contentView.layoutMarginsGuide.bottomAnchor, trailing: contentView.layoutMarginsGuide.trailingAnchor,
                                 padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("No coder")
    }
    
}

extension UIView {
    
    func insertOnBackgroundView(view: UIView = UIView(), padding: UIEdgeInsets? = nil) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding?.top ?? 0),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(padding?.bottom ?? 0)),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding?.left ?? 0),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(padding?.right ?? 0))
        ])
        return view
    }
}

class EmptyHoldingsTableViewCell: EmptyHomeTableViewCell {
    
    // MARK: Properties
    
    override var headerText: String {
        return "Upful uses live stock data to keep your analysis accurate."
    }
    
   override var descriptionText: String {
        return "Start paper trading and test your investment thesis."
    }
    
    override var cellImage: UIImage? {
        return UIImage(systemName: "chart.bar.fill")?
            .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
    }
    
}

class EmptyPreferenceTableViewCell: EmptyHomeTableViewCell {
    
    // MARK: Properties
    
    override var headerText: String {
        return "You can start getting stock recommendations fitting your custom preferences."
    }
    
    override var descriptionText: String {
        return "Set up your preferences and start getting recommendations."
    }
    
    override var cellImage: UIImage? {
        return UIImage(systemName: "hand.thumbsup.fill")?
            .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
    }
}
