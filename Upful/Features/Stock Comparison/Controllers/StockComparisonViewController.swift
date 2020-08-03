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

final class StockComparisonViewController: UIViewController {
    
    private(set) var coordinator: Coordinator?
    let comparisonViewModel: StockComparisonViewModel
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.layer.cornerRadius = 16
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: - Initializer
    
    init(comparisonViewModel: StockComparisonViewModel) {
        self.comparisonViewModel = comparisonViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        let width = UIScreen.main.bounds.width - 32
        tableView.setCenterXAnchor(padding: 0).setCenterYAnchor(padding: 0)
        tableView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,
                         size: CGSize(width: width, height: 425))
        tableView.backgroundColor = .systemBackground
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.4)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ValueCell")
        tableView.register(LineChartTableViewCell.self, forCellReuseIdentifier: LineChartTableViewCell.reuseID)
        tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
        

//            UIColor.init() { (trait) -> UIColor in
//                if trait.userInterfaceStyle == .dark {
//                    self.containerView.setupShadow(intensity: .light, color: VersionManager.collectionCellColor())
//                }
//                if trait.userInterfaceStyle == .light {
//                    self.containerView.setupShadow(intensity: .light, color: .label)
//                }
//                return UIColor(white: 0.1, alpha: 0.4)
//        }
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
            cell.iconView.backgroundColor = .appAccent2
            cell.titleLabel.text = comparisonViewModel.mainTicker
        } else {
            cell.iconView.backgroundColor = .appAccent4
            cell.titleLabel.text = comparisonViewModel.secondTicker ?? "Select a stock to compare"
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

extension StockComparisonViewController: UITableViewDataSource, UITableViewDelegate {
    struct Section {
        enum First: Int, CaseIterable {
            case lineChart
            case metric
            case mainTicker
            case comparingTicker
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.First.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Section.First.lineChart.rawValue {
            return 275
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == Section.First.mainTicker.rawValue ||
            row == Section.First.comparingTicker.rawValue {
            let coordinator = comparisonViewModel.createCoordinatorFromTickerCellTap(in: self, at: row)
            coordinator?.start()
        } else if row == Section.First.metric.rawValue {
            didSelectMetricForComparison(at: row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StockComparisonViewController: ChartSearchCriteriaSelectionDelegate {
    func didChangeSearchCriteria(previousSearchCriteria: SearchCriteria, updatedSearchCriteria: SearchCriteria) {
        comparisonViewModel.searchingCriteria = updatedSearchCriteria
        tableView.reloadData()
    }
}
