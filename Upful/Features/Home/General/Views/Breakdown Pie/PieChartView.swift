//
//  PieChartView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Charts

protocol PieChartConfigurable {
    var title: String { get set }
    var value: Double { get set }
    var color: UIColor { get set }
}

struct PieChartViewModel: PieChartConfigurable {
    var title: String
    var value: Double
    var color: UIColor
}

struct PieChartViewModelLoader {
    func makeViewModels(from holdings: [Holding], cash: Double) -> [PieChartConfigurable] {
        var result: [PieChartConfigurable] = []
        let cashItem = PieChartViewModel(title: "Cash", value: cash,
                                         color: UIColor.systemGreen)
        result.append(cashItem)
        
        let colorOptions = [UIColor.appAccent3, .appAccent4, .appAccent5]
        var currentColorIndex = 0
        
        // create algorithm to loop through color options for each holding
        for holding in holdings {
            let appendingHolding = PieChartViewModel(
                title: holding.ticker,
                value: holding.currentTotalValue,
                color: colorOptions[currentColorIndex]
            )
            result.append(appendingHolding)
            
            // increment current color index
            currentColorIndex += 1
            
            // reset current color index
            if currentColorIndex > colorOptions.count - 1 {
                currentColorIndex = 0
            }
        }
        
        return result
    }
}

class GenericPieChartView: PieChartView {
    let chartViewModel = PieChartFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        chartDescription?.text = ""
        setupLegend()
        drawEntryLabelsEnabled = true        
        noDataText = "You have no holdings\nStart screening for stocks to get started!"
        noDataTextColor = .label
        noDataTextAlignment = .center
        noDataFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    }
    
    private func setupLegend() {
        legend.enabled = false
        legend.textColor = .label
        legend.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        entryLabelFont = .systemFont(ofSize: 14, weight: .bold)
    }
    
    func togglePercentDisplay() {
        usePercentValuesEnabled = !usePercentValuesEnabled
    }
    
    func setupPieChart(chartConfigurables: [PieChartConfigurable]) {
        let dataPoints = chartConfigurables.map{ $0.title }
        let values = chartConfigurables.map{ $0.value }
        
        let dataEntries = (0..<chartConfigurables.count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: values[i], label: dataPoints[i])
        }
        let set = PieChartDataSet(entries: dataEntries, label: "")
        set.valueFormatter = chartViewModel
        set.sliceSpace = 1
        set.valueTextColor = .label
        set.valueLineColor = .label
        set.xValuePosition = .outsideSlice
        set.yValuePosition = .outsideSlice
        
        set.colors = chartConfigurables.map({ $0.color })
        
        holeRadiusPercent = 0.62
        transparentCircleRadiusPercent = 0.65

        holeColor = .clear
        drawHoleEnabled = true
        rotationEnabled = false
        highlightPerTapEnabled = false
        usePercentValuesEnabled = false
        drawSlicesUnderHoleEnabled = false

        let dataSets = [set]
        let chartData = PieChartData(dataSets: dataSets)
        chartData.setValueFont(.systemFont(ofSize: 11, weight: .bold))
        data = chartData
        highlightValues(nil)
    }
    
    func animate() {
        self.animate(xAxisDuration: 0.75, easingOption: .linear)
    }
}

class PieChartFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let formattedValue = "$"+Int(value).formatUsingAbbreviation()
        
        return formattedValue
    }
}
