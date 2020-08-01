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
    
    static let chartViewModel = ChartViewModel()

    
    static func configure(_ cell: LineChartTableViewCell,
                          firstHistoricalData: [CompanyHistoricalDatum],
                          secondHistoricalData: [CompanyHistoricalDatum],
                          searchCriteria: SearchCriteria) {
        let firstData = createDataSet(from: firstHistoricalData,
                                      color: .appAccent,
                                      searchCriteria: searchCriteria)
        let secondData = createDataSet(from: secondHistoricalData, color: .appAccent4, searchCriteria: searchCriteria)
        configure(cell.chartView, searchCriteria: searchCriteria)
        cell.chartView.data = LineChartData(dataSets: [firstData, secondData])
    }
    
    static func createDataSet(from historicalData: [CompanyHistoricalDatum],
                              color: UIColor,
                              searchCriteria: SearchCriteria) -> LineChartDataSet {
        var entries = [ChartDataEntry]()
        for i in 0..<historicalData.count {
            let entry = ChartDataEntry(x: Double(i), y: historicalData[i].value)
            entries.append(entry)
        }
        let lineChartDataSet = LineChartDataSet(entries: entries)
        switch searchCriteria.parameterType {
        case .ratio:
            lineChartDataSet.valueFormatter = DefaultValueFormatter(formatter: ChartViewModel.multipleFormatter)
        case .percentage:
            lineChartDataSet.valueFormatter = DefaultValueFormatter(formatter: ChartViewModel.decimalFormatter)
        case .number:
            lineChartDataSet.valueFormatter = chartViewModel
        default:
            assertionFailure("Not implemented")
        }
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
    
    static func configure(_ chartView: LineChartView, searchCriteria: SearchCriteria) {
        chartView.chartDescription?.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.centerAxisLabelsEnabled = true
        chartView.xAxis.granularity = 1
        chartView.leftAxis.spaceTop = 0.35
        chartView.leftAxis.spaceBottom = 0.2
        chartView.leftAxis.labelTextColor = .label
        chartView.leftAxis.gridColor = .lightGray
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        switch searchCriteria.parameterType {
        case .ratio:
            chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.multipleFormatter)
        case .percentage:
            chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.decimalFormatter)
        case .number:
            chartView.leftAxis.valueFormatter = chartViewModel
        default:
            assertionFailure("Not implemented")
        }
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
