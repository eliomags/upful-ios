//
//  ManualScreenContainerHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerHeaderView: UIView {
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
            clearButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

