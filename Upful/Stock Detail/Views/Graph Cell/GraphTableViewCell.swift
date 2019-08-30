//
//  GraphTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class GraphTableViewCell: UITableViewCell {
    
    let chartView = ChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        addSubview(chartView)
        chartView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


