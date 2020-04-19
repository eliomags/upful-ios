//
//  TableSectionHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class TableSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Views
    
    let headerTextLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    let viewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerTextLabel, viewDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("See More", for: .normal)
        let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.font = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
        button.setTitleColor(.appAccent3, for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        return button
    }()

    // MARK: - Actions
    
    var buttonAction: (()->())?
    
    
    // MARK: - Initializer Method
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(textStackView)
        addSubview(addButton)
        
        addButton.anchor(
            top: topAnchor, leading: nil, bottom: nil,
            trailing: layoutMarginsGuide.trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 16, right: 0))
        
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
        textStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        textStackView.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: -24).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func handleTap(_ sender: UIButton) {
        buttonAction?()
    }
}

