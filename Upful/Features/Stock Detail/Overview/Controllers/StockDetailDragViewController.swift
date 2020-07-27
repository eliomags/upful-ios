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
    func createAnalysisChartCell(_ tableView: UITableView, at indexPath: IndexPath) -> AnalysisChartCell?
    func createMetricSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> MetricSelectionTableViewCell?
}

final class StockDetailDragViewController: UIViewController {
    
    private let ticker: String
 
    private(set) var coordinator: Coordinator?
    private(set) var metricPreviewViewModels = [MetricPreviewViewModel]()
    
    let comparisonViewModel: StockComparisonViewModel

    // MARK: Views
    
    private lazy var tradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TRADE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 35 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(handleTradeTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var compareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("COMPARE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent4
        button.layer.cornerRadius = 35 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(handleCompareTap), for: .touchUpInside)
        return button
    }()
    
    let emptyMetricDataSource = EmptyStockMetricDataSource()
    let metricDisplayDataSource = MetricPreviewDataSource()
    let metricAnalysisDataSource = MetricAnalysisDataSource()
    lazy var comparisonDataSource: StockComparisonViewModel = {
        let ds = StockComparisonViewModel(mainTicker: ticker)
        return ds
    }()
    
    lazy var dragView: DragView = {
        emptyMetricDataSource.delegate = self
        metricDisplayDataSource.delegate = self
        metricAnalysisDataSource.delegate = self
        
        let firstPosition = DragControllerState(dataSource: emptyMetricDataSource, height: 100)
        let secondPosition = DragControllerState(dataSource: metricDisplayDataSource, height: 235)
        let thirdPosition = DragControllerState(dataSource: metricAnalysisDataSource, height: 475)
        let view = DragView(configuration: [firstPosition, secondPosition, thirdPosition])
        
        view.tableViewStyle = .plain
        view.tableViewPadding = .init(top: 12, left: 16, bottom: -16, right: -16)
        view.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.backgroundColor = VersionManager.collectionCellColor()
        view.tableView.separatorStyle = .singleLine
        view.tableView.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        self.comparisonViewModel = StockComparisonViewModel(mainTicker: ticker)
        super.init(nibName: nil, bundle: nil)
        createViewModels()
        dragView.tableView.register(AnalysisChartCell.self, forCellReuseIdentifier: AnalysisChartCell.reuseID)
        dragView.tableView.register(MetricPreviewTableViewCell.self, forCellReuseIdentifier: MetricPreviewTableViewCell.reuseID)
        dragView.tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
        dragView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StocksToCompareCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViewModels() {
        comparisonViewModel.handleLoadCompletion = { [weak self] in
            self?.dragView.tableView.reloadData()
        }
        
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
    
    @objc fileprivate func handleCompareTap() {
        if let navigationController = self.navigationController {
            let navigationConstructor = StockComparisonConstructor(
                                            navigationController: navigationController,
                                            tickerToCompare: ticker)
            navigationConstructor.push()
        }
    }
}

extension StockDetailDragViewController: AnalysisDragContentDelegate {
    
    func createTradeButtonFooterView(in view: UIView, topPadding: CGFloat) -> UIView? {
        let stackView = UIStackView(arrangedSubviews: [compareButton, tradeButton])
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setLeadingAnchor(padding: 16).setTrailingAnchor(padding: 16)
        
        if dragView.currentStateIndex == 0 {
            stackView.setTopAnchor(padding: 8)
        } else {
            stackView.setTopAnchor(padding: 16)
        }
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
}

extension StockDetailDragViewController: AnalysisCompareDataSourceDelegate {

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


final class SavedStockCoordinator: Coordinator {
    
    var presenter: UIViewController
    let presenting = TableItemDisplayViewController(style: .insetGrouped)

    var selectedTicker: String?
    var fetch = LocalStockLoader().loadSavedStocks
        
    init(presenter: UIViewController, selectedTicker: String?) {
        self.presenter = presenter
        self.selectedTicker = selectedTicker
    }
    
    func start() {
        (presenter.parent ?? presenter).present(presenting, animated: true, completion: nil)
        
        fetch { [weak self] result in
            switch result {
            case .success(let savedStocks):
                let tableItems = savedStocks.map {
                    TableItemDisplayViewController
                        .Item(title: $0.ticker, subtitle: $0.name)
                }
                if let selectedTicker = self?.selectedTicker {
                    self?.presenting.currentlySelectedIndexPath = tableItems.firstIndex(where: { $0.title == selectedTicker })
                }
                self?.presenting.items = tableItems
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

final class TableItemDisplayViewController: UITableViewController {
    
    struct Item {
        let title: String
        let subtitle: String?
    }
    var currentlySelectedIndexPath: Int?
    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    var handleCellSelection: ((Item) -> Void)?
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ValueCell")
        cell.textLabel?.text = items[indexPath.row].title
        cell.textLabel?.font = .details4
        
        cell.detailTextLabel?.text = items[indexPath.row].subtitle
        cell.detailTextLabel?.font = .details3
        cell.detailTextLabel?.textColor = .gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: { [unowned self] in
            self.handleCellSelection?(self.items[indexPath.item])
        })
    }
}
