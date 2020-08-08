//
//  MetricPreviewViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

protocol MetricPreviewViewModelDelegate: class {
    func didLoadCellData(cell: MetricPreviewTableViewCell?, with results: [CompanyHistoricalDatum])
}

final class MetricPreviewViewModel {
    
    weak var delegate: MetricPreviewViewModelDelegate?
    
    let ticker: String
    typealias MetricDataFetch = (String, FinancialsFrequency, SearchCriteria,
        @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) -> ()
    var fetchMetricData: MetricDataFetch?
    var searchCriteria: SearchCriteria {
        didSet {
            loadHistoricalData()
        }
    }
    var historicalData = [CompanyHistoricalDatum]()

    private(set) var isLoading = false {
        didSet {
            handleLoadingState()
        }
    }
    
    private(set) var configuringCell: MetricPreviewTableViewCell?

    // MARK: Init
    
    init(ticker: String,
         searchCriteria: SearchCriteria,
         fetching: @escaping MetricDataFetch = StockFinancialLoader().getStockFinancials) {
        self.ticker = ticker
        self.searchCriteria = searchCriteria
        self.fetchMetricData = fetching
    }
    
    // MARK: Methods
    
    func loadHistoricalData() {
        isLoading = true
        
        fetchMetricData?(ticker, .fiveYear, searchCriteria) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let historicalData):
                    self.historicalData = historicalData
                    self.delegate?.didLoadCellData(cell: self.configuringCell, with: historicalData)
                case .failure(let err):
                    print(err.localizedDescription)
                    self.delegate?.didLoadCellData(cell: self.configuringCell, with: [])
                }
            }
        }
    }
    
    func configureCell(_ cell: MetricPreviewTableViewCell) {
        configuringCell = cell

        cell.metricLabel.text = searchCriteria.explicit
        
        var chartDataEntries: [ChartDataEntry] = []
        for index in 0..<historicalData.count {
            let entry = ChartDataEntry(x: Double(index), y: historicalData[index].value)
            chartDataEntries.append(entry)
        }
        cell.lineChartView.dragEnabled = false
        cell.lineChartView.isUserInteractionEnabled = false
        cell.lineChartView.setDataSet(with: chartDataEntries)
        
        guard !historicalData.isEmpty else { return }
        let lastValue = historicalData.last!.value
        let firstValue = historicalData.first!.value
        cell.totalChangeLabel.text = calculateTotalChange(firstValue, lastValue)
    }
    
    func calculateTotalChange(_ denominator: Double, _ numerator: Double) -> String {
        let positiveToPositive = denominator > 0 && numerator > 0
        let negativeToPositive = denominator < 0 && numerator > 0
        let positiveToNegative = denominator > 0 && numerator < 0
        let zeroToPositive = denominator == 0 && numerator > 0
        let positiveToZero = denominator > 0 && numerator == 0
        
        if positiveToPositive {
            let changeFromFirst: Double = (numerator / denominator) - 1
            // do 999% if greater than
            if changeFromFirst > 9.99 { return "999%" }
            let percentChange = changeFromFirst.convertToPercent() + "%"
            return percentChange
            
        } else if negativeToPositive || zeroToPositive {
            return "999%"
            
        } else if positiveToNegative {
            return "-999%"
            
        } else if positiveToZero {
            return "-100%"
        }
        
        return ""
    }
    
    let activityView = UIActivityIndicatorView(style: .medium)
    
    func handleLoadingState() {
        if isLoading {
            configuringCell?.addSubview(activityView)
            activityView.centerInSuperview()
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
        }
        
        if historicalData.isEmpty && !isLoading {
            configuringCell?.totalChangeLabel.text = "No data"
        }
    }
}
