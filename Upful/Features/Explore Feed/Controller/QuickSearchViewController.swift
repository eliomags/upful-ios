//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, HomeFeedNavigationDelegate {
    
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

    // MARK: - Data Source

    
    // MARK: - State
    
//    private enum State {
//        case normal
//        case searching(searchText: String)
//    }
    
//    private var state: State = .normal {
//        didSet {
//            handleStateChange()
//        }
//    }
//
//    private func handleStateChange() {
//        switch state {
//        case .normal:
//            searchDisplay.removeAll()
//            tableView.isScrollEnabled = true
//        case .searching(let searchText):
////            fetchCompanies(searchText)
//            tableView.reloadData()
//            tableView.isScrollEnabled = true
//        }
//    }
//
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
        sc.hidesNavigationBarDuringPresentation = false
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
        tableView.isScrollEnabled = true
        tableView.reloadData()
    }
    
    fileprivate func handleSearchState() {
        if logicController.stockSearchDisplay.isEmpty {
            tableView.setEmptyView(state: .emptyState(title: "Get Started.",
                                                      message: "Search by company or by ticker."))
        } else {
            tableView.restore()
        }
        tableView.reloadData()
    }
    
    fileprivate func observeCompletionUpdates() {
        logicController.handleCompletion = { [weak self] in
            guard let self = self else { return }
            self.handleSearchCompletion()
            self.handleNormalCompletion()
            self.tableView.restore()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func handleSearchCompletion() {
        guard logicController.state == .searching else { return }
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
        guard logicController.state == .normal else { return }
        tableView.isScrollEnabled = true
    }

    // MARK: - View Setup
        
    fileprivate func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .singleLine
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
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: ReuseID.popularStockCell)
        tableView.register(ScreenerPreviewTableViewCell.self, forCellReuseIdentifier: ReuseID.screenerCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.searchCell)
    }
    
    fileprivate func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = VersionManager.mainContainerBackground()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Explore"
        navigationItem.searchController = self.searchController
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
    
    func navigateToScreenerResults(searchParameters: [String]) {
        PermissionManager.shared.verifyScreenerNavigationPermission { (shouldNavigate) in
            if shouldNavigate {
                AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .quick))
                let searchResultVC = ScreenResultsViewController(searchParameters: searchParameters)
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
            if !shouldNavigate {
                let presenter = SubscriptionPresenter(type: .screeningLimit)
                presenter.present(in: self)
            }
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
        let loadedCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.popularStockCell) as? ResultsTableViewCell
        loadedCell?.accessoryType = .disclosureIndicator
        loadedCell?.backgroundColor = VersionManager.mainContainerBackground()
        if !logicController.stockViewModels.isEmpty {
            let savedStock = logicController.stockViewModels[indexPath.item]
            loadedCell?.companyTickerLabel.text = savedStock.stock.ticker
            loadedCell?.companyNameLabel.text = savedStock.stock.name
            loadedCell?.marketcapStackView.valueLabel.text = "$\(savedStock.stock.marketcap?.formatUsingAbbreviation() ?? " -")"
            loadedCell?.pricetoearningsStackView.valueLabel.text = "\(savedStock.stock.pricetoearnings?.twoDecimal() ?? "-")"
        }
        return loadedCell ?? UITableViewCell()
    }

    fileprivate func makeScreenerCells(at indexPath: IndexPath) -> UITableViewCell {
        let screenerCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.screenerCell, for: indexPath) as? ScreenerPreviewTableViewCell
//        viewModel = logicController.popularScreenerViewModels[indexPath.row]
//        cell?.titleLabel.text = viewModel.title
//        cell?.descriptionLabel.text = viewModel.description
//        cell?.loadImage(urlString: viewModel.imageUrlString)
//        cell?.showLoaded()
        return screenerCell ?? UITableViewCell()
    }
    
    fileprivate func makeSearchCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: ReuseID.searchCell)
        if logicController.stockSearchDisplay.isEmpty { return cell }
        let stockSearchDisplay = logicController.stockSearchDisplay
        
        cell.textLabel?.text = stockSearchDisplay[indexPath.item].name
        cell.detailTextLabel?.text = stockSearchDisplay[indexPath.item].ticker
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch logicController.state {
        case .searching:
            let selectedCompany = logicController.stockSearchDisplay[indexPath.row]
            let detailsVC = StockDetailsContainerView(ticker: selectedCompany.ticker ?? "", companyName: selectedCompany.name ?? "")
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .nameSearch))
            navigationController?.pushViewController(detailsVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - TableView Delegate Methods

extension ExploreViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case Section.news.rawValue:
            return UITableView.automaticDimension
        case Section.stocks.rawValue:
            return 115
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
            default: return nil
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
        // TODO: - Checks whether data is empty, so empty cells are not worthy
        return false
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

extension ExploreViewController: PresentationControllerDelegate {
    func presentationControllerdDidDismiss() {
        showNotificationSetupView()
    }
}






