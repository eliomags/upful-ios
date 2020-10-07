//
//  AnalysisChartCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class AnalysisChartCell: UITableViewCell {
    
    static let reuseID = "AnalysisChartCell"
        
    let chartView = CombinedLineChartView()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.addSubview(chartView)
        chartView.anchor(
            top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
            padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = VersionManager.collectionCellColor3()
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
