//
//  StockDetailDragViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import YSDraggy

protocol AnalysisDragContentDelegate: class {
    func createTradeButtonFooterView(in view: UIView, topPadding: CGFloat) -> UIView?
    func didSelectMetricPreviewCell(at row: Int)
}

protocol MetricPreviewDataSourceDelegate: AnalysisDragContentDelegate {
    func createMetricPreviewHeader(in view: UIView) -> UIView?
    func createMetricPreviewCell(_ tableView: UITableView, at indexPath: IndexPath) -> MetricPreviewTableViewCell?
}

protocol AnalysisCompareDataSourceDelegate: AnalysisDragContentDelegate {
    func didChangeDataSource(selectedIndex: Int)
    func createDataSourceSelectionHeader(in view: UIView) -> UIView
    func createAnalysisChartCell(_ tableView: UITableView, at indexPath: IndexPath) -> AnalysisChartCell?
    func createMetricSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> MetricSelectionTableViewCell?
}

final class StockDetailDragViewController: UIViewController {
    
    private let ticker: String
    
    private(set) var coordinator: Coordinator?
    private(set) var metricPreviewViewModels = [MetricPreviewViewModel]()

    // MARK: Views
    
    private lazy var tradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TRADE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 44 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(handleTradeTap), for: .touchUpInside)
        return button
    }()
    
    let emptyMetricDataSource = EmptyStockMetricDataSource()
    let metricDisplayDataSource = MetricPreviewDataSource()
    let metricAnalysisDataSource = MetricAnalysisDataSource()
    
    lazy var dragView: DragView = {
        emptyMetricDataSource.delegate = self
        metricDisplayDataSource.delegate = self
        metricAnalysisDataSource.delegate = self
        
        let firstPosition = DragControllerState(dataSource: emptyMetricDataSource, height: 102)
        let secondPosition = DragControllerState(dataSource: metricDisplayDataSource, height: 235)
        let thirdPosition = DragControllerState(dataSource: metricAnalysisDataSource, height: 500)
        let view = DragView(configuration: [firstPosition, secondPosition, thirdPosition])
        
        view.tableViewStyle = .plain
        view.tableViewPadding = .init(top: 8, left: 16, bottom: -12, right: -16)
        view.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.separatorStyle = .singleLine
        view.tableView.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var headerControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Analyze", "Compare"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleSegmentControlTap), for: .valueChanged)
        return control
    }()
    
    // MARK: Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
        createViewModels()
        dragView.tableView.register(AnalysisChartCell.self, forCellReuseIdentifier: AnalysisChartCell.reuseID)
        dragView.tableView.register(MetricPreviewTableViewCell.self, forCellReuseIdentifier: MetricPreviewTableViewCell.reuseID)
        dragView.tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViewModels() {
        metricPreviewViewModels = [
            MetricPreviewViewModel(ticker: ticker, searchCriteria: .pricetoearnings),
            MetricPreviewViewModel(ticker: ticker, searchCriteria: .ebitmargin)
        ]
        
        metricPreviewViewModels.forEach({
            $0.delegate = self
            $0.loadHistoricalData()
        })
    }
    
    // MARK: Actions
        
    @objc fileprivate func handleTradeTap() {
        let presentingViewController = parent ?? self
        coordinator = StockTradeCoordinator(presentingViewController, ticker: ticker)
        coordinator?.start()
    }
    
    @objc fileprivate func handleSegmentControlTap(_ sender: UISegmentedControl) {
        print("sender changed to", sender.selectedSegmentIndex)
    }
}
extension StockDetailDragViewController: AnalysisDragContentDelegate {
    
    func createTradeButtonFooterView(in view: UIView, topPadding: CGFloat) -> UIView? {
        let view = UIView()
        view.backgroundColor = VersionManager.collectionCellColor()
        view.addSubview(tradeButton)
        tradeButton
            .setTopAnchor(padding: topPadding)
            .setTrailingAnchor(padding: 8)
        
        return view
    }
    
    func createMetricPreviewHeader(in view: UIView) -> UIView? {
        if let firstMetricViewModel = metricPreviewViewModels.first,
            let lastMetricViewModel = metricPreviewViewModels.last {
            
            let firstVMStartDate = firstMetricViewModel.historicalData.first?.date ?? ""
            let firstVMEndDate = firstMetricViewModel.historicalData.last?.date ?? ""
            let lastVMStartDate = lastMetricViewModel.historicalData.first?.date ?? ""
            let lastVMEndDate = lastMetricViewModel.historicalData.last?.date ?? ""
            
            var startDate = firstVMStartDate.isEmpty ? lastVMStartDate : firstVMStartDate
            var endDate = firstVMEndDate.isEmpty ? lastVMEndDate : firstVMEndDate
            
            if !startDate.isEmpty { startDate = String(Array(startDate)[0...3]) }
            if !endDate.isEmpty { endDate = String(Array(endDate)[0...3]) }
            
            let headerView = UIView()
            headerView.backgroundColor = VersionManager.collectionCellColor()
            let titleLabel = UILabel()
            titleLabel.text = "\(startDate) - \(endDate)"
            titleLabel.textAlignment = .right
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
            titleLabel.textColor = .darkGray
            headerView.addSubview(titleLabel)
            titleLabel.setCenterYAnchor(padding: 0).setTrailingAnchor(padding: 8)
            return headerView
        } else {
            return nil
        }
    }
    
    func createMetricPreviewCell(_ tableView: UITableView, at indexPath: IndexPath) -> MetricPreviewTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricPreviewTableViewCell.reuseID, for: indexPath) as? MetricPreviewTableViewCell else { return nil }
        cell.backgroundColor = VersionManager.collectionCellColor3()
        let metricViewModel = metricPreviewViewModels[indexPath.row]
        metricViewModel.configureCell(cell)
        return cell
    }
}

extension StockDetailDragViewController: MetricPreviewDataSourceDelegate {
    
    func didSelectMetricPreviewCell(at row: Int) {
        let searchCriteriaSelectionVC = SearchCriteriaSelectionViewController()
        searchCriteriaSelectionVC.delegate = self
        searchCriteriaSelectionVC.currentSearchCriteria = metricPreviewViewModels[row].searchCriteria
        parent?.present(searchCriteriaSelectionVC, animated: true, completion: nil)
    }
    
    func createDataSourceSelectionHeader(in view: UIView) -> UIView {
        view.backgroundColor = VersionManager.collectionCellColor()
        view.addSubview(headerControl)
        headerControl.setCenterYAnchor(padding: 0).setLeadingAnchor(padding: 32).setTrailingAnchor(padding: 32)
        return view
    }
}

extension StockDetailDragViewController: AnalysisCompareDataSourceDelegate {
    
    func didChangeDataSource(selectedIndex: Int) {
        print("something happened here lol")
    }
    
    func createAnalysisChartCell(_ tableView: UITableView, at indexPath: IndexPath) -> AnalysisChartCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnalysisChartCell.reuseID, for: indexPath)
            as? AnalysisChartCell
        if let firstVM = metricPreviewViewModels.first, let secondVM = metricPreviewViewModels.last {
            guard !firstVM.historicalData.isEmpty else { return cell }
            let firstVMValues = firstVM.historicalData.map { $0.value }
            let secondVMValues = secondVM.historicalData.map { $0.value }
            let firstVMDates = firstVM.historicalData.map { $0.date.formatDate() }
            let secondVMDates = secondVM.historicalData.map { $0.date.formatDate() }
            cell?.chartView.generateBarData(dataPoints: secondVMDates, values: secondVMValues, criteria: secondVM.searchCriteria)
            cell?.chartView.generateLineData(dataPoints: firstVMDates, values: firstVMValues, criteria: firstVM.searchCriteria)
        }
        return cell
    }
    
    func createMetricSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> MetricSelectionTableViewCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MetricSelectionTableViewCell.reuseID, for: indexPath)
            as? MetricSelectionTableViewCell {
            let criteria = metricPreviewViewModels[indexPath.row-1].searchCriteria
            cell.titleLabel.text = criteria.explicit
            cell.iconView.backgroundColor = indexPath.row == 1 ? .appAccent : .appAccent3
            return cell
        } else {
            return nil
        }
    }
}

extension StockDetailDragViewController: ChartSearchCriteriaSelectionDelegate {
    func didChangeSearchCriteria(previousSearchCriteria: SearchCriteria, updatedSearchCriteria: SearchCriteria) {
        let viewModel = metricPreviewViewModels.first(where: { $0.searchCriteria == previousSearchCriteria })
        viewModel?.searchCriteria = updatedSearchCriteria
    }
}

extension StockDetailDragViewController: MetricPreviewViewModelDelegate {
    func didLoadCellData(cell: MetricPreviewTableViewCell?) {
        dragView.tableView.reloadData()
    }
}
