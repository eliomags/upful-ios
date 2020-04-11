//
//  ManualScreenContainerHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerHeaderView: UIView {
    // MARK: - Views

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Tap a cell to build your screener."
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.title2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 35/2
        button.layer.masksToBounds = true
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 75).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel])
        sv.spacing = 16
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
            clearButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -16)
        ])
        
        addSubview(headerLabel)
        headerLabel.anchor(top: layoutMarginsGuide.topAnchor,
                           leading: layoutMarginsGuide.leadingAnchor,
                           bottom: clearButton.layoutMarginsGuide.topAnchor,
                           trailing: layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: 16, left: 16, bottom: 24, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

