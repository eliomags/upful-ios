//
//  StockChartViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 6/19/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

struct ChartDataPoint {
    let date: String
    let close: Double
    let changeOverTime: Double
}

class StockPerformanceChartViewModel {
    typealias ChartTimeOption = String
    let chartTimeOptions: [ChartTimeOption] = ["1d", "1w", "1m", "3m", "ytd", "1y", "5y"]
    
    var currentSelectedIndex = 0
    var datapoints: [ChartDataPoint] = []
    
    init() {
        loadDataPoints(at: chartTimeOptions.first!)
    }
    
    func loadDataPoints(at timeOption: ChartTimeOption) {
        datapoints = [
            .init(date: "2020-06-12", close: 34.4, changeOverTime: 0),
            .init(date: "2020-06-15", close: 35.18, changeOverTime: 0.02212),
            .init(date: "2020-06-16", close: 34.79, changeOverTime: 0.037418),
            .init(date: "2020-06-17", close: 35.22, changeOverTime: 0.02894),
            .init(date: "2020-06-18", close: 35.53, changeOverTime: 0.019732),
        ]
    }
    
    func configure(_ cell: PerformanceCell) {
        for index in 0..<chartTimeOptions.count {
            cell.chartTimeControl.insertSegment(withTitle: chartTimeOptions[index], at: index, animated: false)
        }
        cell.chartTimeControl.selectedSegmentIndex = currentSelectedIndex
        
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<datapoints.count {
            let entry = ChartDataEntry(x: Double(i), y: datapoints[i].close)
            chartDataEntries.append(entry)
        }
        cell.chartView.setDataSet(with: chartDataEntries)
    }
}

class PerformanceLineChartView: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemened")
    }
    
    func configure() {
        legend.enabled = false
        chartDescription?.text = ""
        noDataText = ""

        doubleTapToZoomEnabled = false
        
        pinchZoomEnabled = false
        
        xAxis.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        
        leftAxis.spaceTop = 0.2
        leftAxis.spaceBottom = 0.2
    }
    
    func setDataSet(with chartDataEntries: [ChartDataEntry]) {
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntries)
        lineChartDataSet.colors = [UIColor.appAccent3]
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        lineChartDataSet.highlightLineWidth = 2
        lineChartDataSet.highlightColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        data = LineChartData(dataSet: lineChartDataSet)
    }
    
}

class PerformanceCell: UITableViewCell {
    
    // MARK: Views
    
    lazy var chartView: PerformanceLineChartView = {
        let view = PerformanceLineChartView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var chartTimeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [])
        return control
    }()
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Layout
    
    private func layoutContent() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let contentView = UIStackView(arrangedSubviews: [chartView, chartTimeControl])
        contentView.axis = .vertical
        contentView.spacing = 0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 0)
        ])
    }
}
