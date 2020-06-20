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

class StockChartView: LineChartView {
    
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
        doubleTapToZoomEnabled = false
        
        pinchZoomEnabled = false
        
        xAxis.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
    }
    
    func configureDataPoints(datapoints: [ChartDataPoint]) {
        
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<datapoints.count {
            let entry = ChartDataEntry(x: Double(i), y: datapoints[i].close)
            chartDataEntries.append(entry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntries)
        lineChartDataSet.colors = [UIColor.appAccent3]
                
        data = LineChartData(dataSet: lineChartDataSet)
    }
    
}

class StockChartViewController: UIViewController {
    
    // MARK: Properties

    let chartDatapoints: [ChartDataPoint] = [
        .init(date: "2020-06-12", close: 34.4, changeOverTime: 0),
        .init(date: "2020-06-15", close: 35.18, changeOverTime: 0.02212),
        .init(date: "2020-06-16", close: 34.79, changeOverTime: 0.037418),
        .init(date: "2020-06-17", close: 35.22, changeOverTime: 0.02894),
        .init(date: "2020-06-18", close: 35.53, changeOverTime: 0.019732),
    ]
    
    typealias ChartTimeOptions = String
    let chartTimeOptions: [ChartTimeOptions] = ["1d", "1w", "1m", "3m", "ytd", "1y", "5y"]
    
    // MARK: Views
    
    private lazy var chartView: StockChartView = {
        let view = StockChartView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.configureDataPoints(datapoints: chartDatapoints)
        return view
    }()
    
    private lazy var chartTimeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: chartTimeOptions)
        return control
    }()
    
    // MARK: View Lifecycle
    
    override func loadView() {
        super.loadView()
        layoutContent()
        chartTimeControl.selectedSegmentIndex = 0
    }
    
    private func layoutContent() {
        let contentView = UIStackView(arrangedSubviews: [chartView, chartTimeControl])
        contentView.axis = .vertical
        contentView.spacing = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0)
        ])
    }
    
}
