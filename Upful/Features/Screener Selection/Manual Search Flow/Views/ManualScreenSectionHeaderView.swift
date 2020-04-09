//
//  ManualScreenSectionHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Views
    
    let headerTextLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.text = ""
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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textStackView)
        textStackView.anchor(top: layoutMarginsGuide.topAnchor,
                             leading: layoutMarginsGuide.leadingAnchor,
                             bottom: layoutMarginsGuide.bottomAnchor,
                             trailing: layoutMarginsGuide.trailingAnchor,
                             padding: .init(top: 0, left: 16, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

