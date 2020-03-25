//
//  HomeGeneralViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class HomeGeneralViewController: UIViewController, PreferenceDelegate {
            
    private enum Section: Int {
        case holdings = 0
        case news = 1
        case preference = 2
    }
    
    private enum Constants {
        static let newsCellID = "newsCellID"
        static let resultsCellID = "resultsCellID"
        static let noPreferenceCellID = "noPreferenceCellID"
        static let stockHoldingCellID = "stockHoldingCellID"
    }
    
    lazy var logicController: HomeGeneralLogicController = {
        let vm = HomeGeneralLogicController()
        return vm
    }()
    
    var coordinator: Coordinator?

    // MARK: - Views
    
    private lazy var headerView: HomeFeedAuxiliaryActionView = {
        let view = HomeFeedAuxiliaryActionView()
        view.preferenceButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditPreferenceTap)))
        view.suggestionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSendSuggestionsTap)))
        view.premiumButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUpgradeToPremiumTap)))
        if PermissionManager.shared.isPremium { view.premiumButton.removeFromSuperview() }
        return view
    }()
    
    private let tradingBalanceView = TradingBalanceView()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleResfreshing), for: .valueChanged)
        return control
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.refreshControl = refreshControl
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "General"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupTableViewCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModelNewsUpdates()
        observeViewModelPreferenceUpdates()
        observeViewModelHoldingsUpdates()
        logicController.fetchTableData()
        configureTransactionHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logicController.loadHoldings()
        configureTransactionHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.shouldUpdateHeaderViewFrame() {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - View Model Binding

    fileprivate func observeViewModelHoldingsUpdates() {
        logicController.holdingsLoadCompletion = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections([Section.holdings.rawValue], with: .automatic)
            self.configureTransactionHeader()
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
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.separatorStyle = .none
        tableView.setTableHeaderView(headerView: tradingBalanceView)

        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: Constants.newsCellID)
        tableView.register(CompanyPreviewTableViewCell.self, forCellReuseIdentifier: Constants.resultsCellID)
        tableView.register(NoPreferenceTableViewCell.self, forCellReuseIdentifier: Constants.noPreferenceCellID)
        tableView.register(StockHoldingTableViewCell.self, forCellReuseIdentifier: Constants.stockHoldingCellID)
    }
    
    fileprivate func configureTransactionHeader() {
        tradingBalanceView.cashBalanceView.cashValueLabel.text =
            "$\(logicController.tradingEngine.balanceManager.currentCashBalance.withCommas())"
        tradingBalanceView.totalEquityView.equityValueLabel.text =
            "$\(logicController.tradingEngine.balanceManager.totalEquityBalance.withCommas())"
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.timeZone = TimeZone(abbreviation: "EST")
        tradingBalanceView.lastUpdatedLabel.text = "Last Updated, \(df.string(from: Date())) EST"
        
        let equity = logicController.tradingEngine.balanceManager.totalEquityBalance
        equity-25000 > 0 ? tradingBalanceView.setPositive() : tradingBalanceView.setNegative()
        let dollarDiff = (equity - 25_000).withCommas()
        let percentDiff = (((equity / 25_000) - 1) * 100).withCommas()
        tradingBalanceView.totalEquityView.totalReturnLabel.text =
            "$\(dollarDiff) • \(percentDiff)%"
        
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing(_ sender: Any) {
        refreshControl.endRefreshing()
        logicController.fetchTableData()
    }
    
    fileprivate func handleStockSuggestionCellSelection(for indexPath: IndexPath) {
        switch logicController.preferenceState{
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
    
    @objc fileprivate func handleEditPreferenceTap(_ gester: UITapGestureRecognizer) {
        Vibration.light.vibrate()
        let preferencePresenter = PreferencePresenter(presentingViewController: self)
        preferencePresenter.present()
    }
    
    @objc fileprivate func handleSendSuggestionsTap(_ gester: UITapGestureRecognizer) {
        Vibration.light.vibrate()
        let suggestionVC = SuggestionFeedViewController()
        navigationController?.pushViewController(suggestionVC, animated: true)
    }
    
    @objc fileprivate func handleUpgradeToPremiumTap(_ gester: UITapGestureRecognizer) {
        Vibration.light.vibrate()
        let presenter = SubscriptionPresenter(type: .settings)
        presenter.present(in: self)
    }

    // MARK: - Preference Delegate Methods
        
    func didCompleteSaving() {
        logicController.startPreferenceLoad()
    }
    
    // MARK: - TableView Cells
    
    fileprivate func makeHoldingsCell(at indexPath: IndexPath) -> UITableViewCell {
        if logicController.holdings.isEmpty {
            return EmptyStockHoldingCell()
        } else {
            let stockHoldingsCell = tableView.dequeueReusableCell(withIdentifier: Constants.stockHoldingCellID,
                                                                  for: indexPath) as? StockHoldingTableViewCell
            let holding = logicController.holdings[indexPath.row]
            stockHoldingsCell?.tickerLabel.text = holding.ticker
            stockHoldingsCell?.numberOfSharesLabel.text = "\(holding.totalShareCount) shares"
            stockHoldingsCell?.currentPriceLabel.text = "$\(holding.currentPrice?.roundToTwoDecimal() ?? "")"
            stockHoldingsCell?.averagePriceLabel.text = "$\(holding.averagePrice.roundToTwoDecimal())"
            stockHoldingsCell?.dollarChangeLabel.text = "$" + holding.totalPriceMovementDollar.roundToTwoDecimal()
            stockHoldingsCell?.percentChangeView.percentChangeLabel.text = holding.totalPriceMovementPercent
            
            if holding.totalPriceMovementDollar > 0 {
                stockHoldingsCell?.percentChangeView.showPositive()
            } else if holding.totalPriceMovementDollar > 0 {
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
        guard let loadedCell = tableView.dequeueReusableCell(withIdentifier: Constants.resultsCellID) as? CompanyPreviewTableViewCell else { return UITableViewCell() }
        loadedCell.accessoryType = .disclosureIndicator
        loadedCell.backgroundColor = VersionManager.mainContainerBackground()

        if logicController.preferenceState == .loaded  && !logicController.stocksYouMayLike.isEmpty {
            let stockViewModel = logicController.stocksYouMayLike[indexPath.row]
            loadedCell.companyTickerLabel.text = stockViewModel.stock.ticker
            loadedCell.companyNameLabel.text = stockViewModel.stock.name
            loadedCell.marketcapStackView.valueLabel.text = "$\(stockViewModel.stock.marketcap?.formatUsingAbbreviation() ?? " -")"
            loadedCell.pricetoearningsStackView.valueLabel.text = "\(stockViewModel.stock.pricetoearnings?.twoDecimal() ?? "-")"
            loadedCell.quoteView.priceLabel.text = "$\(stockViewModel.stock.stockQuote?.latestPrice.roundToTwoDecimal() ?? "-")"
            loadedCell.quoteView.priceChangeLabel.text = "\(stockViewModel.stock.stockQuote?.changePercent.convertToPercent() ?? "-")%"
            
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
}

// MARK: - TableView Delegate/Datasource Methods

extension HomeGeneralViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.holdings.rawValue:
            if logicController.holdings.isEmpty {
                return 1
            } else {
                return logicController.holdings.count
            }
            
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
        case Section.holdings.rawValue:
            return makeHoldingsCell(at: indexPath)
            
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
        return UITableView.automaticDimension 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.holdings.rawValue:
            let header = HeaderLabel()
            let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2).pointSize
            header.font = UIFont.systemFont(ofSize: size, weight: .bold)
            header.text = "MY HOLDINGS"
            return header
            
        case Section.preference.rawValue:
            let preferenceHeader = TableSectionHeaderView()
            preferenceHeader.headerTextLabel.text = "STOCKS YOU MAY LIKE"
            
            preferenceHeader.buttonAction = { [weak self] in
                guard let self = self else { return }
                let randomSavedSearchParameters = self.logicController.getRandomPreferenceGroup()
                self.coordinator = SearchResultsCoordinator(presenter: self,
                                                            searchParameters: randomSavedSearchParameters,
                                                            title: "Stocks You May Like", screenerDescription: "",
                                                            headerbackgroundColor: .appAccent3, id: "")
            
                self.coordinator?.start()
            }
            return preferenceHeader
            
        case Section.news.rawValue:
            let newsHeader = TableSectionHeaderView()
            newsHeader.headerTextLabel.text = "RECENT NEWS"
            
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
        return 75
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        switch section {
        case Section.holdings.rawValue:
            return !logicController.holdings.isEmpty
            
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

extension HomeGeneralViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        if PermissionManager.shared.isPremium { headerView.premiumButton.removeFromSuperview() }
    }
}

