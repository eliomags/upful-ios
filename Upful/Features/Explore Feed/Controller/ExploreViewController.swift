//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Kingfisher

final class ExploreViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    private enum ReuseID {
        static let largeNewsCell = "largeNewsCellID"
        static let smallNewsCell = "smallNewsCellID"
        static let screenerCell = "screenerCellID"
        static let popularStockCell = "popularStockCellID"
        static let searchCell = "searchCellID"
    }
    
    enum Section: Int {
        case news = 0
        case stocks = 1
        case screeners = 2
    }
            
    // MARK: - Dependencies
    
    lazy var logicController: ExploreLogicController = {
        let lc = ExploreLogicController()
        return lc
    }()
    
    var coordinator: Coordinator?

    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.searchBar.tintColor = .appAccent3
        sc.searchBar.searchBarStyle = .minimal
        sc.obscuresBackgroundDuringPresentation = false
//        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = VersionManager.mainContainerBackground()
        configureNavBar()
        setupTableView()
        setupTableViewCells()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        observeCompletionUpdates()
        observeStateUpdates()
        logicController.startLoad()
    }
    
    // MARK: - Observers
    
    fileprivate func observeStateUpdates() {
        logicController.handleStateUpdates = { [weak self] (newState) in
            guard let self = self else { return }
            switch newState {
            case .normal:
                self.handleNormalState()
            case .searching:
                self.handleSearchState()
            }
        }
    }
    
    fileprivate func handleNormalState() {
        tableView.restore()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.reloadData()
    }
    
    fileprivate func handleSearchState() {
        if logicController.stockSearchDisplay.isEmpty {
            tableView.setEmptyView(state: .emptyState(title: "Get Started.",
                                                      message: "Search by company or by ticker."))
        } else {
            tableView.restore()
            tableView.separatorStyle = .singleLine
        }
        tableView.reloadData()
    }
    
    fileprivate func observeCompletionUpdates() {
        logicController.handleCompletion = { [weak self] in
            guard let self = self else { return }
            switch self.logicController.state {
            case .normal:
                self.handleNormalCompletion()
            case .searching:
                self.handleSearchCompletion()
            }
            self.tableView.restore()
            self.tableView.separatorStyle = .none
            self.tableView.reloadData()
        }
    }
    
    fileprivate func handleSearchCompletion() {
        tableView.isScrollEnabled = false
        if logicController.stockSearchDisplay.isEmpty {
            tableView.setEmptyView(state: .emptyState(title: "Get Started.",
                                                      message: "Search by company or by ticker."))
        }
        if logicController.stockSearchDisplay.isEmpty && (searchController.searchBar.text != nil) {
            tableView.setEmptyView(state: .emptyState(title: "No Data.",
                                                      message: "Unable to find a company that matches your search.\nTry searching by ticker."))
        }
    }
    
    fileprivate func handleNormalCompletion() {
        tableView.isScrollEnabled = true
    }

    // MARK: - View Setup
        
    fileprivate func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        definesPresentationContext = true
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(NewsHeaderTableCell.self, forCellReuseIdentifier: ReuseID.largeNewsCell)
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: ReuseID.smallNewsCell)
        tableView.register(CompanyPreviewTableViewCell.self, forCellReuseIdentifier: ReuseID.popularStockCell)
        tableView.register(ScreenerPreviewTableViewCell.self, forCellReuseIdentifier: ReuseID.screenerCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.searchCell)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Explore"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = self.searchController
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = VersionManager.mainContainerBackground()
    }
    
    // MARK: - Delegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        logicController.state = .normal
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        logicController.startSearch(forCompaniesContaining: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        logicController.state = .searching
    }
    
    // MARK: - Navigation
    
    fileprivate func handleSelectedScreenerNavigation(at indexPath: IndexPath) {
        let selectedPopularScreener = logicController.screenerViewModels[indexPath.row]
        
        AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .popular))
        RemoteScreenerLoader.incrementScreenerInterest(documentID: selectedPopularScreener.documentID ?? "")
        coordinator = SearchResultsCoordinator(presenter: self, screenerViewModel: selectedPopularScreener)
        coordinator?.start()
    }

    fileprivate func handleNormalStateNavigation(_ indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case Section.news.rawValue:
            AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)
            
            let selectedNewsURL = logicController.marketNewsViewModels[indexPath.row].newsUrl
            let webviewVC = UINavigationController(rootViewController: WebViewViewController(urlString: selectedNewsURL))
            present(webviewVC, animated: true, completion: nil)
        case Section.stocks.rawValue:
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .popular))
            
            let selectedPopularStock = logicController.stockViewModels[indexPath.row]
            RemoteStockManager.updateInterest(
                for: selectedPopularStock.stock.ticker,
                name: selectedPopularStock.stock.name
            )
            let stockDetailsVC = StockDetailsContainerView(stockViewModel: logicController.stockViewModels[indexPath.row])
             
            self.navigationController?.pushViewController(stockDetailsVC, animated: true)
            
        case Section.screeners.rawValue:
            PermissionManager.shared.verifyScreenerNavigationPermission { (permissionGranted) in
                if permissionGranted {
                    handleSelectedScreenerNavigation(at: indexPath)
                } else {
                    let presenter = SubscriptionPresenter(type: .screeningLimit)
                    presenter.present(in: self)
                }
            }
        default:
            break
        }
    }
    
    // MARK: - TableView Cells
    
    fileprivate func makeNewsCells(at indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            let newsHeaderCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.largeNewsCell, for: indexPath) as! NewsHeaderTableCell
            let newsViewModels = logicController.marketNewsViewModels
            if !newsViewModels.isEmpty {
                newsHeaderCell.stockNews = newsViewModels[indexPath.row]
            }
            return newsHeaderCell
        case 1,2:
            let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.smallNewsCell, for: indexPath) as! SmallNewsCell
            let newsViewModels = logicController.marketNewsViewModels
            if !newsViewModels.isEmpty {
                newsCell.stockNews = newsViewModels[indexPath.row]
            }
            return newsCell
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func showPopularStockCell(at indexPath: IndexPath) -> UITableViewCell {
        let loadedCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.popularStockCell,
                                                       for: indexPath) as? CompanyPreviewTableViewCell
        loadedCell?.accessoryType = .disclosureIndicator
        loadedCell?.backgroundColor = VersionManager.mainContainerBackground()
        
        if !logicController.stockViewModels.isEmpty {
            let savedStock = logicController.stockViewModels[indexPath.item]
            loadedCell?.companyTickerLabel.text = savedStock.stock.ticker
            loadedCell?.marketcapStackView.valueLabel.text = "$\(savedStock.stock.marketcap?.formatUsingAbbreviation() ?? " -")"
            loadedCell?.pricetoearningsStackView.valueLabel.text = "\(savedStock.stock.pricetoearnings?.twoDecimal() ?? "-")"
            loadedCell?.quoteView.priceLabel.text = "$\(savedStock.stock.stockQuote?.latestPrice.roundToTwoDecimal() ?? "-")"
            loadedCell?.quoteView.percentChangeView.percentChangeLabel.text =
                "\(savedStock.stock.stockQuote?.changePercent.convertToPercent() ?? "-")%"
            
            if savedStock.stock.stockQuote?.changePercent ?? 0 > 0 {
                loadedCell?.quoteView.setPositive()
            } else if savedStock.stock.stockQuote?.changePercent ?? 0 < 0 {
                loadedCell?.quoteView.setNegative()
            }
        }
        return loadedCell ?? UITableViewCell()
    }

    fileprivate func makeScreenerCells(at indexPath: IndexPath) -> UITableViewCell {
        let screenerCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.screenerCell,
                                                         for: indexPath) as? ScreenerPreviewTableViewCell
        if !logicController.screenerViewModels.isEmpty {
            let viewModel = logicController.screenerViewModels[indexPath.row]
            screenerCell?.titleLabel.text = viewModel.title
            screenerCell?.descriptionLabel.text = viewModel.description
            screenerCell?.iconImageView.image = viewModel.getSymbol()
            screenerCell?.iconImageViewBackground.backgroundColor = viewModel.getColor()
            screenerCell?.showLoaded()
        }
        return screenerCell ?? UITableViewCell()
    }
    
    fileprivate func makeSearchCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: ReuseID.searchCell)
        if logicController.stockSearchDisplay.isEmpty { return cell }
        let stockSearchDisplay = logicController.stockSearchDisplay
        if !logicController.stockSearchDisplay.isEmpty {
            cell.textLabel?.text = stockSearchDisplay[indexPath.item].name
            cell.detailTextLabel?.text = stockSearchDisplay[indexPath.item].ticker
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - TableView DataSource Methods

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch logicController.state {
        case .normal:
            switch section {
            case Section.news.rawValue:
                return 3
            case Section.screeners.rawValue:
                return 3
            case Section.stocks.rawValue:
                return 4
            default:
                return 1
            }
        case .searching:
            return logicController.stockSearchDisplay.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch logicController.state {
        case .normal:
            return 3
        case .searching:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch logicController.state {
        case .normal:
            let section = indexPath.section
            switch section {
            case Section.news.rawValue:
                return makeNewsCells(at: indexPath)
            case Section.screeners.rawValue:
                return makeScreenerCells(at: indexPath)
            case Section.stocks.rawValue:
                return showPopularStockCell(at: indexPath)
            default:
                return UITableViewCell()
            }
        case .searching:
            return makeSearchCell(at: indexPath)
        }
    }
}

// MARK: - TableView Delegate Methods

extension ExploreViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch logicController.state {
        case .normal:
            handleNormalStateNavigation(indexPath)
        case .searching:
            let selectedCompany = logicController.stockSearchDisplay[indexPath.row]
            let stockVM = StockViewModel(stock: Stock(name: selectedCompany.name ?? "",
                                                      ticker: selectedCompany.ticker ?? ""))
            let detailsVC = StockDetailsContainerView(stockViewModel: stockVM)
            
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .nameSearch))
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case Section.news.rawValue:
            return UITableView.automaticDimension
        case Section.stocks.rawValue:
            let isPopularStocksEmpty = logicController.stockViewModels.isEmpty
            return isPopularStocksEmpty ? 115 : UITableView.automaticDimension
        case Section.screeners.rawValue:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch logicController.state {
        case .normal:
            let sectionHeader = TableSectionHeaderView()
            sectionHeader.addButton.setTitle("", for: .normal)
            switch section {
            case Section.news.rawValue:
                sectionHeader.headerTextLabel.text = "Market News"
            case Section.stocks.rawValue:
                sectionHeader.headerTextLabel.text = "Popular Stocks"
            case Section.screeners.rawValue:
                sectionHeader.headerTextLabel.text = "Popular Screeners"
            default:
                return nil
            }
            return sectionHeader
        case .searching:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch logicController.state {
        case .normal:
            return 44
        case .searching:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch logicController.state {
        case .normal:
            let section = indexPath.section
            switch section {
            case Section.news.rawValue:
                return !logicController.marketNewsViewModels.isEmpty
            case Section.stocks.rawValue:
                return !logicController.stockViewModels.isEmpty
            case Section.screeners.rawValue:
                return !logicController.screenerViewModels.isEmpty
            default:
                return false
            }
        case .searching:
            return true
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

extension ExploreViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {
        showNotificationSetupView()
    }
    
    func userDidSignUp() {}
}






