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
    
    // MARK: - MenuBarDisplay Protocol
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    
    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    let intrinioApi: IntrinioAPI
    
    // MARK: - State

    private enum ReuseID {
        static let graphCell = "graphCell"
        static let graphConfigurationCell = "graphConfigurationCell"
        static let reportsCell = "reportsCell"
    }
    
    /// Charting Related Data
    private var lineCriteria: SearchCriteria = .revenuegrowth {
        didSet {
            fetchLineData(criteria: lineCriteria)
            listenForDataCompletion()
        }
    }
    
    private var barCriteria: SearchCriteria = .netincome {
        didSet {
            fetchBarData(criteria: barCriteria)
            listenForDataCompletion()
        }
    }
    
    private var chartData: [[CompanyHistoricalDatum]] {
        return []
    }
    
    private var barChartData: [CompanyHistoricalDatum] = []
    private var lineChartData: [CompanyHistoricalDatum] = []
    private var feedData: [[Any]] {
        return [
            [chartData, lineCriteria,barCriteria]
        ]
    }
    
    private var isLoading: Bool = false {
        didSet {
            observeStateChanges(isLoading)
        }
    }
    
    private func observeStateChanges(_ isLoading: Bool) {
        if isLoading {
            LoadingViewPresenter.show(in: self)
        } else {
            LoadingViewPresenter.remove()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.refreshingControl.endRefreshing()
            }
        }
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
    
    init(ticker: String, companyName: String, networkingAPI: IntrinioAPI) {
        self.ticker = ticker
        self.companyName = companyName
        self.intrinioApi = networkingAPI
        super.init(nibName: nil, bundle: nil)
        title = "Analysis"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground()
        setUpPremiumButton()
        setupViews()
        loadChart()
        listenForDataCompletion()
    }
    
    // MARK: - Actions
    
    @objc private func refreshData(_ sender: Any) {
        loadChart()
        listenForDataCompletion()
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
    
    fileprivate func configureLineData(chartView: CombinedLineChartView, criteria: SearchCriteria) {
        if lineChartData.isEmpty { return }
        chartView.generateLineData(dataPoints: lineChartData.map({ $0.date.formatDate()}),
                                   values: lineChartData.map({$0.value}),
                                   criteria: criteria)
    }
    
    fileprivate func configureBarData(chartView: CombinedLineChartView, criteria: SearchCriteria) {
        if barChartData.isEmpty { return }
        chartView.generateBarData(dataPoints: barChartData.map({ $0.date.formatDate()}),
                                  values: barChartData.map({$0.value}),
                                  criteria: criteria)
    }
    
    // MARK: - Delegate Methods
    
    /// ChartUpdatable protocol which updates the chart from the selected search criteria in SearchSelectionViewController
    func updateChartData(chartType: ChartType, criteria: SearchCriteria) {
        switch chartType {
        case .bar:
            barCriteria = criteria
        case .line:
            lineCriteria = criteria
        }
    }
    
    // MARK: - Private Functions
    
    let analysisDataGroup = DispatchGroup()

    fileprivate func fetchBarData(criteria: SearchCriteria) {
        isLoading = true
        analysisDataGroup.enter()
        let isPremium = PermissionManager.shared.isPremium

        if criteria == .none {
            barChartData.removeAll()
            self.analysisDataGroup.leave()
            return
        }
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: criteria,
                                                frequency: .historic(isPremium: isPremium)) { [weak self] (results) in
            guard let self = self else { return }
            switch results {
            case .success(let downloadedData):
                self.barChartData = downloadedData
                self.analysisDataGroup.leave()
            case .failure(let error):
                print(error.localizedDescription)
                self.analysisDataGroup.leave()
            }
        }
    }
    
    fileprivate func fetchLineData(criteria: SearchCriteria) {
        isLoading = true
        analysisDataGroup.enter()
        let isPremium = PermissionManager.shared.isPremium

        if criteria == .none {
            lineChartData.removeAll()
            self.analysisDataGroup.leave()
            return
        }
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: criteria,
                                                frequency: .historic(isPremium: isPremium)) { [weak self] (results) in
            guard let self = self else { return }

            switch results {
            case .success(let downloadedData):
                self.lineChartData = downloadedData
                self.analysisDataGroup.leave()
                
            case .failure(let error):
                self.analysisDataGroup.leave()
                print(error)
            }
        }
    }
    
    fileprivate func listenForDataCompletion() {
        analysisDataGroup.notify(queue: .main) { [weak self] in self?.isLoading = false }
    }
    
    fileprivate func loadChart() {
        fetchLineData(criteria: lineCriteria)
        fetchBarData(criteria: barCriteria)
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
    func numberOfSections(in tableView: UITableView) -> Int { return feedData.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return feedData[section].count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0:
                // MARK: - Graph Cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath) as? AnalysisChartCell else { return UITableViewCell() }
                cell.chartView.delegate = self
                if !isLoading {
                    configureBarData(chartView: cell.chartView, criteria: barCriteria)
                    configureLineData(chartView: cell.chartView, criteria: lineCriteria)
                }
                
                return cell
            case 1,2:
                // MARK: - Cells For Graph Data
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphConfigurationCell, for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
                guard let criteria = feedData[indexPath.section][indexPath.row] as? SearchCriteria else { return cell }
                cell.titleLabel.text = "\(criteria.explicit)"
                if indexPath.row == 1 { cell.iconView.backgroundColor = .appAccent }
                if indexPath.row == 2 { cell.iconView.backgroundColor =  .appAccent3 }
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
        let header = LargeSectionHeaderLabel(padding: 16)
        header.backgroundColor = .clear
        if !isLoading {
            let headerText = ["COMPARISON"]
            header.text = headerText[section].uppercased()
            return header
        }
        return nil
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
        if section == feedData.count - 1 {
            return 70
        } else {
            return 25
        }
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
            loadChart()
            listenForDataCompletion()
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

