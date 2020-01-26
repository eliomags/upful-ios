//
//  TableHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/2/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 90)
    }
    let headerLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 21, weight: .heavy)
        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()
    
    let detailsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return l
    }()
    
    private lazy var headerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, detailsLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .leading
        return sv
    }()
    
    lazy var accessoryStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView()])
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .trailing
        return sv
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerStackView, accessoryStackView])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .leading
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentStackView)
        contentStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                               padding: .init(top: 8, left: 16, bottom: 1, right: 16))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
