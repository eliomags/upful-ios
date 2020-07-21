//
//  StockDetailDragViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import YSDraggy

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
    
    lazy var dragView: DragView = {
        let emptyMetricDataSource: StockDetailDragViewPresentable = EmptyStockMetricDataSource()
        let metricDisplayDataSource: StockDetailDragViewPresentable = StockMetricDisplayDataSource()
        let metricAnalysisDataSource: StockDetailDragViewPresentable = MetricAnalysisDataSource()
        [emptyMetricDataSource, metricDisplayDataSource, metricAnalysisDataSource].forEach({
            $0.createFooterIn = createFooterView
            $0.headerDisplay = createDragViewHeader
            $0.cellTapAction = handleSearchCriteriaTap
            $0.viewModels = metricPreviewViewModels
        })
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
    
    private func handleSearchCriteriaTap(row: Int) {
        let searchCriteriaSelectionVC = SearchCriteriaSelectionViewController()
        searchCriteriaSelectionVC.delegate = self
        searchCriteriaSelectionVC.currentSearchCriteria = metricPreviewViewModels[row].searchCriteria
        parent?.present(searchCriteriaSelectionVC, animated: true, completion: nil)
    }
}

extension StockDetailDragViewController {
    private func createDragViewHeader(viewModels: [MetricPreviewViewModel]) -> UIView? {
        if let firstMetricViewModel = viewModels.first, let lastMetricViewModel = viewModels.last {
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
    
    private func createFooterView(in view: UIView, topPadding: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = VersionManager.collectionCellColor()
        view.addSubview(tradeButton)
        tradeButton
            .setTopAnchor(padding: topPadding)
            .setTrailingAnchor(padding: 8)

        return view
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
