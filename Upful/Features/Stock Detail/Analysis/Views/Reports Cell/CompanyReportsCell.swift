//
//  CompanyReportsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class CompanyReportsCell: UITableViewCell {
    let spacerView = SpacerView()
    
    let headerLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = UIFont.viewHeader
        l.text = "Should Roku’s Fast Growth Worry Netflix and Peers?"
        return l
    }()
    
    let detailLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = UIFont.details1
        l.text = ""
        return l
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, detailLabel])
        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        
        addSubview(labelStackView)
        labelStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                              padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        
        addSubview(spacerView)
        spacerView.anchor(top: labelStackView.bottomAnchor, leading: labelStackView.leadingAnchor, bottom: nil, trailing: labelStackView.trailingAnchor,
                          padding: .init(top: 4, left: 8, bottom: 0, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
