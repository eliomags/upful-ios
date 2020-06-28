//
//  StockChartViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 6/19/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

class StockPerformanceChartViewModel {
    
    private let historicalPriceLoader = HistoricalPriceLoader()
    
    // MARK: Properties
    
    private(set)var currentSelectedIndex = 0
    private var datapoints: [ChartDataPoint] = []
    
    private let ticker: String
    private let timePeriods = HistoricalPriceLoader.TimePeriod.allCases
    
    private var chartTimeOptions: [String] {
        return timePeriods.map { $0.explicit }
    }
    
    // MARK: Callbacks
    
    var loadCompletion: (() -> Void)?
    
    // MARK: Views
    
    private var performanceCell: PerformanceCell?
    private let performanceChartHelperView = PerformanceChartHelperView()
        
    // MARK: Initializer

    init(ticker: String) {
        self.ticker = ticker
    }
    
    // MARK: API
    
    func loadInitialDataPoints(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        
        let selectedTimePeriod = timePeriods[currentSelectedIndex]
        loadChartDataPoints(at: selectedTimePeriod) {
            dispatchGroup?.leave()
        }
    }

    // MARK: Actions
    
    @objc private func handleTimePeriodChange(control: UISegmentedControl) {
        Vibration.selection.vibrate()
        
        currentSelectedIndex = control.selectedSegmentIndex
        
        let selectedTimePeriod = timePeriods[currentSelectedIndex]
        loadChartDataPoints(at: selectedTimePeriod) { [weak self] in
            self?.loadCompletion?()
        }
    }
    
    // MARK: Private Methods
    
    private func loadChartDataPoints(at timeOption: HistoricalPriceLoader.TimePeriod, _ completion: @escaping () -> Void) {
        performanceChartHelperView.removeFromSuperview()
        performanceCell?.chartView.highlightValue(nil)
        
        historicalPriceLoader.load(ticker: ticker, period: timeOption) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let datapoints):
                    self.datapoints = datapoints.filter { $0.close != nil }
                case .failure(let err):
                    print(err)
                }
                completion()
            }
        }
    }
    
    // MARK: Cell Setup
    
    func configure(_ performanceCell: PerformanceCell) {
        self.performanceCell = performanceCell
        performanceCell.chartView.delegate = self
        
        configureSegmentControl(performanceCell)
        
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<datapoints.count {
            guard let value = datapoints[i].close else { continue }
            let entry = ChartDataEntry(x: Double(i), y: value)
            chartDataEntries.append(entry)
        }
        
        performanceCell.chartView.setDataSet(with: chartDataEntries)
    }
    
    fileprivate func configureSegmentControl(_ performanceCell: PerformanceCell) {
        guard performanceCell.chartTimeControl.numberOfSegments == 0 else { return }
        
        for index in 0..<chartTimeOptions.count {
            performanceCell.chartTimeControl.insertSegment(withTitle: chartTimeOptions[index], at: index, animated: false)
        }
        
        performanceCell.chartTimeControl.selectedSegmentIndex = currentSelectedIndex
        performanceCell.chartTimeControl.addTarget(self, action: #selector(handleTimePeriodChange), for: .valueChanged)
    }

    // MARK: Chart Helper View Setup/Configuration
    
    func setupHelperView(chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var leftDistance = highlight.xPx
        chartView.addSubview(performanceChartHelperView)
        
        let totalChartViewWidth = chartView.frame.width
        let entryAndLabelWidth = performanceChartHelperView.frame.width + highlight.xPx
        let didExceedChartViewWidth = entryAndLabelWidth > totalChartViewWidth
        
        if didExceedChartViewWidth {
            performanceChartHelperView.labels.forEach{ $0.textAlignment = .right }
            leftDistance -= performanceChartHelperView.frame.width + 5
        } else {
            performanceChartHelperView.labels.forEach{ $0.textAlignment = .left }
            leftDistance += 5
        }
        
        performanceChartHelperView.anchor(top: chartView.topAnchor, leading: chartView.leadingAnchor,
                                          bottom: nil, trailing: nil,
                                          padding: .init(top: 0, left: leftDistance, bottom: 0, right: 0))
    }
    
    func configureHelperView(at index: Int) {
        guard !datapoints.isEmpty else { return }
        let dataPoint = datapoints[index]
        guard
            let selectedValue = dataPoint.close,
            let firstClose = datapoints.first!.close
            else { return }
        let changeFromFirst: Double = (selectedValue / firstClose) - 1
        let percentChange = changeFromFirst.convertToPercent() + "%"
        
        if changeFromFirst < 0 {
            performanceChartHelperView.valueChangeLabel.textColor = .systemRed
        } else {
            performanceChartHelperView.valueChangeLabel.textColor = .systemGreen
        }
        
        performanceChartHelperView.dateLabel.text = dataPoint.label
        performanceChartHelperView.valueChangeLabel.text = "$\(selectedValue)(\(percentChange))"
    }

}

extension StockPerformanceChartViewModel: ChartViewDelegate {
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        performanceChartHelperView.removeFromSuperview()
        chartView.highlightValue(nil)
    }
    
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
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueChangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = ""
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
        
        lineChartDataSet.cubicIntensity = 0.25
        
        let isPositiveChange = (chartDataEntries.first?.y ?? 0) < (chartDataEntries.last?.y ?? 0)
        lineChartDataSet.colors = isPositiveChange ? [UIColor.appAccent3] : [UIColor.systemRed]
        
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
