//
//  GraphTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class BarGraphTableViewCell: UITableViewCell {
    let chartView = GenericBarChartView()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = VersionManager.collectionCellColor(in: self)
        v.addSubview(chartView)
        chartView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                         padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 15
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(containerView)
        containerView.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 8, left: 12, bottom: 8, right: 12))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

