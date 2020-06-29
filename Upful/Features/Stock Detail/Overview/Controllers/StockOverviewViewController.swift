//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

final class StockOverviewViewController: UIViewController {
    
    // MARK: - MenuBarDisplayable Protocol Properties
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?

    // MARK: - Dependencies
    
    private let viewModel: StockOverviewViewModel
    private lazy var stockPerformanceViewModel: StockPerformanceChartViewModel = {
        let vm = StockPerformanceChartViewModel(ticker: self.viewModel.ticker)
        return vm
    }()

    private enum ReuseID {
        static let graphCell = "graphCell"
        static let performanceCell = "performanceCellID"
        static let calculationsCell = "calculationsCell"
        static let newsCell = "newsCell"
        static let descriptionCellID = "descriptionCellID"
    }
    
    // MARK: - Views
    
    private let quoteView = StockQuoteView(priceLabelFontSize: 21, priceChangeLabelFontSize: 17, priceChangeLabelWidth: 70)
    private let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .light)
        return label
    }()
    
    lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = ""
        v.headerLabel.text = ""
        v.accessoryStackView.addArrangedSubview(quoteView)
        v.accessoryStackView.addArrangedSubview(lastUpdatedLabel)
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
    
    lazy var refreshingControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadOverviewData), for: .valueChanged)
        return rc
    }()
        
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String) {
        self.viewModel = StockOverviewViewModel(ticker: ticker, companyName: companyName)
        super.init(nibName: nil, bundle: nil)
        title = "Overview"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOverviewData()
    }
    
    // MARK: - Observe Updates
    
    fileprivate func successHandler() {
        viewModel.loadingCompletionHandler = { [weak self] in
            LoadingViewPresenter.remove()
            self?.refreshingControl.endRefreshing()
            self?.tableView.reloadData()
            self?.setupStockHeaderView()
            self?.checkAndSetChartEmptyState()
        }
    }
    
    fileprivate func errorHandler() {
        viewModel.errorHandler = { [weak self] in
            DispatchQueue.main.async {
                LoadingViewPresenter.remove()
                self?.refreshingControl.endRefreshing()
                self?.tableView.reloadData()
                self?.showErrorAlert()
            }
        }
    }
    
    fileprivate func priceLoadHandler() {
        stockPerformanceViewModel.loadCompletion = { [weak self] in
            self?.tableView.reloadSections([Section.price.rawValue], with: .none)
        }
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        view.backgroundColor = VersionManager.mainContainerBackground()

        tableView.register(BarGraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tableView.register(PerformanceCell.self, forCellReuseIdentifier: ReuseID.performanceCell)
        tableView.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tableView.register(StockDescriptionCell.self, forCellReuseIdentifier: ReuseID.descriptionCellID)
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func setupStockHeaderView() {
        stockHeaderView.detailsLabel.text = viewModel.companyName
        stockHeaderView.headerLabel.text = viewModel.ticker
        let stockQuote = viewModel.stockQuote
        quoteView.priceLabel.text = "$\(stockQuote?.latestPrice.roundToTwoDecimal() ?? "-")"
        quoteView.percentChangeView.percentChangeLabel.text = "\(stockQuote?.changePercent.convertToPercent() ?? "-")%"
        
        if stockQuote?.changePercent ?? 0 > 0 {
            quoteView.setPositive()
        } else if stockQuote?.changePercent ?? 0 < 0 {
            quoteView.setNegative()
        }
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        lastUpdatedLabel.text = "Last Updated, \(df.string(from: Date())) EST"
    }
    
    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Network Error",
                                           message: "Experienced an error connecting to the network.",
                                           preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        errorAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
            self.loadOverviewData()
        }))
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func configureChart(chartView: GenericBarChartView) {
        guard !viewModel.historicalRevenue.isEmpty && !viewModel.historicalEarnings.isEmpty else { return }
        chartView.setupChart(
            dataPoints: viewModel.historicalRevenue.map { $0.date.formatDate() },
            values: viewModel.historicalRevenue.map { $0.value },
            values1: viewModel.historicalEarnings.map { $0.value })
    }
    
    private func checkAndSetChartEmptyState() {
        let noDataAvailable = viewModel.historicalEarnings.isEmpty &&
            viewModel.historicalRevenue.isEmpty
        if noDataAvailable {
            guard let chartCell = self.tableView.cellForRow(at: [0,0]) as? BarGraphTableViewCell else { return }
            chartCell.chartView.setNoDataText()
        }
    }
    
    // MARK: - Private Functions
    
    @objc fileprivate func loadOverviewData() {
        LoadingViewPresenter.show(in: self.parent ?? self)
        
        viewModel.loadData()
        stockPerformanceViewModel.loadInitialDataPoints(dispatchGroup: viewModel.loadingOperations)
        viewModel.listenForUpdates()
        
        priceLoadHandler()
        successHandler()
        errorHandler()
    }
    
    // MARK: - Scroll View Delegate
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bufferHeight: CGFloat = 15
        let heightThreshold: CGFloat = stockHeaderView.intrinsicContentSize.height - bufferHeight
        let didReachThreshold = scrollView.contentOffset.y >= heightThreshold
        parent?.navigationItem.title = didReachThreshold ? viewModel.ticker : ""
    }
}

extension StockOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum Section: Int, CaseIterable {
        case price
        case barGraph
        case calculations
        case news
        case description
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == Section.news.rawValue {
            return viewModel.stockNews.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.price.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.performanceCell, for: indexPath)
                as? PerformanceCell else { return UITableViewCell() }
            stockPerformanceViewModel.configure(cell)
            return cell
            
        case Section.barGraph.rawValue:
            guard let barGraphCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath)
                as? BarGraphTableViewCell else { return UITableViewCell() }
            barGraphCell.backgroundColor = .clear
            barGraphCell.chartView.delegate = self
            configureChart(chartView: barGraphCell.chartView)
            return barGraphCell
            
        case Section.calculations.rawValue:
            guard let calculationsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.calculationsCell, for: indexPath)
                as? DetailsCalculationCell else { return UITableViewCell() }
            calculationsCell.setupCell(with: viewModel.calcData)
            calculationsCell.setupWithLookUp(lookUp: viewModel.financialLookup)
            return calculationsCell
            
        case Section.news.rawValue:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath)
                as? SmallNewsCell else { return UITableViewCell() }
            newsCell.stockNews = viewModel.stockNews[indexPath.row]
            return newsCell

        case Section.description.rawValue:
            guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.descriptionCellID, for: indexPath)
                as? StockDescriptionCell else { return UITableViewCell() }
            descriptionCell.descriptionLabel.text = viewModel.stockDetail?.description ?? ""
            descriptionCell.employeeStackView.valueLabel.text = String(viewModel.stockDetail?.employees ?? 0)
            descriptionCell.locationStackView.valueLabel.text = "\(viewModel.stockDetail?.city ?? ""),\(viewModel.stockDetail?.state ?? "")"
            return descriptionCell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case Section.price.rawValue:
            return 200
        case Section.barGraph.rawValue:
            return (UIScreen.main.bounds.height / 2) - 50
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableSectionHeaderView()
        let headerText = ["", "Financials", "Metrics", "News", "About"]
        header.headerTextLabel.text = headerText[section]
        header.addButton.setTitle("", for: .normal)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.price.rawValue { return 0 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? SmallNewsCell else { return }
        AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)

        let newsURLString = viewModel.stockNews[indexPath.row].newsUrl
        let safariPresenter = SafariPresenter(presenter: self, urlString: newsURLString)
        safariPresenter.start()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == Section.allCases.count {
            return 85
        } else {
            return 25
        }
    }
}

extension StockOverviewViewController: ChartViewDelegate {}
