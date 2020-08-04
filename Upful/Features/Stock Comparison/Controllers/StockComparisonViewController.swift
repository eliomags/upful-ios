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
                    size: .init(width: width, height: 545))
        view.backgroundColor = VersionManager.collectionCellColor()
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
        let magnifyingpImg = UIImage(systemName: "magnifyingglass.circle.fill")?
            .withTintColor(.appAccent4, renderingMode: .alwaysOriginal)
        let magImgView = UIImageView(image: magnifyingpImg)
            .setHeightConstraint(constant: 36)
            .setWidthConstraint(constant: 36)
        
        let label = UILabel()
        label.font = .details3
        label.text = comparisonViewModel.searchingCriteria.explicit
        
        let sv = UIStackView(arrangedSubviews: [magImgView, label])
        sv.spacing = 12
        cell.addSubview(sv)
        sv.setLeadingAnchor(padding: 16).setCenterYAnchor(padding: 0)
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = VersionManager.collectionCellColor3()
        return cell
    }

    func createStocksToCompareCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricSelectionTableViewCell.reuseID, for: indexPath)
            as? MetricSelectionTableViewCell else { return UITableViewCell() }
        if row == 0 {
            cell.iconView.backgroundColor = .appAccent2
            cell.titleLabel.text = comparisonViewModel.mainTicker
        } else {
            cell.iconView.backgroundColor = .appAccent4
            cell.titleLabel.text = comparisonViewModel.secondTicker ?? "Tap to compare"
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
    enum Section: Int, CaseIterable {
        case lineChart
        case metric
        case compareStock
        
        var title: String {
            switch self {
            case .metric:
                return "Metric"
            case .compareStock:
                return "Stocks"
            default:
                return ""
            }
        }
        enum Row: Int, CaseIterable {
            case lineChart
            case metric
            case mainTicker
            case comparingTicker
            
            func getIndexPath() -> IndexPath {
                switch self {
                case .lineChart:
                    return IndexPath(row: 0, section: 0)
                case .metric:
                    return IndexPath(row: 0, section: Section.metric.rawValue)
                case .mainTicker:
                    return IndexPath(row: 0, section: Section.compareStock.rawValue)
                case .comparingTicker:
                    return IndexPath(row: 1, section: Section.compareStock.rawValue)
                }
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.compareStock.rawValue { return 2 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == Section.Row.lineChart.getIndexPath() {
            return createLineChartCell(tableView, at: indexPath)
        }
        if indexPath == Section.Row.metric.getIndexPath() {
            return createMetricComparisionCell(tableView, at: indexPath)
        }
        if indexPath == Section.Row.mainTicker.getIndexPath() ||
            indexPath == Section.Row.comparingTicker.getIndexPath() {
            return createStocksToCompareCell(tableView, at: indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == Section.Row.lineChart.getIndexPath() { return 260 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if indexPath == Section.Row.mainTicker.getIndexPath() ||
            indexPath == Section.Row.comparingTicker.getIndexPath() {
            let coordinator = comparisonViewModel.createCoordinatorFromTickerCellTap(in: self, at: row)
            coordinator?.start()
        } else if indexPath == Section.Row.metric.getIndexPath() {
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
