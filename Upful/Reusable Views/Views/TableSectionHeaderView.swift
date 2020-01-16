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
    
    let headerTextLabel: LargeSectionHeaderLabel = {
        let label = LargeSectionHeaderLabel(padding: 0)
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
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
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.font = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
        button.setTitleColor(.appAccent3, for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
            top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 12))
        
        textStackView.anchor(
            top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: addButton.leadingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc fileprivate func handleTap(_ sender: UIView) {
        buttonAction?()
    }
    
}

