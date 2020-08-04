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
    
    private static let chartViewModel = ChartViewModel()

    static func configure(_ cell: LineChartTableViewCell,
                          firstHistoricalData: [CompanyHistoricalDatum],
                          secondHistoricalData: [CompanyHistoricalDatum],
                          searchCriteria: SearchCriteria) {
        let lineChart = cell.chartView
        configureXAxis(lineChart)
        configureLeftAxis(lineChart)
        toggleChartConfigs(lineChart)
        formatAxis(lineChart, searchCriteria, firstHistoricalData, secondHistoricalData)
        insertDataSets(into: lineChart, searchCriteria, firstHistoricalData, secondHistoricalData)
        lineChart.animate(xAxisDuration: 0.25, yAxisDuration: 0, easingOption: .easeInCubic)
    }
    
    fileprivate static func createDataSet(from historicalData: [CompanyHistoricalDatum],
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
        lineChartDataSet.colors = [color]
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 3.5
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.cubicIntensity = 0.3
        lineChartDataSet.highlightEnabled = false
        lineChartDataSet.drawValuesEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.valueFont = NSUIFont.systemFont(ofSize: 9, weight: .regular)
        return lineChartDataSet
    }
    
    fileprivate static func insertDataSets(into chartView: LineChartView,
                                           _ searchCriteria: SearchCriteria,
                                           _ firstHistoricalData: [CompanyHistoricalDatum],
                                           _ secondHistoricalData: [CompanyHistoricalDatum]) {
        let firstData = createDataSet(from: firstHistoricalData, color: .appAccent, searchCriteria: searchCriteria)
        let secondData = createDataSet(from: secondHistoricalData, color: .appAccent4, searchCriteria: searchCriteria)
        chartView.data = LineChartData(dataSets: [firstData, secondData])
    }
    
    fileprivate static func formatAxis(_ chartView: LineChartView,
                                       _ searchCriteria: SearchCriteria,
                                       _ firstHistoricalData: [CompanyHistoricalDatum],
                                       _ secondHistoricalData: [CompanyHistoricalDatum]) {
        let isFirstDataSetLarger = firstHistoricalData.count > secondHistoricalData.count
        let xAxisDataPoints: [String] = isFirstDataSetLarger ?
            firstHistoricalData.map { $0.date } : secondHistoricalData.map { $0.date }
        let yearValues: [String] = xAxisDataPoints.map({ String(Array($0)[0...3] )})
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yearValues)
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
    
    fileprivate static func configureLeftAxis(_ chartView: LineChartView) {
        chartView.leftAxis.spaceTop = 0.35
        chartView.leftAxis.spaceBottom = 0.2
        chartView.leftAxis.gridColor = .lightGray
        chartView.leftAxis.labelTextColor = .label
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    fileprivate static func configureXAxis(_ chartView: LineChartView) {
        chartView.xAxis.granularity = 1
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.centerAxisLabelsEnabled = false
    }
    
    fileprivate static func toggleChartConfigs(_ chartView: LineChartView) {
        chartView.dragEnabled = false
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.noDataText = "No data found for this metric"
    }
}

final class LineChartTableViewCell: UITableViewCell {
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
