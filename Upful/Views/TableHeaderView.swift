//
//  TableHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/2/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    var detailsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont(name: "AvenirNext-Medium", size: 16)
        return l
    }()
    
    lazy var headerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [detailsLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .leading
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(headerStackView)
        headerStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                               padding: .init(top: 12, left: 16, bottom: 1, right: 16))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
