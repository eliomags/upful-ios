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
    
    
    // MARK: - Data
    
    private var chartRevenueData: [CompanyHistoricalDatum] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    private var chartEarningsData: [CompanyHistoricalDatum] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    private var chartData: [[CompanyHistoricalDatum]] {
        return [chartRevenueData, chartEarningsData]
    }
    
    private var calcData: [StandardizedFinancial] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    private var newsData: [CompanyNewsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    private var feedData: [[Any]] {
        return [chartData, calcData, newsData]
    }
    
    
    // MARK: - Views
    
    lazy var detailsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(GraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tv.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tv.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.tableHeaderView = UIView()
        return tv
    }()
    
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String, intrinioApi: IntrinioAPI, analyticsLogger: AnalyticsLogger) {
        self.ticker = ticker
        self.companyName = companyName
        self.analyticsLogger = analyticsLogger
        self.intrinioApi = intrinioApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
        getRevenueData()
        getEarningsData()
        configureNewsData()
        configureCalcData()
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
    
    
    // MARK: - Private Functions
    
    private func getRevenueData() {
        self.intrinioApi.fetchStockSpecificFinancial(ticker: self.ticker, financial: .totalrevenue, frequency: .historic) { (result) in
            switch result {
            case .success(let downloadedData):
                self.chartRevenueData = downloadedData
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureChart(chartView: ChartView) {
        guard !chartRevenueData.isEmpty && !chartEarningsData.isEmpty else { return }
        chartView.setupChart(dataPoints: chartRevenueData.map({ $0.date.formatDate() }),
                             values: chartRevenueData.map({ $0.value }),
                             values1: chartEarningsData.map({ $0.value }))
    }
    
    private func configureNewsData() {
        self.intrinioApi.getCompanyNewsData(ticker: self.ticker) { (results) in
            switch results {
            case .success(let downloadedNewsData):
                self.newsData.append(contentsOf: downloadedNewsData.news ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCalcData() {
        self.intrinioApi.fetchStockBatchFinancials(ticker: self.ticker) { (results) in
            switch results {
            case .success(let financialData):
                self.calcData.append(contentsOf: financialData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "\(ticker)"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return feedData[section].count }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let graphCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath) as? GraphTableViewCell else { return UITableViewCell() }
            graphCell.chartView.delegate = self
            configureChart(chartView: graphCell.chartView)
            
            return graphCell
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
        case IndexPath(row: 0, section: 0) :
            return (UIScreen.main.bounds.height / 2) - 90
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderLabel(padding: 16)
        header.backgroundColor = .white
        let headerText = ["FINANCIALS", "METRICS", "NEWS"]
        switch section {
        case 0: header.text = headerText[0]
        case 1: header.text = headerText[1]
        case 2: header.text = headerText[2]
        default: break
        }
        return header
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

