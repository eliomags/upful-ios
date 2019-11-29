//
//  NavigationHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 11/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NavigationHeaderView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 44)
    }
    let headerLabel: UILabel = {
        let l = UILabel()
        l.text = "Heading"
        l.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
//        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let headerButtonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    fileprivate lazy var headerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .leading
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerButtonStackView)
        headerButtonStackView.anchor(
            top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 1, right: 24))
        
        addSubview(headerStackView)
        headerStackView.centerYAnchor.constraint(equalTo: headerButtonStackView.centerYAnchor).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: headerButtonStackView.leadingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

