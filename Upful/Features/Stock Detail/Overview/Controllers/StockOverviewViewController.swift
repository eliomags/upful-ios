//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

final class StockOverviewViewController: UIViewController, ChartViewDelegate, MenuBarDisplayable {
    
    // MARK: - MenuBarDisplayable Protocol Properties
    
    weak var delegate: MenuViewItemDelegate?
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

    fileprivate var isLoading: Bool = false {
        didSet {
            observeStateChanges(isLoading)
        }
    }
    
    fileprivate func observeStateChanges(_ state: Bool) {
        showActivitySpinner(state)
        tableView.reloadData()
        refreshingControl.endRefreshing()
        tableView.isScrollEnabled = !state
    }
    
    fileprivate var chartRevenueData: [CompanyHistoricalDatum] = []
    fileprivate var chartEarningsData: [CompanyHistoricalDatum] = []
    fileprivate var chartData: [[CompanyHistoricalDatum]] {
        return [chartRevenueData, chartEarningsData]
    }
    
    fileprivate var calcData: [StandardizedFinancial] = []
    fileprivate var newsData: [CompanyNewsModel] = []
    fileprivate var feedData: [[Any]] {
        return [chartData, calcData, newsData]
    }
    
    // MARK: - Views
    
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
    
    private lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = companyName
        v.headerLabel.text = ticker
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return v
    }()
    
    private lazy var refreshingControl: UIRefreshControl = { [unowned self] in
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    private var loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .medium)
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground()
        setupViews()
        loadOverviewData()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        tableView.register(BarGraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tableView.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tableView.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tableView.contentInset = UIEdgeInsets(top: stockHeaderView.intrinsicContentSize.height + 8, left: 0, bottom: 0, right: 0)
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
    
    @objc private func refreshData(_ sender: Any) {
        loadOverviewData()
    }
    
    // MARK: - Private Functions
    
    let chartDataGroup = DispatchGroup()
    
    fileprivate func getRevenueData() {
        chartDataGroup.enter()
        
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: .totalrevenue,
                                                frequency: .historic) { [weak self] (result) in
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
        
        intrinioApi.fetchStockSpecificFinancial(ticker: ticker,
                                                financial: .netincome,
                                                frequency: .historic) { [weak self] (result) in
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
            self.getFinancialData(financial: criteria)
        }
    }
    
    fileprivate func getFinancialData(financial: SearchCriteria) {
        secondaryGroup.enter()

        intrinioApi.fetchStockSpecificFinancial(ticker: ticker, financial: financial, frequency: .recent, completion: { [weak self] (result) in
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
    
    fileprivate func configureNewsData() {
        secondaryGroup.enter()
        
        intrinioApi.getCompanyNewsData(ticker: ticker) { [weak self] (results) in
            guard let self = self else { return }
            
            switch results {
            case .success(let downloadedNewsData):
                self.newsData = downloadedNewsData.news ?? []

            case .failure(let error):
                print(error)
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
        configureNewsData()
        handleDataFetchCompletion()
    }
    
    // MARK: - Scroll View Delegate
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bufferHeight: CGFloat = 15
        let heightThreshold: CGFloat = (delegate?.menuBarView.frame.height ?? 55) - stockHeaderView.intrinsicContentSize.height + bufferHeight
        let didReachThreshold = scrollView.contentOffset.y >= heightThreshold
        parent?.navigationItem.title = didReachThreshold ? ticker : ""
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

extension StockOverviewViewController: UITableViewDataSource, UITableViewDelegate {
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
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath) as? NewsCell else { return UITableViewCell() }
            let news = feedData[indexPath.section] as? [CompanyNewsModel]
            newsCell.headerLabel.text = news?[indexPath.item].title
            newsCell.detailLabel.text = news?[indexPath.item].summary
            
            return newsCell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0) :
            return (UIScreen.main.bounds.height / 2) - 50
        default: return UITableView.automaticDimension
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
        guard let _ = tableView.cellForRow(at: indexPath) as? NewsCell else { return }
        let newsArticleURL = newsData[indexPath.item].url

        let webViewController = WebViewViewController(urlString: newsArticleURL)
        self.navigationController?.pushViewController(webViewController, animated: true)
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

