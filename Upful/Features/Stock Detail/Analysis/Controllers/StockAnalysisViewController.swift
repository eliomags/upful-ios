//
//  StockAnalysisViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

class StockAnalysisViewController: UIViewController, ChartViewDelegate, ChartUpdatable {
    
    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    
    private(set) lazy var viewModel: StockAnalysisViewModel = {
        let vm = StockAnalysisViewModel(ticker: ticker)
        return vm
    }()
    
    // MARK: - Constants

    private enum ReuseID {
        static let graphCell = "graphCell"
        static let reportsCell = "reportsCell"
        static let graphConfigurationCell = "graphConfigurationCell"
    }
    
    // MARK: - Views
    
    lazy var get5YearDataButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Unlock 5 Year Data", for: .normal)
        b.backgroundColor = UIColor.appAccent3.withAlphaComponent(0.9)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 15
        b.translatesAutoresizingMaskIntoConstraints = false
        b.widthAnchor.constraint(equalToConstant: 150).isActive = true
        b.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return b
    }()
    
    private lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = companyName
        v.headerLabel.text = ticker
        return v
    }()
    
    private lazy var refreshingControl: UIRefreshControl = { 
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(AnalysisChartCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tv.register(GenericTableViewCell.self, forCellReuseIdentifier: ReuseID.graphConfigurationCell)
        tv.register(NewsCell.self, forCellReuseIdentifier: ReuseID.reportsCell)
        tv.setTableHeaderView(headerView: stockHeaderView)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
        super.init(nibName: nil, bundle: nil)
        title = "Analysis"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground()
        setUpPremiumButton()
        setupViews()
    
        handleStateUpdate()
    }
    
    // MARK: - State Updates
    
    fileprivate func handleStateUpdate() {
        LoadingViewPresenter.show(in: self)
        viewModel.configureAnalysisItems()

        viewModel.updateHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshingControl.endRefreshing()
            LoadingViewPresenter.remove()
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshData(_ sender: Any) {
        handleStateUpdate()
    }
    
    @objc private func handle5YearDataInterest(_ sender: UIButton) {
        let presenter = SubscriptionPresenter(type: .fiveYearDataInterest)
        presenter.present(in: self)
    }
    
    // MARK: - View Setup
    
    private func setUpPremiumButton() {
        if !PermissionManager.shared.isPremium {
            stockHeaderView.accessoryStackView.addArrangedSubview(get5YearDataButton)
            get5YearDataButton.addTarget(self, action: #selector(handle5YearDataInterest), for: .touchUpInside)
        }
    }
    
    private func setupViews() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.refreshControl = refreshingControl
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - Chart Cell Update
    
    fileprivate func configureLineData(chartView: CombinedLineChartView) {
        chartView.generateLineData(dataPoints: viewModel.lineAnalysisItem?.data.map { $0.date.formatDate() } ?? [],
                                   values: viewModel.lineAnalysisItem?.data.map { $0.value } ?? [],
                                   criteria: viewModel.lineAnalysisItem?.searchCriteria ?? .revenuegrowth)
    }
    
    fileprivate func configureBarData(chartView: CombinedLineChartView) {
        chartView.generateBarData(dataPoints: viewModel.barAnalysisItem?.data.map { $0.date.formatDate() } ?? [],
                                  values: viewModel.barAnalysisItem?.data.map { $0.value } ?? [],
                                  criteria: viewModel.barAnalysisItem?.searchCriteria ?? .revenuegrowth)
    }
    
    // MARK: - Delegate Methods
    
    /// ChartUpdatable protocol which updates the chart from the selected search criteria in SearchSelectionViewController
    func updateChartData(chartType: ChartType, criteria: SearchCriteria) {
        switch chartType {
        case .bar:
            viewModel.updateBarData(with: criteria)
        case .line:
            viewModel.updateLineData(with: criteria)
        }
    }
        
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bufferHeight: CGFloat = 15
        let heightThreshold: CGFloat = stockHeaderView.intrinsicContentSize.height - bufferHeight
        let reachedThreshold = scrollView.contentOffset.y > heightThreshold
        parent?.navigationItem.title = reachedThreshold ? ticker: ""
    }
}

extension StockAnalysisViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 3 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0:
                // MARK: - Graph Cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell,
                                                               for: indexPath) as? AnalysisChartCell else { return UITableViewCell() }
                cell.chartView.delegate = self
                guard viewModel.barAnalysisItem?.data.isEmpty == false else { return cell }
                guard viewModel.lineAnalysisItem?.data.isEmpty == false else { return cell }
                
                configureBarData(chartView: cell.chartView)
                configureLineData(chartView: cell.chartView)
                
                return cell
            case 1:
                // MARK: - Cells For Line Data
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphConfigurationCell,
                                                               for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
                guard let criteria = viewModel.lineAnalysisItem?.searchCriteria else { return cell }
                cell.titleLabel.text = "\(criteria.explicit)"
                cell.iconView.backgroundColor = .appAccent
                cell.selectionStyle = .gray
                return cell
            case 2:
                // MARK: - Cells For Bar Data
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphConfigurationCell,
                                                               for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
                guard let criteria = viewModel.barAnalysisItem?.searchCriteria else { return cell }
                cell.titleLabel.text = "\(criteria.explicit)"
                cell.iconView.backgroundColor =  .appAccent3
                cell.selectionStyle = .gray
                return cell
            default: break
            }
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chartType: ChartType = .bar
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 || indexPath.row == 2 {
                if indexPath.row == 1 { chartType = .line }
                if indexPath.row == 2 { chartType = .bar }
                let criteriaVC = SearchSelectionViewController(chartType: chartType)
                criteriaVC.delegate = self
                let navVC = UINavigationController(rootViewController: criteriaVC)
                self.parent?.present(navVC, animated: true, completion: nil)
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableSectionHeaderView()
        header.backgroundColor = .clear
        let headerText = ["Comparison"]
        header.headerTextLabel.text = headerText[section]
        header.addButton.setTitle("", for: .normal)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return (UIScreen.main.bounds.height / 2) - 50
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

class GenericCellImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 20).isActive = true
        widthAnchor.constraint(equalToConstant: 20).isActive = true
        layer.masksToBounds = true
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
    }
}

// MARK: - SubscriptionViewControllerDelegate Methods

extension StockAnalysisViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        if PermissionManager.shared.isPremium {
            get5YearDataButton.removeFromSuperview()
//            loadChart()
//            listenForDataCompletion()
        }
    }
}


class GenericTableViewCell: UITableViewCell {
    
    let iconView: GenericCellImageView = {
        let iv = GenericCellImageView(frame: .zero)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.details1
        label.text = "No Data"
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addBottomSeparator()
        accessoryType = .disclosureIndicator
        backgroundColor = .clear
        addSubview(contentStackView)
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        if let accessoryView = accessoryView {
            contentStackView.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -8).isActive = true
        } else {
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}

