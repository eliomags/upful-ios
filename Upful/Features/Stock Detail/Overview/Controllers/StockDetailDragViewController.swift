//
//  StockDetailDragViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockDetailDragViewController: UIViewController {
    
    let ticker: String
    
    private(set) var coordinator: Coordinator?
    private(set) var metricPreviewViewModels = [MetricPreviewViewModel]()

    // MARK: Views
    
    lazy var tradeButton: UIButton = {
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
        let dragConfig = DragStateConfiguration(closedHeight: 112, partialHeight: 235, fullHeight: 450)
        let view = DragView(configuration: dragConfig)
        view.controller.currentPosition = DragViewPresentationState.closed.rawValue
        view.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.showsVerticalScrollIndicator = false
        view.tableView.separatorStyle = .singleLine
        return view
    }()
    
    // MARK: Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
        dragView.tableView.register(AnalysisChartCell.self, forCellReuseIdentifier: AnalysisChartCell.reuseID)
        dragView.tableView.register(MetricPreviewTableViewCell.self, forCellReuseIdentifier: MetricPreviewTableViewCell.reuseID)
        dragView.tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
        createViewModels()
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
    
    // MARK: ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= -44 {
            dragView.controller.changeState(for: dragView.bounds.height-250)
        }
    }
    
    // MARK: Actions
        
    @objc fileprivate func handleTradeTap() {
        let presentingViewController = parent ?? self
        coordinator = StockTradeCoordinator(presentingViewController, ticker: ticker)
        coordinator?.start()
    }
    
    // MARK: Full State View Configuration
    
    fileprivate func displayCellForFullState(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let row = indexPath.row
        if row == Sections.Full.chart.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnalysisChartCell.reuseID, for: indexPath)
                as? AnalysisChartCell else { return UITableViewCell() }
            cell.backgroundColor = VersionManager.collectionCellColor3()

            if let firstVM = metricPreviewViewModels.first, let secondVM = metricPreviewViewModels.last {
                guard !firstVM.historicalData.isEmpty else { return cell }
                let firstVMValues = firstVM.historicalData.map { $0.value }
                let secondVMValues = secondVM.historicalData.map { $0.value }
                let firstVMDates = firstVM.historicalData.map { $0.date.formatDate() }
                let secondVMDates = secondVM.historicalData.map { $0.date.formatDate() }
                cell.chartView.generateBarData(dataPoints: secondVMDates, values: secondVMValues, criteria: secondVM.searchCriteria)
                cell.chartView.generateLineData(dataPoints: firstVMDates, values: firstVMValues, criteria: firstVM.searchCriteria)
            }
            return cell
        }
        else if row == 1 || row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MetricSelectionTableViewCell.reuseID, for: indexPath)
                as? MetricSelectionTableViewCell {
                cell.backgroundColor = VersionManager.collectionCellColor3()
                
                let criteria = metricPreviewViewModels[row-1].searchCriteria
                cell.titleLabel.text = criteria.explicit
                cell.iconView.backgroundColor = row == 1 ? .appAccent : .appAccent3

                return cell
            }
        }
        return UITableViewCell()
    }
    
    fileprivate func heightsForCell(_ row: Int) -> CGFloat {
        switch dragView.controller.currentPresentationState {
        case .closed, .partial:
            return UITableView.automaticDimension
        case .full:
            if row == Sections.Full.chart.rawValue {
                return 245
            } else {
                return UITableView.automaticDimension
            }
        }
    }
    
    private func handleSearchCriteriaTap(row: Int) {
        let searchCriteriaSelectionVC = SearchCriteriaSelectionViewController()
        searchCriteriaSelectionVC.delegate = self
        searchCriteriaSelectionVC.currentSearchCriteria = metricPreviewViewModels[row].searchCriteria
        parent?.present(searchCriteriaSelectionVC, animated: true, completion: nil)
    }
}

extension StockDetailDragViewController: UITableViewDataSource {
    
    struct Sections {
        enum Full: Int, CaseIterable {
            case chart
            case metricOne
            case metricTwo
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dragView.controller.currentPresentationState {
        case .closed:
            return 0
        case .partial:
            return metricPreviewViewModels.count
        case .full:
            return Sections.Full.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dragView.controller.currentPresentationState {
        case .partial, .closed:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricPreviewTableViewCell.reuseID, for: indexPath)
                as? MetricPreviewTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = VersionManager.collectionCellColor3()
            let metricViewModel = metricPreviewViewModels[indexPath.row]
            metricViewModel.configureCell(cell)
            return cell
        case .full:
            return displayCellForFullState(indexPath, tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dragView.controller.currentPresentationState {
        case .closed:
            fatalError("Does not exist")
         case .partial:
            handleSearchCriteriaTap(row: indexPath.row)
        case .full:
            let row = indexPath.row
            if row == Sections.Full.metricOne.rawValue || row == Sections.Full.metricTwo.rawValue {
                handleSearchCriteriaTap(row: row-1)
            }
        }
    }
}
extension StockDetailDragViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightsForCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMetricViewModel = metricPreviewViewModels.first, let lastMetricViewModel = metricPreviewViewModels.last {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dragView.controller.currentPresentationState == .partial ? 25 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = VersionManager.collectionCellColor()
        footer.addSubview(tradeButton)
        var topPadding: CGFloat = 0
        switch dragView.controller.currentPresentationState {
        case .closed:
            topPadding = 0
        case .partial, .full:
            topPadding = 8
        }
        tradeButton.anchor(top: footer.topAnchor, leading: nil, bottom: nil,
                           trailing: footer.layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: topPadding, left: 4, bottom: 8, right: 0))
        return footer
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
