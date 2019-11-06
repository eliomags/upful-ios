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
        return CGSize(width: 0, height: 60)
    }
    let headerLabel: UILabel = {
        let l = UILabel()
        l.text = "TWTR"
        l.font = UIFont(name: "AvenirNext-Heavy", size: 21)
        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var detailsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont(name: "AvenirNext-Bold", size: 17)
        return l
    }()
    
    lazy var headerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, detailsLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .leading
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerStackView)
        headerStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                               padding: .init(top: 0, left: 16, bottom: 1, right: 16))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
