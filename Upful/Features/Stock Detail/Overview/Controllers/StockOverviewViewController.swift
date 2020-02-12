//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

final class StockOverviewViewController: UIViewController, ChartViewDelegate {
    
    // MARK: - MenuBarDisplayable Protocol Properties
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?

    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    let intrinioApi: IntrinioAPI
    private let stockNewsLoader = NewsLoader()

    private enum ReuseID {
        static let graphCell = "graphCell"
        static let calculationsCell = "calculationsCell"
        static let newsCell = "newsCell"
    }
    
    // MARK: - State

    fileprivate var isLoading: Bool = false {
        didSet {
            observeStateChanges(isLoading)
        }
    }
    
    fileprivate func observeStateChanges(_ isLoading: Bool) {
        if isLoading {
            LoadingViewPresenter.show(in: self)
        } else {
            LoadingViewPresenter.remove()
            tableView.reloadData()
            refreshingControl.endRefreshing()
        }
    }
    
    fileprivate var chartRevenueData: [CompanyHistoricalDatum] = []
    fileprivate var chartEarningsData: [CompanyHistoricalDatum] = []
    fileprivate var chartData: [[CompanyHistoricalDatum]] {
        return [chartRevenueData, chartEarningsData]
    }
    
    fileprivate var calcData: [StandardizedFinancial] = []
    private(set) var stockNews: [StockNewsViewModel] = []

    fileprivate var feedData: [[Any]] {
        return [chartData, calcData, stockNews]
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
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.setTableHeaderView(headerView: stockHeaderView)
        tv.refreshControl = refreshingControl
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private lazy var refreshingControl: UIRefreshControl = { [unowned self] in
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String, networkingAPI: IntrinioAPI = .init()) {
        self.ticker = ticker
        self.companyName = companyName
        self.intrinioApi = networkingAPI
        super.init(nibName: nil, bundle: nil)
        title = "Overview"
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
        loadOverviewData()
    }
    
    // MARK: - View Setup
    
    private func setUpPremiumButton() {
        if !PermissionManager.shared.isPremium {
            stockHeaderView.accessoryStackView.addArrangedSubview(get5YearDataButton)
            get5YearDataButton.addTarget(self, action: #selector(handle5YearDataInterest), for: .touchUpInside)
        }
    }
    
    private func setupViews() {
        tableView.register(BarGraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tableView.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    private func configureChart(chartView: GenericBarChartView) {
        guard !chartRevenueData.isEmpty && !chartEarningsData.isEmpty else { return }
        chartView.setupChart(
            dataPoints: chartRevenueData.map({ $0.date.formatDate() }),
            values: chartRevenueData.map({ $0.value }),
            values1: chartEarningsData.map({ $0.value }))
    }
    
    // MARK: - Actions
    
    @objc private func refreshData(_ sender: Any) {
        loadOverviewData()
    }
    
    @objc private func handle5YearDataInterest(_ sender: UIButton) {
        let presenter = SubscriptionPresenter(type: .fiveYearDataInterest)
        presenter.present(in: self)
    }
    
    // MARK: - Private Functions
    
    let chartDataGroup = DispatchGroup()
    
    fileprivate func getRevenueData() {
        chartDataGroup.enter()
        let isPremium = PermissionManager.shared.isPremium
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: .totalrevenue,
                                                frequency: .historic(isPremium: isPremium)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let downloadedData):
                self.chartRevenueData = downloadedData
            
            case .failure(let error):
                print(error.localizedDescription)
            }
                self.chartDataGroup.leave()
        }
    }
    
    fileprivate func getEarningsData() {
        chartDataGroup.enter()
        let isPremium = PermissionManager.shared.isPremium
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: .netincome,
                                                frequency: .historic(isPremium: isPremium)) { [weak self] (result) in
            guard let self = self else { return }
                                                    
            switch result {
            case .success(let downloadedData):
                self.chartEarningsData = downloadedData
            case .failure(let error):
                print(error.localizedDescription)
            }
                self.chartDataGroup.leave()
        }
    }

    let secondaryGroup = DispatchGroup()
    
    fileprivate func configureCalcData() {
        secondaryGroup.enter()
        intrinioApi.fetchStockBatchFinancials(ticker: ticker) { [weak self] (results) in
            guard let self = self else { return }
            
            switch results {
            case .success(let financialData):
                self.calcData = financialData

            case .failure(let error):
                print(error.localizedDescription)
            }
            self.secondaryGroup.leave()
        }
    }
    
    private var financialLookup: [SearchCriteria: Double] = [:]
    
    fileprivate func getAllCalculatedData() {
        [
            SearchCriteria.marketcap, .pricetoearnings,
             .pricetobook, .pricetorevenue,
             .dividendyield
        ].forEach { (criteria) in
            getFinancialData(financial: criteria)
        }
    }
    
    fileprivate func getFinancialData(financial: SearchCriteria) {
        secondaryGroup.enter()
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: financial,
                                                frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let downloadedData):
                guard !downloadedData.isEmpty else {
                    self.secondaryGroup.leave()
                    return
                }
                self.financialLookup[financial] = downloadedData.first?.value

            case .failure(let error):
                print(error.localizedDescription)
            }
            self.secondaryGroup.leave()
        })
    }
        
    func startNewsLoad() {
        secondaryGroup.enter()
        stockNewsLoader.get(router: .getTickerNews(tickers: self.ticker)) { (result) in
            switch result {
            case .success(let news):
                let mappedNews = news.map({ StockNewsViewModel(stockNews: $0 )})
                self.stockNews = mappedNews
            case .failure(let err):
                print(err.localizedDescription)
            }
            self.secondaryGroup.leave()
        }
    }
    
    fileprivate func handleDataFetchCompletion() {
        let secondaryWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
        }
        
        let primaryWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
        }
        chartDataGroup.notify(queue: .main, work: primaryWorkItem)
        secondaryGroup.notify(queue: .main, work: secondaryWorkItem)
    }
        
    fileprivate func loadOverviewData() {
        isLoading = true
        getRevenueData()
        getEarningsData()
        getAllCalculatedData()
        configureCalcData()
        startNewsLoad()
        handleDataFetchCompletion()
        if PermissionManager.shared.isPremium {
            get5YearDataButton.removeFromSuperview()
        }
    }
    
    // MARK: - Scroll View Delegate
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bufferHeight: CGFloat = 15
        let heightThreshold: CGFloat = stockHeaderView.intrinsicContentSize.height - bufferHeight
        let didReachThreshold = scrollView.contentOffset.y >= heightThreshold
        parent?.navigationItem.title = didReachThreshold ? ticker : ""
    }
}

extension StockOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            tableView.setEmptyView(state: .emptyState(title: "", message: ""))
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
            barGraphCell.backgroundColor = .clear
            barGraphCell.chartView.delegate = self
            configureChart(chartView: barGraphCell.chartView)
            return barGraphCell
            
        case 1:
            guard let calculationsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.calculationsCell, for: indexPath) as? DetailsCalculationCell else { return UITableViewCell() }
            calculationsCell.setupCell(with: calcData)
            calculationsCell.setupWithLookUp(lookUp: financialLookup)
            return calculationsCell
            
        case 2:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath) as? SmallNewsCell else { return UITableViewCell() }
            newsCell.stockNews = stockNews[indexPath.row]

            return newsCell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return (UIScreen.main.bounds.height / 2) - 50
        case 2:
            return 140
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = LargeSectionHeaderLabel(padding: 16)
        header.backgroundColor = VersionManager.collectionCellColor2()
        if !isLoading {
            let headerText = ["FINANCIALS", "METRICS", "NEWS"]
            header.text = headerText[section]
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? SmallNewsCell else { return }
        AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)

        let newsURLString = stockNews[indexPath.row].newsUrl
        let newsWebVC = WebViewViewController(urlString: newsURLString)
        let navVC = UINavigationController(rootViewController: newsWebVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == feedData.count - 1 {
            return 85
        } else {
            return 25
        }
    }
}

// MARK: - SubscriptionViewControllerDelegate Methods

extension StockOverviewViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        if PermissionManager.shared.isPremium {
            get5YearDataButton.removeFromSuperview()
            loadOverviewData()
        }
    }
}
