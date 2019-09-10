//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

class StockDetailsViewController: UIViewController, ChartViewDelegate {

    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    let analyticsLogger: AnalyticsLogger
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
            if !isLoading {
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.detailsTableView.contentInset = UIEdgeInsets.zero
                }
            }
        }
    }
    
    private func observeStateChanges(_ state: Bool) {
        self.showActivitySpinner(state)
    }
    
    private var chartRevenueData: [CompanyHistoricalDatum] = []
    private var chartEarningsData: [CompanyHistoricalDatum] = []
    private var chartData: [[CompanyHistoricalDatum]] {
        return [chartRevenueData, chartEarningsData]
    }
    
    private var historicalAssetData: [CompanyHistoricalDatum] = []
    private var historicalLiabilitiesData: [CompanyHistoricalDatum] = []
    private var historicalEquityData: [CompanyHistoricalDatum] = []
    private var balanceSheetData: [[CompanyHistoricalDatum]] {
        return [historicalAssetData, historicalLiabilitiesData, historicalEquityData]
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return rc
    }()
    
    private lazy var detailsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(BarGraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tv.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tv.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.tableHeaderView = stockHeaderView
        if #available(iOS 10.0, *) { tv.refreshControl = refreshControl }
        else { tv.addSubview(refreshControl) }
        
        return tv
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
    
    init(ticker: String, companyName: String, networkingAPI: IntrinioAPI, analyticsLogger: AnalyticsLogger) {
        self.ticker = ticker
        self.companyName = companyName
        self.analyticsLogger = analyticsLogger
        self.intrinioApi = networkingAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
        setData()
        AppStoreReviewHelper.checkAndAskForReview(checkType: .importantAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    
    // MARK: - View Setup
    
    private func setupViews() {
        view.addSubview(detailsTableView)
        detailsTableView.fillSuperview()
    }
    
    @objc private func refreshData(_ sender: Any) {
        setData()
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
    
    private func getAssetData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .totalassets, frequency: .historic) { (results) in
            switch results {
            case .success(let downloadedData):
                self.historicalAssetData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getLiabilitiesData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .totalliabilities, frequency: .historic) { (results) in
            switch results {
            case .success(let downloadedData):
                self.historicalLiabilitiesData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getEquityData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .totalequity, frequency: .historic) { (results) in
            switch results {
            case .success(let downloadedData):
                self.historicalEquityData = downloadedData
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureChart(chartView: GenericBarChartView) {
        guard !chartRevenueData.isEmpty && !chartEarningsData.isEmpty else { return }
        chartView.setupChart(dataPoints: chartRevenueData.map({ $0.date.formatDate() }),
                             values: chartRevenueData.map({ $0.value }),
                             values1: chartEarningsData.map({ $0.value }))
    }
    
    private func configurePieChart(chartView: GenericPieChartView) {
        guard !historicalAssetData.isEmpty &&
            !historicalLiabilitiesData.isEmpty &&
            !historicalEquityData.isEmpty else { return }
        let index = historicalAssetData.count - 1
        
        chartView.setupPieChart(values: [
            historicalAssetData[index].value,
            historicalLiabilitiesData[index].value,
            historicalEquityData[index].value])
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
    
    private func setData() {
        isLoading = true
        getRevenueData()
        getEarningsData()
        configureNewsData()
        configureCalcData()
//        getAssetData()
//        getLiabilitiesData()
//        getEquityData()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "\(ticker)"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
    }

}

extension StockDetailsViewController {
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

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0) :
            return (UIScreen.main.bounds.height / 2) - 90
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderLabel(padding: 16)
        header.backgroundColor = .white
        if !isLoading {
            let headerText = ["FINANCIALS", "METRICS", "NEWS"]
            switch section {
            case 0: header.text = headerText[0]
            case 1: header.text = headerText[1]
            case 2: header.text = headerText[2]
            default: break
            }
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? NewsCell else { return }
        guard let newsArticleURL = URL(string: newsData[indexPath.item].url) else { return }

        if UIApplication.shared.canOpenURL(newsArticleURL) {
            analyticsLogger.reportEvents(event: .selectedNewsArticle)
            UIApplication.shared.open(newsArticleURL, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 35 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 70
        } else {
            return 25
        }
    }
}

