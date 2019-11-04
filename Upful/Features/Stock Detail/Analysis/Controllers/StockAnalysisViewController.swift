//
//  StockAnalysisViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

class StockAnalysisViewController: UITableViewController, ChartViewDelegate, MenuBarDisplayable, ChartUpdatable {
    
    // MARK: - MenuBarDisplay Protocol
    
    var delegate: MenuViewItemDelegate?
    var menubarTitle: String = "Analysis"
    
    
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
        didSet { fetchLineData(criteria: lineCriteria) }
    }
    
    private var barCriteria: SearchCriteria = .netincome {
        didSet { fetchBarData(criteria: barCriteria) }
    }
    
    private var chartData: [[CompanyHistoricalDatum]] {
        return []
    }
    
    private var barChartData: [CompanyHistoricalDatum] = []
    private var lineChartData: [CompanyHistoricalDatum] = []
    
    
    /// Company Filings
    private var companyFilings: [Filings] = []
    
    private var feedData: [[Any]] {
        return [
            [chartData, lineCriteria,barCriteria],
            companyFilings
        ]
    }
    
    private var isLoading: Bool = false {
        didSet {
            observeStateChanges(isLoading)
        }
    }
    
    private func observeStateChanges(_ state: Bool) {
        self.showActivitySpinner(state)
        if !state {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshingControl.endRefreshing()
                self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
            }
        }
    }

    
    // MARK: - Views
    
    private lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = companyName
        v.companyTickerLabel.text = ticker
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return v
    }()
    
    private lazy var refreshingControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    private var loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.startAnimating()
        v.addSubview(activityView)
        activityView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 30, left: 30, bottom: 30, right: 30))
        v.layer.cornerRadius = 15
        v.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return v
    }()
    
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String, networkingAPI: IntrinioAPI) {
        self.ticker = ticker
        self.companyName = companyName
        self.intrinioApi = networkingAPI
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground(in: self)
        setupViews()
        loadChart()
        fetchCompanyFilingsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    // MARK: - Actions
    
    @objc private func refreshData(_ sender: Any) {
        loadChart()
        fetchCompanyFilingsData()
    }
    
    
    // MARK: - View Setup
    
    private func setupViews() {
        tableView.register(AnalysisChartCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.graphConfigurationCell)
        tableView.register(NewsCell.self, forCellReuseIdentifier: ReuseID.reportsCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = VersionManager.mainContainerBackground(in: self)
        tableView.tableHeaderView = stockHeaderView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 10.0, *) { tableView.refreshControl = refreshingControl }
    }
    
    func showActivitySpinner(_ shouldShowSpinner: Bool) {
        if shouldShowSpinner {
            self.view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        if !shouldShowSpinner {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
            }
        }
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
    
    private func fetchCompanyFilingsData() {
        isLoading = true
        intrinioApi.getCompanyFilings(ticker: ticker) { (results) in
            switch results {
            case .success(let fetchedFilings):
                self.companyFilings = fetchedFilings
                self.isLoading = false
            case . failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }

    private func fetchBarData(criteria: SearchCriteria) {
        isLoading = true
        if criteria == .none {
            barChartData.removeAll()
            self.isLoading = false
            tableView.reloadData()
            return
        }
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker, financial: criteria, frequency: .historic) { (results) in
            switch results {
            case .success(let downloadedData):
                self.barChartData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    private func fetchLineData(criteria: SearchCriteria) {
        isLoading = true
        if criteria == .none {
            lineChartData.removeAll()
            self.isLoading = false
            tableView.reloadData()
            return
        }
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker, financial: criteria, frequency: .historic) { (results) in
            switch results {
            case .success(let downloadedData):
                self.lineChartData = downloadedData
                self.isLoading = false
            case .failure(let error):
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadChart() {
        fetchLineData(criteria: lineCriteria)
        fetchBarData(criteria: barCriteria)
    }
    
    private func configureLineData(chartView: CombinedLineChartView, criteria: SearchCriteria) {
        if lineChartData.isEmpty { return }
        chartView.generateLineData(dataPoints: lineChartData.map({ $0.date.formatDate()}),
                                   values: lineChartData.map({$0.value}),
                                   criteria: criteria)
    }
    
    private func configureBarData(chartView: CombinedLineChartView, criteria: SearchCriteria) {
        if barChartData.isEmpty { return }
        chartView.generateBarData(dataPoints: barChartData.map({ $0.date.formatDate()}),
                                  values: barChartData.map({$0.value}),
                                  criteria: criteria)
    }
    
    // MARK: - Scroll View Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let heightThreshold = stockHeaderView.frame.height - (delegate?.menuBarView.frame.height ?? 40) - 36
        if scrollView.contentOffset.y > heightThreshold {
            parent?.navigationItem.title = ticker
        }
        if scrollView.contentOffset.y < heightThreshold {
            parent?.navigationItem.title = ""
        }
    }
}

extension StockAnalysisViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return feedData.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return feedData[section].count }
        if section == 1 { return companyFilings.count }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath) as? AnalysisChartCell else { return UITableViewCell() }
                cell.chartView.delegate = self
                if !isLoading {
                    configureBarData(chartView: cell.chartView, criteria: barCriteria)
                    configureLineData(chartView: cell.chartView, criteria: lineCriteria)
                }
                
                return cell
            case 1,2:
                let cell = UITableViewCell(style: .default, reuseIdentifier: ReuseID.graphConfigurationCell)
                guard let criteria = feedData[indexPath.section][indexPath.row] as? SearchCriteria else { return cell }
                cell.textLabel?.font = UIFont.details1
                cell.backgroundColor = .clear
                cell.accessoryType = .disclosureIndicator
                if indexPath.row == 1 { cell.textLabel?.textColor = .appAccent }
                if indexPath.row == 2 { cell.textLabel?.textColor = .appAccent3 }
                cell.selectionStyle = .gray
                cell.textLabel?.text = "\(criteria.explicit)"
                return cell
            default: break
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.reportsCell, for: indexPath) as? NewsCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            let filingsData = feedData[indexPath.section] as? [Filings]
            cell.headerLabel.text = filingsData?[indexPath.row].reportType ?? ""
            cell.detailLabel.text = filingsData?[indexPath.row].periodEndDate ?? ""
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chartType: ChartType = .bar
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 || indexPath.row == 2 {
                if indexPath.row == 1 { chartType = .line }
                if indexPath.row == 2 { chartType = .bar }
                let criteriaVC = SearchSelectionViewController(
                    chartType: chartType)
                criteriaVC.delegate = self
                let navVC = UINavigationController(rootViewController: criteriaVC)
                self.parent?.present(navVC, animated: true, completion: nil)
            }
        case 1:
            let filing = feedData[indexPath.section][indexPath.row] as? Filings
            let filings = filing!.reportUrl!
            let webViewController = FilingsWebViewController(urlString: filings)
            navigationController?.pushViewController(webViewController, animated: true)
            
        default: break
        }
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = LargeSectionHeaderLabel(padding: 16)
        header.backgroundColor = .clear
        if !isLoading {
            let headerText = ["COMPARISON", "filings"]
            header.text = headerText[section].uppercased()
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return (UIScreen.main.bounds.height / 2) - 50
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 { return 40 }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == feedData.count - 1 {
            return 70
        } else {
            return 25
        }
    }
}

