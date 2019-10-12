//
//  PrefrenceHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 10/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class PreferenceHeaderView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 90)
    }
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.text = "Add Preferences"
        return label
    }()
    
    var descriptionText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .gray
        label.text = "Have stock preferences? Set your preferences from the list below to see stocks you may like."
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, descriptionText])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentStackView)
        contentStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 18, left: 16, bottom: 8, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
