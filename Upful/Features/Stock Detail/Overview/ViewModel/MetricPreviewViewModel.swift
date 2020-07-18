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
    func didLoadCellData(cell: MetricPreviewTableViewCell?)
}

final class MetricPreviewViewModel {
    
    weak var delegate: MetricPreviewViewModelDelegate?
    
    let ticker: String
    typealias MetricDataFetch = (String, FinancialsFrequency, SearchCriteria,
        @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) -> ()
    var fetchMetricData: MetricDataFetch
    var searchCriteria: SearchCriteria {
        didSet {
            loadHistoricalData()
        }
    }
    var historicalData = [CompanyHistoricalDatum]()

    private(set) var isLoading = false
    
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
        
        fetchMetricData(ticker, .fiveYear, searchCriteria) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let historicalData):
                self.historicalData = historicalData
            case .failure(let err):
                print(err.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.delegate?.didLoadCellData(cell: self.configuringCell)
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
                
        handleLoadingState()
        
        guard !historicalData.isEmpty else { return }
        let lastValue = historicalData.last!.value
        let firstValue = historicalData.first!.value
        let changeFromFirst: Double = (lastValue / firstValue) - 1
        let percentChange = changeFromFirst.convertToPercent() + "%"
        cell.totalChangeLabel.text = percentChange
    }
    
    let activityView = UIActivityIndicatorView(style: .medium)
    
    func handleLoadingState() {
        if isLoading {
            configuringCell?.addSubview(activityView)
            activityView.centerInSuperview()
            activityView.startAnimating()
        } else {
            activityView.removeFromSuperview()
        }
        
        if historicalData.isEmpty && !isLoading {
            configuringCell?.totalChangeLabel.text = "No data"
        }
    }
    
}

