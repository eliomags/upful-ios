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
        case holdings = 0
        case breakdown = 1
        case preference = 2
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
    
    fileprivate var shouldDisplayBreakDownCell = false {
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
        beginOperationUpdates()
        
        guard self.tabBarController != nil else {
            return
        }
        SplashScreenController.presentSplashScreen(in: self.tabBarController!, completion: { [weak self] in
            guard let self = self else { return }
            SubscriptionPresenter(type: .firstAppOpen).present(in: self)
            UserFeedbackPresenter.checkAndAskForReview(checkType: .newSession, in: self)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logicController.loadHoldings()
        configureTransactionHeaderSuccess()
        checkIfNeedsShowTitle()
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
        clearTitle()
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
    
    fileprivate func beginOperationUpdates() {
        observeViewModelHoldingsUpdates()
        observeViewModelPreferenceUpdates()
        logicController.fetchTableData()
    }
    
    fileprivate func cancelOperationUpdates() {
        logicController.holdingsLoadCompletion = { _ in }
        logicController.cancelHoldingsLoad()
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
        tableView.register(EmptyPreferenceTableViewCell.self,
                           forCellReuseIdentifier: Constants.noPreferenceCellID)
        tableView.register(StockHoldingTableViewCell.self,
                           forCellReuseIdentifier: Constants.stockHoldingCellID)
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.loadingCellID)
        tableView.register(HoldingBreakdownHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: Constants.breakdownHeaderID)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing() {
        refreshControl.endRefreshing()
        logicController.fetchTableData()
        logicController.loadHoldings()
    }
    
    fileprivate func handleStockSuggestionCellSelection(for indexPath: IndexPath) {
        switch logicController.preferenceState {
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
    
    @objc private func handlePreferencesGetStartedTap() {
        let preferencePresenter = PreferencePresenter(presentingViewController: self)
        preferencePresenter.present()
    }

    // MARK: - Preference Delegate Methods
        
    func didCompleteSaving() {
        logicController.startPreferenceLoad()
    }
    
    // MARK: - ScrollView Delegate Methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIfNeedsShowTitle()
    }
    
    private func checkIfNeedsShowTitle() {
        if tableView.contentOffset.y == 0 { return }
        
        let height: CGFloat = tradingBalanceView.frame.height -
            tradingBalanceView.cashBalanceView.frame.height -
            tradingBalanceView.lastUpdatedLabel.frame.height -
            70
        
        if tableView.contentOffset.y >= height {
            navigationItem.title = "$\(logicController.totalEquity?.withCommas() ?? " -")"
        } else {
            clearTitle()
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
        
        let dollarDiff = (equity - BalanceConstants.initialCash).withCommas()
        let percentDiff = (((equity / BalanceConstants.initialCash) - 1) * 100).withCommas()
        
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
    
    private func clearTitle() {
        title = ""
        navigationItem.title = ""
    }
    
    // MARK: Breakdown Section
    
    fileprivate func reloadBreakdownSectionHeader() {
        let breakdownSection = Section.breakdown.rawValue

        if !shouldDisplayBreakDownCell {
            tableView.deleteRows(at: [[breakdownSection,0]], with: .fade)
        }

        tableView.reloadSections([breakdownSection], with: .automatic)
        
        if shouldDisplayBreakDownCell {
        } else {
            navigationItem.title = ""
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
    
    // MARK: Create Context Menus
    
    fileprivate func makeStockViewAction(for dataSource: [StockViewable], at row: Int) -> UIAction {
        let viewImage = UIImage(systemName: "magnifyingglass")
        return UIAction(
                    title: "View",
                    image: viewImage,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    attributes: [], state: .off) { (_) in
            let stockViewModel = StockViewModel(stock: Stock(name: "", ticker: dataSource[row].ticker))
                        self.coordinator = StockDetailsCoordinator(presenter: self, stockViewModel: stockViewModel)
            self.coordinator?.start()
        }
    }
    
    fileprivate func makeTradeAction(for dataSource: [StockViewable], at row: Int) -> UIAction {
        let tradeImage = UIImage(systemName: "arrow.up.arrow.down")
        return UIAction(
                    title: "Trade",
                    image: tradeImage,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    attributes: [], state: .off) { (_) in
            let stockTicker = dataSource[row].ticker
            self.coordinator = StockTradeCoordinator(self, ticker: stockTicker)
            self.coordinator?.start()
        }
    }
    
    fileprivate func makeHoldingsContextActions(_ row: Int) -> [UIAction] {
        let sellImage = UIImage(systemName: "arrow.up")
        let sellAllAction = UIAction(
            title: "Sell All",
            image: sellImage,
            identifier: nil,
            discoverabilityTitle: nil,
            attributes: [.destructive], state: .off) { (_) in
                let holding = self.logicController.holdings[row]
                let tradePrice = holding.currentPrice

                let transaction = TransactionAdapter(ticker: holding.ticker, shares: Int32(holding.totalShareCount), tradePrice: tradePrice!)
                TradingEngine.shared.sell(transaction: transaction) { [weak self] in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        Vibration.success.vibrate()
                        InformationViewPresenter().showGenericSuccess(in: self, description: "Sold Successfully", completion: { [weak self] in
                            self?.handleResfreshing()
                        })
                    }
                }
            }
        
        return [makeStockViewAction(for: self.logicController.holdings, at: row),
                makeTradeAction(for: self.logicController.holdings, at: row),
                sellAllAction]
    }
    
    // MARK: TableViewCell Configuration
    
    fileprivate func makeBreakdownCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.breakdownCellID,
                                                 for: indexPath) as? HoldingsBreakdownTableViewCell
        cell?.chartView.setupPieChart(chartConfigurables: pieChartViewModels)
        
        return cell ?? UITableViewCell()
    }
    
    fileprivate func makeHoldingsCell(at indexPath: IndexPath) -> UITableViewCell {
        if logicController.holdings.isEmpty {
            let emptyHoldingsCell = EmptyHoldingsTableViewCell()
            emptyHoldingsCell.actionButton.addTarget(self, action: #selector(handleScreenerSelectionTap), for: .touchUpInside)
            return emptyHoldingsCell
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
            as? EmptyPreferenceTableViewCell else { return UITableViewCell() }
        noPreferenceSetCell.selectionStyle = .none
        noPreferenceSetCell.backgroundColor = .clear
        noPreferenceSetCell.actionButton.addTarget(self, action: #selector(handlePreferencesGetStartedTap), for: .touchUpInside)
        
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
//                UITableView.automaticDimension : (UIScreen.main.bounds.height / 2) - 130
                UITableView.automaticDimension : 280

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
                header?.addButton.isSelected = !self.shouldDisplayBreakDownCell
            }
            return header
            
        case Section.holdings.rawValue:
            let holdingsHeader = TableSectionHeaderView()
            holdingsHeader.headerTextLabel.text = "Holdings"
            holdingsHeader.addButton.setTitle("", for: .normal)
            return holdingsHeader
            
        case Section.preference.rawValue:
            let preferenceHeader = TableSectionHeaderView()
            preferenceHeader.headerTextLabel.text = "Stocks You May Like"
            preferenceHeader.addButton.setTitle("", for: .normal)
            return preferenceHeader

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
            return !logicController.holdings.isEmpty

        case Section.preference.rawValue:
            switch logicController.preferenceState {
            case .new:
                return false
            case .loading:
                return false
            case .loaded:
                return true
            case .error:
                return false
            case .empty:
                return false
            }
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
            
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeGeneralViewController {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        cancelOperationUpdates()
        
        let isHoldingsSection = indexPath.section == Section.holdings.rawValue  && logicController.holdings.count > 0
        if isHoldingsSection {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in
                let children: [UIMenuElement] = self.makeHoldingsContextActions(indexPath.row)
                return UIMenu(title: "", children: children)
            }
        }
        
        let isPreferenceSection = indexPath.section == Section.preference.rawValue && logicController.stocksYouMayLike.count > 0
        if isPreferenceSection {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in
                let children: [UIMenuElement] = [self.makeStockViewAction(for: self.logicController.stocksYouMayLike, at: indexPath.row),
                                                 self.makeTradeAction(for: self.logicController.stocksYouMayLike, at: indexPath.row)]
                return UIMenu(title: "", children: children)
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.observeViewModelHoldingsUpdates()
            self.logicController.loadHoldings()
        }
        
        return nil
    }
}

extension HomeGeneralViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        print("Did Complete Sign up")
    }
}
