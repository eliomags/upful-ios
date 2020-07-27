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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ValueCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StocksToCompareCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonViewModel.handleLoadCompletion = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - View Creation
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksToCompareCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .details3
        cell.backgroundColor = VersionManager.collectionCellColor3()
        
        if row == 2 {
            cell.textLabel?.text = comparisonViewModel.mainTicker
        } else {
            cell.textLabel?.text = comparisonViewModel.secondTicker ?? "Select a stock to compare"
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
    
    func didSelectComparisonCell(at row: Int) {
        var selectedTicker: String?
        if row == 2 {
            selectedTicker = comparisonViewModel.mainTicker
        } else {
            selectedTicker = comparisonViewModel.secondTicker
        }
        
        let savedStockCoordinator = SavedStockCoordinator(presenter: self, selectedTicker: selectedTicker)
        savedStockCoordinator.presenting.handleCellSelection = { [unowned self] item in
            if row == 2 {
                self.comparisonViewModel.mainTicker = item.title
            } else {
                self.comparisonViewModel.secondTicker = item.title
            }
            self.tableView.reloadData()
        }
        
        coordinator = savedStockCoordinator
        coordinator?.start()
    }
}

extension StockComparisonViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            
        }
        if row == 1 {
            return createMetricComparisionCell(tableView, at: indexPath)
        }
        if row == 2 || row == 3 {
            return createStocksToCompareCell(tableView, at: indexPath)
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 275
        }
        return UITableView.automaticDimension
    }
}

extension StockComparisonViewController: ChartSearchCriteriaSelectionDelegate {
    func didChangeSearchCriteria(previousSearchCriteria: SearchCriteria, updatedSearchCriteria: SearchCriteria) {
        comparisonViewModel.searchingCriteria = updatedSearchCriteria
        tableView.reloadData()
    }
}
