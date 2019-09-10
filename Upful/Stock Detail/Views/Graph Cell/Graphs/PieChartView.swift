//
//  PieChartView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Charts


class GenericPieChartView: PieChartView {
    let chartViewModel = ChartViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func setupViews() {
        chartDescription?.text = ""
        setupLegend()
        rotationEnabled = false
        setupPieChart(values: [4000,3000,3000])
    }
    
    private func setupLegend() {
        legend.enabled = true
        legend.textColor = .black
        legend.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        entryLabelFont = .systemFont(ofSize: 14, weight: .bold)
    }
    
    func setupPieChart(values: [Double]) {
        let dataPoints = ["Asset", "Liabilities", "Equity"]
        let dataEntries = (0..<values.count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: values[i], label: dataPoints[i])
        }
        let set = PieChartDataSet(entries: dataEntries, label: "")
        set.valueFormatter = chartViewModel
        set.sliceSpace = 2
        set.colors = [NSUIColor.positive,
             NSUIColor.appAccent,
             NSUIColor.appAccent3
            ]
        
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
