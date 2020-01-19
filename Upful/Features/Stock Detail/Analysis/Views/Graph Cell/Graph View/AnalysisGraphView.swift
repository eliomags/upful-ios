//
//  AnalysisGraphView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Charts

class CombinedLineChartView: CombinedChartView {
    
    private let chartViewModel = ChartViewModel()

    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
        drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        chartDescription?.enabled = false
        highlightFullBarEnabled = false
        drawBarShadowEnabled = false
        doubleTapToZoomEnabled = false
        dragEnabled = false
        pinchZoomEnabled = false
        setupXAxis()
        setupYAxis()
        setupLegend()
    }
    
    private func setupYAxis() {
        drawValueAboveBarEnabled = false
        leftAxis.spaceTop = 0.15
        leftAxis.spaceBottom = 0.2
        if #available(iOS 13.0, *) {
            leftAxis.labelTextColor = .label
        } else {
            leftAxis.labelTextColor = .black
        }
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        leftAxis.gridColor = .lightGray
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 1
        leftAxis.drawBottomYLabelEntryEnabled = true
        leftAxis.axisMaxLabels = 5
        
        rightAxis.enabled = true
        rightAxis.spaceTop = 0.15
        rightAxis.spaceBottom = 0.2
        if #available(iOS 13.0, *) {
            rightAxis.labelTextColor = .label
        } else {
            rightAxis.labelTextColor = .black
        }
        rightAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        rightAxis.gridColor = .lightGray
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.axisMaxLabels = 5
    }
    
    private func setupXAxis() {
        xAxis.labelTextColor = .label
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularity = 1
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.spaceMin = 0.3
        xAxis.spaceMax = 0.3
    }
    
    private func setupLegend() {
        legend.enabled = false
        legend.textColor = .label
        legend.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = -10
        legend.xOffset = 15
        legend.yEntrySpace = 0
    }
    
    let chartData = CombinedChartData()
    
    func generateLineData(dataPoints: [String], values: [Double], criteria: SearchCriteria) {
        var entries = [ChartDataEntry]()
        setVisibleXRange(minXRange: 0, maxXRange: Double(dataPoints.count - 1))
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            entries.append(dataEntry)
        }
        let dataSet = LineChartDataSet(entries: entries, label: criteria.explicit)
        dataSet.setColor(NSUIColor.appAccent)
        dataSet.setCircleColors(NSUIColor.appAccent)
        dataSet.valueTextColor = UIColor.label
        dataSet.mode = .cubicBezier
        dataSet.drawValuesEnabled = true
        dataSet.valueFont = NSUIFont.systemFont(ofSize: 10, weight: .light)
        dataSet.circleRadius = 3
        dataSet.circleHoleRadius = 0
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = true
        
        dataSet.axisDependency = .right
        rightAxis.axisMaximum = dataSet.yMax * 1.3
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)

        let lineChartData = LineChartData(dataSet: dataSet)
        if criteria.parameterType == .number {
            dataSet.valueFormatter = chartViewModel
            rightAxis.valueFormatter = chartViewModel
            lineChartData.setValueFormatter(chartViewModel)
        }
        if criteria.parameterType == .percentage {
            rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.decimalFormatter)
            lineChartData.setValueFormatter(DefaultValueFormatter(formatter: ChartViewModel.decimalFormatter))
        }
        if criteria.parameterType == .ratio {
            rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.multipleFormatter)
            lineChartData.setValueFormatter(DefaultValueFormatter(formatter: ChartViewModel.multipleFormatter))
        }
        
        self.chartData.lineData = lineChartData
        
        data = self.chartData
        self.fitScreen()
    }
    
    func generateBarData(dataPoints: [String], values: [Double], criteria: SearchCriteria) {
        var entries = [BarChartDataEntry]()
        setVisibleXRange(minXRange: 0, maxXRange: Double(dataPoints.count - 1))

        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            entries.append(dataEntry)
        }
        let dataSet = BarChartDataSet(entries: entries, label: criteria.explicit)
        dataSet.setColor(NSUIColor.appAccent3)
        dataSet.valueFont = NSUIFont.systemFont(ofSize: 9.5, weight: .semibold)
        dataSet.valueTextColor = UIColor.label
        dataSet.drawValuesEnabled = true
        dataSet.highlightEnabled = false
        dataSet.axisDependency = .left
        leftAxis.axisMaximum = dataSet.yMax * 1.4
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        let chartData = BarChartData(dataSet: dataSet)
        chartData.barWidth = 0.3
        
        if criteria.parameterType == .number {
            dataSet.valueFormatter = chartViewModel
            leftAxis.valueFormatter = chartViewModel
        }
        if criteria.parameterType == .percentage {
            dataSet.valueFormatter = DefaultValueFormatter(formatter: ChartViewModel.decimalFormatter)
            leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.decimalFormatter)
        }
        if criteria.parameterType == .ratio {
            dataSet.valueFormatter = DefaultValueFormatter(formatter: ChartViewModel.multipleFormatter)
            leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: ChartViewModel.multipleFormatter)
        }
        
        self.chartData.barData = chartData
        data = self.chartData
        self.fitScreen()
    }
    
    func animate() {
        self.animate(xAxisDuration: 0.75, yAxisDuration: 0.75, easingOption: .linear)
    }
}

