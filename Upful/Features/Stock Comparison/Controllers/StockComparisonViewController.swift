//
//  StockComparisonViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/26/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

/// Used to abstract dependency injection logic from ViewControllers within Navigation stack.
protocol NavigationConstructor {
    var navigationController: UINavigationController { get set }
    func push()
}

class StockComparisonConstructor: NavigationConstructor {
    
    let tickerToCompare: String
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, tickerToCompare: String) {
        self.tickerToCompare = tickerToCompare
        self.navigationController = navigationController
    }
    
    func push() {
        let viewModel = StockComparisonViewModel(mainTicker: tickerToCompare)
        let viewController = StockComparisonViewController(comparisonViewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

final class StockComparisonViewController: UITableViewController {
    
    private(set) var coordinator: Coordinator?
    let comparisonViewModel: StockComparisonViewModel
    
    // MARK: - Initializer
    
    init(comparisonViewModel: StockComparisonViewModel) {
        self.comparisonViewModel = comparisonViewModel
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ValueCell")
        tableView.register(LineChartTableViewCell.self, forCellReuseIdentifier: LineChartTableViewCell.reuseID)
        tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonViewModel.handleLoadCompletion = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - View Creation
        
    func createLineChartCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LineChartTableViewCell.reuseID, for: indexPath)
            as? LineChartTableViewCell else { return UITableViewCell() }
        ComparisonLineChartViewModel.configure(cell,
                                               firstHistoricalData: comparisonViewModel.mainTickerResults,
                                               secondHistoricalData: comparisonViewModel.secondTickerResults,
                                               searchCriteria: comparisonViewModel.searchingCriteria)
        return cell
    }
    
    func createMetricComparisionCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ValueCell")
        cell.textLabel?.font = .details3
        cell.textLabel?.text = comparisonViewModel.searchingCriteria.explicit
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = VersionManager.collectionCellColor3()
        return cell
    }

    func createStocksToCompareCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricSelectionTableViewCell.reuseID, for: indexPath)
            as? MetricSelectionTableViewCell else { return UITableViewCell() }
        if row == 2 {
            cell.titleLabel.text = comparisonViewModel.mainTicker
            cell.iconView.backgroundColor = .appAccent2
        } else {
            cell.titleLabel.text = comparisonViewModel.secondTicker ?? "Select a stock to compare"
            cell.iconView.backgroundColor = .appAccent4
        }
        return cell
    }
    
    // MARK: - Actions
    
    func didSelectMetricForComparison(at row: Int) {
        let searchCriteriaSelectionVC = SearchCriteriaSelectionViewController()
        searchCriteriaSelectionVC.delegate = self
        searchCriteriaSelectionVC.currentSearchCriteria = comparisonViewModel.searchingCriteria
        parent?.present(searchCriteriaSelectionVC, animated: true, completion: nil)
    }
}

extension StockComparisonViewController {
    struct Section {
        enum First: Int, CaseIterable {
            case lineChart
            case metric
            case mainTicker
            case comparingTicker
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.First.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == Section.First.lineChart.rawValue {
            return createLineChartCell(tableView, at: indexPath)
        }
        if row == Section.First.metric.rawValue {
            return createMetricComparisionCell(tableView, at: indexPath)
        }
        if row == Section.First.mainTicker.rawValue || row == Section.First.comparingTicker.rawValue {
            return createStocksToCompareCell(tableView, at: indexPath)
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Section.First.lineChart.rawValue {
            return 275
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == Section.First.mainTicker.rawValue ||
            row == Section.First.comparingTicker.rawValue {
            let coordinator = comparisonViewModel.createCoordinatorFromTickerCellTap(in: self, at: row)
            coordinator?.start()
        }
        else if row == Section.First.metric.rawValue {
            didSelectMetricForComparison(at: row)
        }
    }
}

extension StockComparisonViewController: ChartSearchCriteriaSelectionDelegate {
    func didChangeSearchCriteria(previousSearchCriteria: SearchCriteria, updatedSearchCriteria: SearchCriteria) {
        comparisonViewModel.searchingCriteria = updatedSearchCriteria
        tableView.reloadData()
    }
}
