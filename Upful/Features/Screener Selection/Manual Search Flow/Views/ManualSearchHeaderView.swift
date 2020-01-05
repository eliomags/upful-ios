//
//  ManualSearchHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualSearchHeaderView: UIView {
    
    let header: SmallSectionHeaderLabel = {
        let l = SmallSectionHeaderLabel(padding: 16)
        l.text = "ADD SEARCH PARAMETERS"
        return l
    }()
        
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [header])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 16, left: 8, bottom: 4, right: 20))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


