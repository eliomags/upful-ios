//
//  StockComparisonViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/26/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockComparisonPresenter {
    
    let tickerToCompare: String
    var presenting: UIViewController
    
    init(_ presenting: UIViewController, ticker: String) {
        self.presenting = presenting
        self.tickerToCompare = ticker
    }
    
    func present() {
        let viewModel = StockComparisonViewModel(mainTicker: tickerToCompare)
        let viewController = StockComparisonViewController(comparisonViewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        presenting.present(viewController, animated: true, completion: nil)
    }
}

final class StockComparisonViewController: UIViewController {
    
    private(set) var coordinator: Coordinator?
    let comparisonViewModel: StockComparisonViewModel
    
    lazy var tableView: UITableView = makeTableView()
    lazy var closeButton: CancelButton = makeCancelButton()
    lazy var contentContainerView: UIView = createContainerView()

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
        view.addSubview(contentContainerView)
        contentContainerView.setCenterXAnchor(padding: 0).setBottomAnchor(padding: 32)
        
        contentContainerView.addSubview(tableView)
        tableView.fillSuperview(padding: .init(top: 22, left: 0, bottom: 16, right: 0))
        
        contentContainerView.addSubview(closeButton)
        closeButton.setTopAnchor(padding: 16).setLeadingAnchor(padding: 16)
        
        tableView.backgroundColor = .clear
        view.backgroundColor = .dimmedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ValueCell")
        tableView.register(LineChartTableViewCell.self, forCellReuseIdentifier: LineChartTableViewCell.reuseID)
        tableView.register(MetricSelectionTableViewCell.self, forCellReuseIdentifier: MetricSelectionTableViewCell.reuseID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparisonViewModel.loadCompletionHandler.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - View Creation
    
    func makeTableView() -> UITableView {
        let view = UITableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }
    
    func makeCancelButton() -> CancelButton {
        let button = CancelButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCancel))
        button.addGestureRecognizer(tapGesture)
        return button
    }

    func createContainerView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16
        let width = UIScreen.main.bounds.width - 32
        view.anchor(top: nil, leading: nil,
                    bottom: nil, trailing: nil,
                    size: .init(width: width, height: 465))
        view.backgroundColor = VersionManager.collectionCellColor3()
        return view
    }
        
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
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = VersionManager.collectionCellColor3()
        cell.textLabel?.text = comparisonViewModel.searchingCriteria.explicit
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
    
    @objc func handleCancel() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectMetricForComparison(at row: Int) {
        let searchCriteriaSelectionVC = SearchCriteriaSelectionViewController()
        searchCriteriaSelectionVC.delegate = self
        searchCriteriaSelectionVC.currentSearchCriteria = comparisonViewModel.searchingCriteria
        let presentingViewController = parent ?? self
        presentingViewController.present(searchCriteriaSelectionVC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleCancel()
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
        if indexPath.row == Section.First.lineChart.rawValue { return 260 }
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
