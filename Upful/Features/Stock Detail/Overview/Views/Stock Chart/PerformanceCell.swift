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
    
    // MARK: Properties
    
    private var currentSelectedIndex = 0
    private var datapoints: [ChartDataPoint] = []
    
    typealias ChartTimeOption = String
    private let chartTimeOptions: [ChartTimeOption] = ["1d", "1w", "1m", "3m", "ytd", "1y", "5y"]
    
    // MARK: Views
    
    private var performanceChartHelperView: PerformanceChartHelperView = {
        let view = PerformanceChartHelperView()
        return view
    }()
    
    // MARK: Initializer

    init() {
        loadDataPoints(at: chartTimeOptions.first!)
    }
    
    // MARK: Data Loading
    
    func loadDataPoints(at timeOption: ChartTimeOption) {
        datapoints = [
            .init(date: "2020-06-12", close: 34.4, changeOverTime: 0),
            .init(date: "2020-06-15", close: 35.18, changeOverTime: 0.02212),
            .init(date: "2020-06-16", close: 34.79, changeOverTime: 0.037418),
            .init(date: "2020-06-17", close: 35.22, changeOverTime: 0.02894),
            .init(date: "2020-06-18", close: 35.53, changeOverTime: 0.019732),
            .init(date: "2020-06-21", close: 33.1, changeOverTime: 0.019732),
        ]
    }
    
    // MARK: View Setup
    
    func configure(_ performanceCell: PerformanceCell) {
        performanceCell.chartView.delegate = self
        
        let helperView = performanceChartHelperView
        performanceCell.chartView.dragCompletion = {
            helperView.removeFromSuperview()
            print("drag completion")
        }
        
        for index in 0..<chartTimeOptions.count {
            performanceCell.chartTimeControl.insertSegment(withTitle: chartTimeOptions[index], at: index, animated: false)
        }
        performanceCell.chartTimeControl.selectedSegmentIndex = currentSelectedIndex
        
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<datapoints.count {
            let entry = ChartDataEntry(x: Double(i), y: datapoints[i].close)
            chartDataEntries.append(entry)
        }
        performanceCell.chartView.setDataSet(with: chartDataEntries)
    }
    
    func setupHelperView(chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var leftDistance = highlight.xPx
        chartView.addSubview(performanceChartHelperView)
        
        if Int(entry.x) == datapoints.count-1 {
            performanceChartHelperView.labels.forEach({ $0.textAlignment = .right })
            leftDistance -= performanceChartHelperView.frame.width + 3
        } else {
            performanceChartHelperView.labels.forEach({ $0.textAlignment = .left })
            leftDistance += 3
        }
        performanceChartHelperView.anchor(top: chartView.topAnchor, leading: chartView.leadingAnchor,
                                          bottom: nil, trailing: nil,
                                          padding: .init(top: 0, left: leftDistance, bottom: 0, right: 0))
    }
    
    func configureHelperView(at index: Int) {
//        guard let datapoints = datapoints else { return }
        let dataPoint = datapoints[index]
        let firstClose = datapoints.first!.close
        let changeFromFirst: Double = (dataPoint.close / firstClose) - 1
        let percentChange = changeFromFirst.convertToPercent() + "%"
        
        if changeFromFirst < 0 {
            performanceChartHelperView.valueChangeLabel.textColor = .systemRed
        } else {
            performanceChartHelperView.valueChangeLabel.textColor = .systemGreen
        }
        performanceChartHelperView.dateLabel.text = dataPoint.date
        performanceChartHelperView.valueChangeLabel.text = "$\(dataPoint.close)(\(percentChange))"
    }
}

extension StockPerformanceChartViewModel: ChartViewDelegate {
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {}
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        performanceChartHelperView.removeFromSuperview()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        Vibration.light.vibrate()
        performanceChartHelperView.removeFromSuperview()
        setupHelperView(chartView: chartView, entry: entry, highlight: highlight)
        configureHelperView(at: Int(entry.x))
    }
}

class PerformanceChartHelperView: UIView {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "PlaceHolder Date"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueChangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "PlaceHolder Date"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labels: [UILabel] {
        return [dateLabel, valueChangeLabel]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemened")
    }
    
    func configure() {
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
}

class PerformanceLineChartView: LineChartView {
    
    var dragCompletion: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemened")
    }

    func configure() {
        noDataText = ""
        chartDescription?.text = ""
        
        xAxis.enabled = false
        legend.enabled = false
        pinchZoomEnabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        doubleTapToZoomEnabled = false
        
        xAxis.granularity = 1
        leftAxis.spaceTop = 0.2
        leftAxis.spaceBottom = 0.2
    }
    
    func setDataSet(with chartDataEntries: [ChartDataEntry]) {
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntries)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        
//        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.cubicIntensity = 0.25
        lineChartDataSet.colors = [UIColor.appAccent3]
        
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
