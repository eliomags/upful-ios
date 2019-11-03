//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

final class StockOverviewViewController: UITableViewController, ChartViewDelegate, MenuBarDisplayable {
    
    // MARK: - MenuBarDisplayable Protocol Properties
    
    var delegate: MenuViewItemDelegate?
    var menubarTitle: String = "Overview"
    

    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    let intrinioApi: IntrinioAPI
    
    private enum ReuseID {
        static let graphCell = "graphCell"
        static let calculationsCell = "calculationsCell"
        static let newsCell = "newsCell"
    }
    
    // MARK: - State
    // TODO: - Better implementation of state
    private enum State {
        case Pending
        case Loading
        case Loaded(data: [[Any]])
        case Error
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
    
    private var chartRevenueData: [CompanyHistoricalDatum] = []
    private var chartEarningsData: [CompanyHistoricalDatum] = []
    private var chartData: [[CompanyHistoricalDatum]] {
        return [chartRevenueData, chartEarningsData]
    }
    
    private var calcData: [StandardizedFinancial] = []
    private var newsData: [CompanyNewsModel] = []
    private var feedData: [[Any]] {
        return [chartData, calcData, newsData]
    }
    
    // MARK: - Views
    
    private lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = companyName
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return v
    }()
    
    private lazy var refreshingControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
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
        loadChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VersionManager.setNavigationBar(in: navigationController)
        VersionManager.navigationBarColor(in: navigationController)
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        tableView.register(BarGraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tableView.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tableView.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = stockHeaderView
        tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        if #available(iOS 10.0, *) { tableView.refreshControl = refreshingControl }
    }
    
    @objc private func refreshData(_ sender: Any) {
        loadChartData()
    }
    
    // MARK: - Private Functions
    
    private func getRevenueData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .totalrevenue, frequency: .historic) { (result) in
            switch result {
            case .success(let downloadedData):
                self.chartRevenueData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getEarningsData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .netincome, frequency: .historic) { (result) in
            switch result {
            case .success(let downloadedData):
                self.chartEarningsData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureChart(chartView: GenericBarChartView) {
        guard !chartRevenueData.isEmpty && !chartEarningsData.isEmpty else { return }
        chartView.setupChart(
            dataPoints: chartRevenueData.map({ $0.date.formatDate() }),
            values: chartRevenueData.map({ $0.value }),
            values1: chartEarningsData.map({ $0.value }))
    }   
    
    private func configureNewsData() {
        self.intrinioApi.getCompanyNewsData(ticker: self.ticker) { (results) in
            switch results {
            case .success(let downloadedNewsData):
                self.newsData = downloadedNewsData.news ?? []
                self.isLoading = false

            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCalcData() {
        self.intrinioApi.fetchStockBatchFinancials(ticker: self.ticker) { (results) in
            switch results {
            case .success(let financialData):
                self.calcData = financialData
                self.isLoading = false

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadChartData() {
        isLoading = true
        getRevenueData()
        getEarningsData()
        configureNewsData()
        configureCalcData()
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
        if translation > 0 { delegate?.presentMenuBar() }
        if translation < 0 { delegate?.hideMenuBar() }
    }

}

extension StockOverviewViewController {
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
}

extension StockOverviewViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == true {
            tableView.setEmptyView(state: .emptyState(title: "", message: "Loading..."))
            return 0
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
            if section == 2 { return feedData[section].count }
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let barGraphCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath) as? BarGraphTableViewCell else { return UITableViewCell() }
            barGraphCell.chartView.delegate = self
            configureChart(chartView: barGraphCell.chartView)
            
            return barGraphCell
        case 1:
            guard let calculationsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.calculationsCell, for: indexPath) as? DetailsCalculationCell else { return UITableViewCell() }
            calculationsCell.setupCell(with: calcData)
            
            return calculationsCell
        case 2:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath) as? NewsCell else { return UITableViewCell() }
            let news = feedData[indexPath.section] as? [CompanyNewsModel]
            newsCell.headerLabel.text = news?[indexPath.item].title
            newsCell.detailLabel.text = news?[indexPath.item].summary
            
            return newsCell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0) :
            return (UIScreen.main.bounds.height / 2) - 50
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = LargeSectionHeaderLabel(padding: 16)
        header.backgroundColor = .white
        if !isLoading {
            let headerText = ["FINANCIALS", "METRICS", "NEWS"]
            header.text = headerText[section]
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? NewsCell else { return }
        let newsArticleURL = newsData[indexPath.item].url

        let webViewController = WebViewViewController(urlString: newsArticleURL)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == feedData.count - 1 {
            return 85
        } else {
            return 25
        }
    }
}

