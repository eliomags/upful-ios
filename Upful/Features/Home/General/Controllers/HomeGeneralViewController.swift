//
//  HomeGeneralViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class HomeGeneralViewController: UIViewController, PreferenceDelegate {
            
    private enum Section: Int, CaseIterable {
        case breakdown = 0
        case holdings = 1
        case news = 2
        case preference = 3
    }
    
    private enum Constants {
        static let newsCellID = "newsCellID"
        static let resultsCellID = "resultsCellID"
        static let loadingCellID = "loadingCellID"
        static let breakdownCellID = "breakdownCellID"
        static let breakdownHeaderID = "breakdownHeaderID"
        static let noPreferenceCellID = "noPreferenceCellID"
        static let stockHoldingCellID = "stockHoldingCellID"
    }
    
    lazy var logicController: HomeGeneralLogicController = {
        let vm = HomeGeneralLogicController()
        return vm
    }()
    
    var coordinator: Coordinator?

    // MARK: - Views
    
    private lazy var screenerSelectionButton: CustomRoundButton = {
        let b = CustomRoundButton(imageName: "plus")
        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenerSelectionTap)))
        return b
    }()
    private let tradingBalanceView = TradingBalanceView()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleResfreshing), for: .valueChanged)
        return control
    }()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.refreshControl = refreshControl
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    // MARK: - Properties
    
    fileprivate var shouldDisplayBreakDownCell = true {
        didSet {
            reloadBreakdownSectionHeader()
        }
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        
        setupNavBar()
        setupTableView()
        setupTableViewCells()
        addScreenerNavButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeViewModelNewsUpdates()
        observeViewModelHoldingsUpdates()
        observeViewModelPreferenceUpdates()
        logicController.fetchTableData()
        
        UserFeedbackPresenter.checkAndAskForReview(checkType: .newSession, in: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logicController.loadHoldings()
        configureTransactionHeaderSuccess()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if tableView.shouldUpdateHeaderViewFrame() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logicController.cancelHoldingsLoad()
    }
    
    // MARK: - View Model Binding

    fileprivate func observeViewModelHoldingsUpdates() {
        logicController.holdingsLoadCompletion = { [weak self] error in
            guard let self = self else { return }
            if let _ = error {
                self.configureTransactionHeaderError()
                self.tableView.reloadSections([Section.holdings.rawValue], with: .fade)
                self.tableView.reloadSections([Section.breakdown.rawValue], with: .none)
                self.refreshControl.endRefreshing()
                return
            }
            self.loadPieChartViewModels()
            self.configureTransactionHeaderSuccess()
            
            self.tableView.reloadSections([Section.holdings.rawValue, Section.breakdown.rawValue], with: .fade)
            self.refreshControl.endRefreshing()
        }
    }
    
    fileprivate func observeViewModelPreferenceUpdates() {
        logicController.sendPreferenceStateUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loaded, .new:
                self.tableView.reloadSections([Section.preference.rawValue], with: .automatic)
                self.refreshControl.endRefreshing()
                
            case .loading:
                self.tableView.reloadSections([Section.preference.rawValue], with: .automatic)
            default:
                break
            }
        }
    }
    
    fileprivate func observeViewModelNewsUpdates() {
        logicController.newsLoadCompletion = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections([Section.news.rawValue], with: .automatic)
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func addScreenerNavButton() {
        view.addSubview(screenerSelectionButton)
        screenerSelectionButton.anchor(top: nil, leading: nil,
                                       bottom: view.layoutMarginsGuide.bottomAnchor,
                                       trailing: view.layoutMarginsGuide.trailingAnchor,
                                       padding: .init(top: 0, left: 0, bottom: 16, right: 4))
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.separatorStyle = .none
        tableView.setTableHeaderView(headerView: tradingBalanceView)

        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(HoldingsBreakdownTableViewCell.self,
                           forCellReuseIdentifier: Constants.breakdownCellID)
        tableView.register(SmallNewsCell.self,
                           forCellReuseIdentifier: Constants.newsCellID)
        tableView.register(CompanyPreviewTableViewCell.self,
                           forCellReuseIdentifier: Constants.resultsCellID)
        tableView.register(NoPreferenceTableViewCell.self,
                           forCellReuseIdentifier: Constants.noPreferenceCellID)
        tableView.register(StockHoldingTableViewCell.self,
                           forCellReuseIdentifier: Constants.stockHoldingCellID)
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.loadingCellID)
        tableView.register(HoldingBreakdownHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: Constants.breakdownHeaderID)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing(_ sender: Any) {
        refreshControl.endRefreshing()
        logicController.fetchTableData()
        logicController.loadHoldings()
    }
    
    fileprivate func handleStockSuggestionCellSelection(for indexPath: IndexPath) {
        switch logicController.preferenceState {
        case .new:
            let preferencePresenter = PreferencePresenter(presentingViewController: self)
            preferencePresenter.present()
            
        case .loaded:
            coordinator = StockDetailsCoordinator(presenter: self, stockViewModel: logicController.stocksYouMayLike[indexPath.row])
            coordinator?.start()
            
        default:
            break
        }
    }
    
    @objc fileprivate func handleScreenerSelectionTap() {
        let screenerSelectionVC = ScreenerSelectionContainerView(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(screenerSelectionVC, animated: true)
    }

    // MARK: - Preference Delegate Methods
        
    func didCompleteSaving() {
        logicController.startPreferenceLoad()
    }
    
    // MARK: - ScrollView Delegate Methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height: CGFloat = tradingBalanceView.frame.height -
            tradingBalanceView.cashBalanceView.frame.height -
            tradingBalanceView.lastUpdatedLabel.frame.height -
            70
        
        if scrollView.contentOffset.y >= height {
            navigationItem.title = "$\(logicController.totalEquity?.withCommas() ?? " -")"
        } else {
            navigationItem.title = ""
        }
    }
    
    // MARK: - View Configuration
    
    fileprivate func configureTransactionHeaderSuccess() {
        tradingBalanceView.cashBalanceView.cashValueLabel.text =
            "$\(logicController.tradingEngine.balanceManager.currentCashBalance.withCommas())"
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        tradingBalanceView.lastUpdatedLabel.text = "Last Updated, \(df.string(from: Date())) EST"
        
        let equity = logicController.totalEquity ?? 0
        if equity-25000 > 0 {
            tradingBalanceView.setPositive()
        } else if equity-25000 < 0 {
            tradingBalanceView.setNegative()
        } else {
            tradingBalanceView.setNeutral()
        }
        
        let dollarDiff = (equity - 25_000).withCommas()
        let percentDiff = (((equity / 25_000) - 1) * 100).withCommas()
        
        UIView.transition(with: tradingBalanceView.totalEquityView, duration: 0.5,
                          options: .transitionCrossDissolve, animations: {
            self.tradingBalanceView.totalEquityView.equityValueLabel.text =
            "$\(self.logicController.totalEquity?.withCommas() ?? " -")"
            self.tradingBalanceView.totalEquityView.totalReturnLabel.text = "$\(dollarDiff)  •  \(percentDiff)%"
        }, completion: nil)
    }
    
    fileprivate func configureTransactionHeaderError() {
        tradingBalanceView.cashBalanceView.cashValueLabel.text =
            "$\(logicController.tradingEngine.balanceManager.currentCashBalance.withCommas())"
        tradingBalanceView.totalEquityView.equityValueLabel.text = "Error"
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        tradingBalanceView.lastUpdatedLabel.text = "Last Updated, \(df.string(from: Date())) EST"
        tradingBalanceView.setNegative()
        
        tradingBalanceView.totalEquityView.totalReturnLabel.text = "Error"
    }
    
    // MARK: Breakdown Section
    
    fileprivate func reloadBreakdownSectionHeader() {
        if !shouldDisplayBreakDownCell {
            tableView.deleteRows(at: [[0,0]], with: .fade)
        }
        let breakdownSection = Section.breakdown.rawValue
        tableView.reloadSections([breakdownSection], with: .automatic)
        
        if shouldDisplayBreakDownCell {
            tableView.scrollToRow(at: [0,0], at: .bottom, animated: true)
        }
        
        let headerView = tableView.headerView(forSection: breakdownSection) as? HoldingBreakdownHeaderView
        headerView?.toggleButtonState()
    }
    
    // TODO: - Move to LogicController
    var pieChartViewModels: [PieChartConfigurable] = []
    
    fileprivate func loadPieChartViewModels() {
        let vmLoader = PieChartViewModelLoader()
        let holdings = logicController.holdings
        let cash = logicController.tradingEngine.balanceManager.currentCashBalance
        
        pieChartViewModels = vmLoader.makeViewModels(from: holdings, cash: cash)
    }
    
    // MARK: - TableViewCell Configuration
    
    fileprivate func makeBreakdownCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.breakdownCellID,
                                                 for: indexPath) as? HoldingsBreakdownTableViewCell
        cell?.chartView.setupPieChart(chartConfigurables: pieChartViewModels)
        
        return cell ?? UITableViewCell()
    }
    
    fileprivate func makeHoldingsCell(at indexPath: IndexPath) -> UITableViewCell {
        if logicController.holdings.isEmpty {
            return EmptyStockHoldingCell()
        } else {
            let stockHoldingsCell = tableView.dequeueReusableCell(withIdentifier: Constants.stockHoldingCellID,
                                                                  for: indexPath) as? StockHoldingTableViewCell
            let holding = logicController.holdings[indexPath.row]
            stockHoldingsCell?.tickerLabel.text = holding.ticker
            stockHoldingsCell?.numberOfSharesLabel.text = "\(holding.totalShareCount) shares"
            stockHoldingsCell?.currentPriceLabel.text = "$\(holding.currentPrice?.roundToTwoDecimal() ?? " -")"
            stockHoldingsCell?.averagePriceLabel.text = "$\(holding.averagePrice.roundToTwoDecimal())"
            stockHoldingsCell?.dollarChangeLabel.text = "$" + holding.totalPriceMovementDollar.roundToTwoDecimal()
            stockHoldingsCell?.percentChangeView.percentChangeLabel.text = holding.totalPriceMovementPercent
            
            if holding.totalPriceMovementDollar > 0 {
                stockHoldingsCell?.percentChangeView.showPositive()
            } else if holding.totalPriceMovementDollar < 0 {
                stockHoldingsCell?.percentChangeView.showNegative()
            } else {
                stockHoldingsCell?.percentChangeView.showNeutral()
            }
            
            return stockHoldingsCell ?? UITableViewCell()
        }
    }
    
    fileprivate func makeNoPreferenceSetCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let noPreferenceSetCell = tableView.dequeueReusableCell(withIdentifier: Constants.noPreferenceCellID)
            as? NoPreferenceTableViewCell else { return UITableViewCell() }
        noPreferenceSetCell.selectionStyle = .none
        noPreferenceSetCell.backgroundColor = .clear
        return noPreferenceSetCell
    }
    
    fileprivate func makeStockCells(_ indexPath: IndexPath) -> UITableViewCell {
        guard let loadedCell = tableView.dequeueReusableCell(withIdentifier: Constants.resultsCellID)
            as? CompanyPreviewTableViewCell else { return UITableViewCell() }
        loadedCell.accessoryType = .disclosureIndicator
        loadedCell.backgroundColor = VersionManager.mainContainerBackground()

        if logicController.preferenceState == .loaded  && !logicController.stocksYouMayLike.isEmpty {
            let stockViewModel = logicController.stocksYouMayLike[indexPath.row]
            loadedCell.companyTickerLabel.text = stockViewModel.stock.ticker
            loadedCell.marketcapStackView.valueLabel.text = "$\(stockViewModel.stock.marketcap?.formatUsingAbbreviation() ?? " -")"
            loadedCell.pricetoearningsStackView.valueLabel.text = "\(stockViewModel.stock.pricetoearnings?.twoDecimal() ?? "-")"
            loadedCell.quoteView.priceLabel.text = "$\(stockViewModel.stock.stockQuote?.latestPrice.roundToTwoDecimal() ?? "-")"
            loadedCell.quoteView.percentChangeView.percentChangeLabel.text =
                "\(stockViewModel.stock.stockQuote?.changePercent.convertToPercent() ?? "-")%"
            
            if stockViewModel.stock.stockQuote?.changePercent ?? 0 > 0 {
                loadedCell.quoteView.setPositive()
            } else if stockViewModel.stock.stockQuote?.changePercent ?? 0 < 0 {
                loadedCell.quoteView.setNegative()
            }
        }
        
        return loadedCell
    }
    
    fileprivate func makeNewsCells(at indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0,1,2:
            let newsCell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellID, for: indexPath) as! SmallNewsCell
            if !logicController.stockNews.isEmpty {
                newsCell.stockNews = logicController.stockNews[indexPath.row]
            }
            return newsCell
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func makeLoadingCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCellID, for: indexPath)
        let activityView = UIActivityIndicatorView(style: .medium)
        
        cell.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        
        activityView.startAnimating()
        
        return cell
    }
}

// MARK: - TableView Delegate/Datasource Methods

extension HomeGeneralViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.breakdown.rawValue:
            return shouldDisplayBreakDownCell ? 1 : 0
            
        case Section.holdings.rawValue:
            return logicController.holdings.isEmpty ? 1 : logicController.holdings.count
            
        case Section.news.rawValue:
            return 3
            
        case Section.preference.rawValue:
            let isLoadedState = logicController.preferenceState == .loaded
            let isNew = logicController.preferenceState == .new
            if isNew { return 1 }
            if isLoadedState {
                return logicController.stocksYouMayLike.count
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case Section.breakdown.rawValue:
            return (logicController.holdingsState == .loading) ?
                makeLoadingCell(at: indexPath) : makeBreakdownCell(at: indexPath)
            
        case Section.holdings.rawValue:
            return (logicController.holdingsState == .loading) ?
                makeLoadingCell(at: indexPath) : makeHoldingsCell(at: indexPath)

        case Section.news.rawValue:
            return makeNewsCells(at: indexPath)
            
        case Section.preference.rawValue:
            if logicController.preferenceState == .loaded { return makeStockCells(indexPath) }
            if logicController.preferenceState == .new { return makeNoPreferenceSetCell(indexPath) }
            
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.breakdown.rawValue:
            return (logicController.holdingsState == .loading) ?
                UITableView.automaticDimension : (UIScreen.main.bounds.height / 2) - 130
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.breakdown.rawValue:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.breakdownHeaderID) as? HoldingBreakdownHeaderView
            header?.addButton.isSelected = !shouldDisplayBreakDownCell
            
            header?.buttonAction = { [weak self] in
                guard let self = self else { return }
                Vibration.light.vibrate()
                
                self.shouldDisplayBreakDownCell = !self.shouldDisplayBreakDownCell
            }
            return header
            
        case Section.holdings.rawValue:
            let holdingsHeader = TableSectionHeaderView()
            holdingsHeader.headerTextLabel.text = "My Holdings"
            holdingsHeader.addButton.setTitle("", for: .normal)
            return holdingsHeader
            
        case Section.preference.rawValue:
            let preferenceHeader = TableSectionHeaderView()
            preferenceHeader.headerTextLabel.text = "Stocks You May Like"
            preferenceHeader.addButton.setTitle("", for: .normal)
            return preferenceHeader
            
        case Section.news.rawValue:
            let newsHeader = TableSectionHeaderView()
            newsHeader.headerTextLabel.text = "Recent News"
            
            newsHeader.buttonAction = { [weak self] in
                guard let self = self else { return }
                self.coordinator = NewsCoordinator(presenter: self)
                self.coordinator?.start()
            }
            return newsHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case Section.preference.rawValue:
            return 100
        default: return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        switch section {
        case Section.holdings.rawValue:
            return true
            
        case Section.preference.rawValue:
            switch logicController.preferenceState {
            case .new:
                return true
            case .loading:
                return false
            case .loaded:
                return true
            case .error:
                return false
            case .empty:
                return false
            }
        case Section.news.rawValue:
            return !logicController.stockNews.isEmpty
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case Section.holdings.rawValue:
            if !logicController.holdings.isEmpty {
                let holding = logicController.holdings[indexPath.row]
                let stock = Stock(name: "", ticker: holding.ticker)
                coordinator = StockDetailsCoordinator(presenter: self, stockViewModel: StockViewModel(stock: stock))
                coordinator?.start()
            } else {
                handleScreenerSelectionTap()
            }
            
        case Section.preference.rawValue:
            handleStockSuggestionCellSelection(for: indexPath)
            
        case Section.news.rawValue:
            if !logicController.stockNews.isEmpty {
                let newsURLString = logicController.stockNews[indexPath.row].newsUrl
                coordinator = WebViewCoordinator(presenter: self, urlString: newsURLString)
                coordinator?.start()
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.15, animations: {
            cell?.transform = .identity
        }) { (_) in
            cell?.isSelected = false
        }
    }
}
