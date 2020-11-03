//
//  MetricPreviewTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class MetricPreviewTableViewCell: UITableViewCell {
    
    static let reuseID = "MetricPreviewTableViewCell"
    
    let metricLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineChartView: PerformanceLineChartView = {
        let view = PerformanceLineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        addSubview(metricLabel)
        metricLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        metricLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        
        addSubview(lineChartView)
        lineChartView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineChartView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineChartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        lineChartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85).isActive = true
        
        addSubview(totalChangeLabel)
        totalChangeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        totalChangeLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -24).isActive = true
    }

}
