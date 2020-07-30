//
//  ComparisonLineChartViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 7/30/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import Charts
import UIKit

struct ComparisonLineChartViewModel {
    
    static func configure(_ cell: LineChartTableViewCell,
                          firstHistoricalData: [CompanyHistoricalDatum],
                          secondHistoricalData: [CompanyHistoricalDatum]) {
        let firstData = createDataSet(from: firstHistoricalData, color: .appAccent)
        let secondData = createDataSet(from: secondHistoricalData, color: .appAccent4)
        cell.chartView.data = LineChartData(dataSets: [firstData, secondData])
    }
    
    static func createDataSet(from historicalData: [CompanyHistoricalDatum], color: UIColor) -> LineChartDataSet {
        var entries = [ChartDataEntry]()
        for i in 0..<historicalData.count {
            let entry = ChartDataEntry(x: Double(i), y: historicalData[i].value)
            entries.append(entry)
        }
        let lineChartDataSet = LineChartDataSet(entries: entries)
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.cubicIntensity = 0.3
        lineChartDataSet.highlightLineWidth = 2
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.colors = [color]
        return lineChartDataSet
    }
}

class LineChartTableViewCell: UITableViewCell {
    static let reuseID = "LineChartTableViewCell"
    
    let chartView: LineChartView = {
        let view = LineChartView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(chartView)
        chartView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
