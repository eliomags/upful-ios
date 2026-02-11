//
//  StockOverviewDatasource.swift
//  Upful
//
//  Created by Yanik Simpson on 7/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import DGCharts

protocol StockOverViewDataSourceDelegate: class {
    func didSelectNews(tableView: UITableView, urlString: String)
    func didScroll(scrollView: UIScrollView)
}

final class StockOverviewDatasource: NSObject {
    
    weak var delegate: StockOverViewDataSourceDelegate?
    
    let viewModel: StockOverviewViewModel
    let stockPerformanceViewModel: StockPerformanceChartViewModel
    
    init(stockOverviewViewModel: StockOverviewViewModel, stockPerformanceViewModel: StockPerformanceChartViewModel) {
        self.viewModel = stockOverviewViewModel
        self.stockPerformanceViewModel = stockPerformanceViewModel
    }
    
    // MARK: Methods
    
    func loadData() {
        viewModel.loadData()
        stockPerformanceViewModel.loadInitialDataPoints(dispatchGroup: viewModel.loadingOperations)
        viewModel.listenForUpdates()
    }
    
    // MARK: Helper Methods
    
    private func configureChart(chartView: GenericBarChartView) {
        guard !viewModel.historicalRevenue.isEmpty && !viewModel.historicalEarnings.isEmpty else { return }
        chartView.setupChart(
            dataPoints: viewModel.historicalRevenue.map { $0.date.formatDate() },
            values: viewModel.historicalRevenue.map { $0.value },
            values1: viewModel.historicalEarnings.map { $0.value })
    }
    
    // MARK: ScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(scrollView: scrollView)
    }
}

extension StockOverviewDatasource: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == StockDetailsModuleConstants.Section.news.rawValue {
            return viewModel.stockNews.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return StockDetailsModuleConstants.Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case StockDetailsModuleConstants.Section.price.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockDetailsModuleConstants.ReuseID.performanceCell, for: indexPath)
                as? PerformanceCell else { return UITableViewCell() }
            stockPerformanceViewModel.configure(cell, tableView: tableView)
            return cell
            
        case StockDetailsModuleConstants.Section.barGraph.rawValue:
            guard let barGraphCell = tableView.dequeueReusableCell(withIdentifier: StockDetailsModuleConstants.ReuseID.graphCell, for: indexPath)
                as? BarGraphTableViewCell else { return UITableViewCell() }
            barGraphCell.backgroundColor = .clear
            barGraphCell.chartView.delegate = self
            configureChart(chartView: barGraphCell.chartView)
            return barGraphCell
            
        case StockDetailsModuleConstants.Section.calculations.rawValue:
            guard let calculationsCell = tableView.dequeueReusableCell(withIdentifier: StockDetailsModuleConstants.ReuseID.calculationsCell, for: indexPath)
                as? DetailsCalculationCell else { return UITableViewCell() }
            calculationsCell.setupCell(with: viewModel.calcData)
            calculationsCell.setupWithLookUp(lookUp: viewModel.financialLookup)
            return calculationsCell
            
        case StockDetailsModuleConstants.Section.news.rawValue:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: StockDetailsModuleConstants.ReuseID.newsCell, for: indexPath)
                as? SmallNewsCell else { return UITableViewCell() }
            newsCell.stockNews = viewModel.stockNews[indexPath.row]
            return newsCell
            
        case StockDetailsModuleConstants.Section.description.rawValue:
            guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: StockDetailsModuleConstants.ReuseID.descriptionCellID, for: indexPath)
                as? StockDescriptionCell else { return UITableViewCell() }
            descriptionCell.descriptionLabel.text = viewModel.stockDetail?.description ?? ""
            descriptionCell.employeeStackView.valueLabel.text = String(viewModel.stockDetail?.employees ?? 0)
            descriptionCell.locationStackView.valueLabel.text = "\(viewModel.stockDetail?.city ?? ""),\(viewModel.stockDetail?.state ?? "")"
            return descriptionCell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case StockDetailsModuleConstants.Section.price.rawValue:
            return 200
        case StockDetailsModuleConstants.Section.barGraph.rawValue:
            return 300
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableSectionHeaderView()
        let headerText = ["", "Financials", "Metrics", "News", "About"]
        header.headerTextLabel.text = headerText[section]
        header.addButton.setTitle("", for: .normal)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == StockDetailsModuleConstants.Section.price.rawValue { return 0 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? SmallNewsCell else { return }
        AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)
        
        let newsURLString = viewModel.stockNews[indexPath.row].newsUrl
        delegate?.didSelectNews(tableView: tableView, urlString: newsURLString)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == StockDetailsModuleConstants.Section.allCases.count-1 {
            return 80 
        } else {
            return 25
        }
    }
}

extension StockOverviewDatasource: ChartViewDelegate {}
