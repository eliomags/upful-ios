//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct StockDetailsModuleConstants {
    enum Section: Int, CaseIterable {
        case price
        case barGraph
        case calculations
        case news
        case description
    }
    
    enum ReuseID {
        static let graphCell = "graphCell"
        static let performanceCell = "performanceCellID"
        static let calculationsCell = "calculationsCell"
        static let newsCell = "newsCell"
        static let descriptionCellID = "descriptionCellID"
    }
}

final class StockOverviewViewController: UIViewController {

    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    
    let savedStockDataManager: LocalStockDataLoaderProtocol = LocalStockLoader()

    lazy var datasource: StockOverviewDatasource = {
        let stockPerformanceViewModel = StockPerformanceChartViewModel(ticker: ticker)
        let stockOverviewViewModel = StockOverviewViewModel(ticker: ticker, companyName: companyName)
        let ds = StockOverviewDatasource(stockOverviewViewModel: stockOverviewViewModel,
                                         stockPerformanceViewModel: stockPerformanceViewModel)
        ds.delegate = self
        return ds
    }()

    // MARK: - Views
    
    lazy var saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return button
    }()
    
    private let quoteView = StockQuoteView(priceLabelFontSize: 21, priceChangeLabelFontSize: 17, priceChangeLabelWidth: 70)
    private let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .light)
        return label
    }()
    
    lazy var stockHeaderView: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = ""
        v.headerLabel.text = ""
        v.accessoryStackView.addArrangedSubview(quoteView)
        return v
    }()

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.setTableHeaderView(headerView: stockHeaderView)
        tv.refreshControl = refreshingControl
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.dataSource = datasource
        tv.delegate = datasource
        return tv
    }()
    
    lazy var refreshingControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadOverviewData), for: .valueChanged)
        return rc
    }()
    
    let dragViewController = StockDetailDragViewController()
        
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupViews()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOverviewData()
        performSelector(inBackground: #selector(checkIfCurrentlySaved), with: nil)
        UserFeedbackPresenter.checkAndAskForReview(checkType: .importantAction, in: self)
    }
    
    // MARK: - Observe Updates
    
    fileprivate func successHandler() {
        datasource.viewModel.loadingCompletionHandler = { [weak self] in
            LoadingViewPresenter.remove()
            self?.refreshingControl.endRefreshing()
            self?.tableView.reloadData()
            self?.setupStockHeaderView()
            self?.checkAndSetChartEmptyState()
        }
    }
    
    fileprivate func errorHandler() {
        datasource.viewModel.errorHandler = { [weak self] in
            DispatchQueue.main.async {
                LoadingViewPresenter.remove()
                self?.refreshingControl.endRefreshing()
                self?.tableView.reloadData()
                self?.showErrorAlert()
            }
        }
    }
    
    fileprivate func priceLoadHandler() {
        datasource.stockPerformanceViewModel.loadCompletion = { [weak self] in
            self?.tableView.reloadSections([StockDetailsModuleConstants.Section.price.rawValue], with: .none)
        }
    }
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        let save = UIBarButtonItem(customView: saveButton)
        let cancel = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItems = [save]
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
    }
    
    private func setupViews() {
        view.backgroundColor = VersionManager.mainContainerBackground()

        tableView.register(BarGraphTableViewCell.self, forCellReuseIdentifier: StockDetailsModuleConstants.ReuseID.graphCell)
        tableView.register(PerformanceCell.self, forCellReuseIdentifier: StockDetailsModuleConstants.ReuseID.performanceCell)
        tableView.register(DetailsCalculationCell.self, forCellReuseIdentifier: StockDetailsModuleConstants.ReuseID.calculationsCell)
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: StockDetailsModuleConstants.ReuseID.newsCell)
        tableView.register(StockDescriptionCell.self, forCellReuseIdentifier: StockDetailsModuleConstants.ReuseID.descriptionCellID)
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        addChild(dragViewController)
        view.addSubview(dragViewController.dragView)
        dragViewController.dragView.translatesAutoresizingMaskIntoConstraints = false
        dragViewController.dragView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dragViewController.dragView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dragViewController.dragView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dragViewController.didMove(toParent: self)
    }
    
    private func setupStockHeaderView() {
        stockHeaderView.detailsLabel.text = datasource.viewModel.companyName
        stockHeaderView.headerLabel.text = datasource.viewModel.ticker
        let stockQuote = datasource.viewModel.stockQuote
        quoteView.priceLabel.text = "$\(stockQuote?.latestPrice.roundToTwoDecimal() ?? "-")"
        quoteView.percentChangeView.percentChangeLabel.text = "\(stockQuote?.changePercent.convertToPercent() ?? "-")%"
        
        if stockQuote?.changePercent ?? 0 > 0 {
            quoteView.setPositive()
        } else if stockQuote?.changePercent ?? 0 < 0 {
            quoteView.setNegative()
        }
        
        stockHeaderView.addSubview(lastUpdatedLabel)
        lastUpdatedLabel.topAnchor.constraint(equalTo: quoteView.bottomAnchor, constant: 8).isActive = true
        lastUpdatedLabel.leadingAnchor.constraint(equalTo: stockHeaderView.detailsLabel.leadingAnchor).isActive = true

        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        lastUpdatedLabel.text = "Last Updated, \(df.string(from: Date())) EST"
    }
    
    private func showErrorAlert() {
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
    
    private func checkAndSetChartEmptyState() {
        let noDataAvailable = datasource.viewModel.historicalEarnings.isEmpty &&
            datasource.viewModel.historicalRevenue.isEmpty
        if noDataAvailable {
            guard let chartCell = self.tableView.cellForRow(at: [0,0]) as? BarGraphTableViewCell else { return }
            chartCell.chartView.setNoDataText()
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleDismiss(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func loadOverviewData() {
        LoadingViewPresenter.show(in: self)
        datasource.loadData()
        priceLoadHandler()
        successHandler()
        errorHandler()
    }
    
    @objc private func checkIfCurrentlySaved() {
        savedStockDataManager.loadSavedStocks { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedStocks):
                let stockTickers = savedStocks.map({ $0.ticker })
                DispatchQueue.main.async {
                    self.saveButton.isSelected = stockTickers.contains(self.ticker)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func removeFavorite(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.removeFavoriteCompany(ticker, completion: nil)
    }
    
    private func saveCompany(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.saveCompany(ticker: ticker, companyName: companyName)
        
        if button.isSelected {
            Vibration.light.vibrate()
            AnalyticsLogger.instance.reportEvents(event: .savedTicker(ticker: ticker))
        }
    }
    
    @objc fileprivate func handleSaveTap(_ sender: UIButton) {
        if sender.isSelected {
            self.removeFavorite(button: sender)
            return
        }
        
        PermissionManager.shared.getSaveStockPermission { [weak self] (permissionGranted) in
            guard let self = self else { return }
            
            if !permissionGranted {
                let presenter = SubscriptionPresenter(type: .savedStockLimit)
                presenter.present(in: self)
            }
            if permissionGranted { self.saveCompany(button: sender) }
        }
    }
}

extension StockOverviewViewController: StockOverViewDataSourceDelegate {
    
    func didSelectNews(tableView: UITableView, urlString: String) {
        let safariPresenter = SafariPresenter(presenter: self, urlString: urlString)
        safariPresenter.start()
    }
    
    func didScroll(scrollView: UIScrollView) {
        let bufferHeight: CGFloat = 12
        let heightThreshold: CGFloat = stockHeaderView.intrinsicContentSize.height - bufferHeight
        let didReachThreshold = scrollView.contentOffset.y >= heightThreshold
        navigationItem.title = didReachThreshold ? datasource.viewModel.ticker : ""
    }
}
extension StockOverviewViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        loadOverviewData()
    }
}
