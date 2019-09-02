//
//  BarChartView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Charts

class ReusableChartView: UIView {
    let graphHeader = DetailsHeaderView()
    let chartView = ChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(graphHeader)
        graphHeader.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                           padding: .init(top: 8, left: 16, bottom: 0, right: 8))
        addSubview(chartView)
        chartView.anchor(top: graphHeader.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 6, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChartView: BarChartView {
    
    let chartViewModel = ChartViewModel()
    let stubData = ChartViewModel.setupData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
        animate()
    }

    
    private func setupView() {
//        chartDescription?.text = "Revenue vs. Earnings"
        chartDescription?.text = ""
        doubleTapToZoomEnabled = false
        dragEnabled = false
        pinchZoomEnabled = false
        setupYAxis()
        setupXAxis()
        setupLegend()
    }
    
    private func setupLegend() {
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = -10
        legend.xOffset = 10.0
        legend.yEntrySpace = 0
    }
    
    private func setupYAxis() {
        leftAxis.spaceTop = 0.35
        leftAxis.spaceBottom = 0.2
        leftAxis.valueFormatter = chartViewModel
        leftAxis.gridColor = .darkGray
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.enabled = false
    }
    
    private func setupXAxis() {
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true        
        xAxis.granularity = 1
    }
    
    func setupChart(dataPoints: [String], values: [Double], values1: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: values1[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Earnings")
        let dataSets: [BarChartDataSet] = [chartDataSet, chartDataSet1]
        
        chartDataSet.colors = [UIColor.positive]
        chartDataSet1.colors = [UIColor.appAccent]
        
        chartDataSet.valueFont = NSUIFont.systemFont(ofSize: 9, weight: .semibold)
        chartDataSet1.valueFont = NSUIFont.systemFont(ofSize: 9, weight: .semibold)

        chartDataSet.valueFormatter = chartViewModel
        chartDataSet1.valueFormatter = chartViewModel
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let groupCount = dataPoints.count
        let startYear = 0
        
        chartData.barWidth = barWidth
        xAxis.axisMinimum = Double(startYear)
        let entireGroupSpace = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        xAxis.axisMaximum = Double(startYear) + entireGroupSpace * Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        
        self.data = chartData
    }
    
    func animate() {
        self.animate(xAxisDuration: 0.75, yAxisDuration: 0.75, easingOption: .linear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChartViewModel: IAxisValueFormatter, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let formattedValue = Int(value).formatUsingAbbreviation()
        
        return formattedValue
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formattedValue = Int(value).formatUsingAbbreviation()
        
        return formattedValue
    }
    
    static func setupData() -> [DetailsData] {
        let one = DetailsData(year: "2015", revenue: 5145784, earnings: 1005730)
        let two = DetailsData(year: "2016", revenue: 3357453, earnings: 3745693)
        let three = DetailsData(year: "2017", revenue: 5335301, earnings: 2003230)
        let four = DetailsData(year: "2018", revenue: 5127344, earnings: 1637662)

        return [one, two, three, four]
    }
}

struct DetailsData {
    let year: String
    let revenue: Double
    let earnings: Double
}













