//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class QuickSearchViewController: UIViewController,UISearchControllerDelegate, UISearchBarDelegate, HomeFeedNavigationDelegate, MenuBarDisplayable {
    
    var delegate: MenuViewItemDelegate?
    var menubarTitle: String = "Quick Search"
    
    private enum ReuseID {
        static let stockCell = "stockCell"
    }
    
    // MARK: - Dependencies
    
    let presetFeedDataLoader: PresetFeedDataLoader

    // MARK: - Data Source
    
    var homeFeedItems: [[Any]] = []
    var searchDisplay: [Company]  = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - State
    
    private enum State {
        case normal
        case searching(searchText: String)
    }
    
    private var state: State = .normal {
        didSet {
            handleStateChange()
        }
    }
    
    private func handleStateChange() {
        switch state {
            
        case .normal:
            searchDisplay.removeAll()
            tableView.isScrollEnabled = true
            
        case .searching(let searchText):
            fetchCompanies(searchText)
            tableView.isScrollEnabled = true
        }
    }
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableHeaderView = searchController.searchBar
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.searchBar.tintColor = .appAccent3
        sc.searchBar.searchBarStyle = .minimal
        sc.dimsBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
        sc.definesPresentationContext = false
        return sc
    }()
    
    lazy var popularCompaniesVC: PopularCompanyViewController = {
        let popularVC = PopularCompanyViewController(popularCompanies: [])
        return popularVC
    }()
    
    // MARK: - Initializer Methods
    
    init(presetDataLoader: PresetFeedDataLoader) {
        self.presetFeedDataLoader = presetDataLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground(in: self)
        initializeFeedData()
        setupTableView()
        fetchPopularCompanyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                tabBarController?.tabBar.backgroundColor = .black
                tabBarController?.tabBar.isTranslucent = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let parent = parent as? HomeFeedContainer {
            parent.collectionView.contentInset = UIEdgeInsets(top: searchController.searchBar.intrinsicContentSize.height + 5,
            left: 0, bottom: 0, right: 0)
             parent.collectionView.setNeedsLayout()
            parent.collectionView.layoutIfNeeded()
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
        }
    }

    // MARK: - View Setup
        
    fileprivate func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.stockCell)
        tableView.contentInsetAdjustmentBehavior = .automatic
        definesPresentationContext = true
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = searchController.searchBar
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 40
        tableView.estimatedSectionFooterHeight = 0        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    // MARK: - Data Setup
    
    fileprivate func initializeFeedData() {
        homeFeedItems.append(presetFeedDataLoader.configureCompanyList())
        homeFeedItems.append(presetFeedDataLoader.configureValueData())
        homeFeedItems.append(presetFeedDataLoader.configureGrowthData())
        homeFeedItems.append(presetFeedDataLoader.configureDividendData())
    }
    
    fileprivate func fetchPopularCompanyData() {
        CompanyViewModel.configureCompanyList().forEach { (popularCompany) in
            NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .marketcap, frequency: .recent, completion: { (result) in
                switch result {
                    
                case .success(let downloadedData):
                    if downloadedData.isEmpty { return }
                    DispatchQueue.main.async {
                        popularCompany.marketcap = Int(downloadedData.first?.value ?? 0)
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
            
            NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .pricetoearnings, frequency: .recent, completion: { (result) in
                switch result {
                    
                case .success(let downloadedData):
                    if downloadedData.isEmpty { return }
                    DispatchQueue.main.async {
                        popularCompany.priceToEarnings = downloadedData.first?.value
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
    
    fileprivate func fetchCompanies(_ searchText: String) {
        NetworkService.shared.intrioAPI.searchByName(name: searchText) { (result) in
            switch result {
                
            case .success(let fetchedCompanies):
                self.searchDisplay = fetchedCompanies
                DispatchQueue.main.async {
                    if fetchedCompanies.isEmpty && !searchText.isEmpty && self.searchDisplay.isEmpty {
                        self.tableView.setEmptyView(state: .emptyState(title: "No Data.", message: "Unable to find a company that matches your search.\nTry searching by ticker."))
                    }
                    if fetchedCompanies.isEmpty && searchText.isEmpty && self.searchDisplay.isEmpty {
                        self.tableView.setEmptyView(state: .emptyState(title: "Get Started.", message: "Search by company or by ticker."))
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.searchDisplay.removeAll()
                    self.tableView.setEmptyView(state: .errorState)
                }
            }
        }
    }
    
    // MARK: - Delegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        state = .normal
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        state = .searching(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        state = .searching(searchText: searchBar.text ?? "")
    }
    
    // MenubarDisplayable
    func navigateToScreenerResults(searchParameters: [String]) {
        AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .quick))
        let searchResultVC = ScreenResultsViewController(searchParameters: searchParameters, networkingAPI: IntrinioAPI())
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
}

extension QuickSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
            
        case .normal:
            tableView.restore()
            return 1
        case .searching:
            if !searchDisplay.isEmpty {
                tableView.restore()
            }
            tableView.separatorStyle = .singleLine
            return searchDisplay.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch state {
            
        case .normal:
            return homeFeedItems.count
        case .searching:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch state {
            
        case .normal:
            switch indexPath.section {
            case 0:
                let companyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                companyCell.backgroundColor = .clear
                display(contentController: popularCompaniesVC, on: companyCell)
                popularCompaniesVC.popularCompanies = homeFeedItems[indexPath.section] as! [PopularCompany]
                return companyCell
                
            case 1,2,3:
                guard let screenerData = homeFeedItems[indexPath.section] as? [PresetScreenerViewModel] else { return emptyCell }
                let screenerCell = PresetScreenerTableViewCell(searches: screenerData)
                screenerCell.delegate = self
                return screenerCell
                
            default:
                return emptyCell
            }
            
        case .searching:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: ReuseID.stockCell)
            cell.textLabel?.text = searchDisplay[indexPath.item].name
            cell.detailTextLabel?.text = searchDisplay[indexPath.item].ticker
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            cell.detailTextLabel?.textColor = .gray
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
            
        case .searching(_):
            let selectedCompany = searchDisplay[indexPath.item]
            let detailsVC = StockDetailsContainerView(ticker: selectedCompany.ticker ?? "", companyName: selectedCompany.name ?? "")
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .nameSearch))
            navigationController?.pushViewController(detailsVC, animated: true)
            
        default:
            break
        }
    }
}

extension QuickSearchViewController {
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch state {
            
        case .normal:
            switch indexPath.section {
            case 0: return 200
            case 1,2,3: return UIScreen.main.bounds.height/6 + 30
            default: return UITableView.automaticDimension
            }
            
        case .searching:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch state {
            
        case .normal:
            let view = UIView()
            let header = LargeSectionHeaderLabel(padding: 16)
            header.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            view.addSubview(header)
            header.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 4, right: 18))
            let labelText = [
                "Popular Companies",
                "Explore Value Stocks",
                "Explore Growth Stocks",
                "Explore Dividend Stocks"
            ]
            header.text = labelText[section]
            return view
            
        case .searching:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch state {
            
        case .normal:
            if section == 0 { return 70 }
            return 44
            
        case .searching:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch state {
            
        case .normal:
            if section == homeFeedItems.count - 1 {
                return UIView()
            }
        case .searching:
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch state {
            
        case .normal:
            if section == homeFeedItems.count - 1 { return 60 }
            return 20
            
        case .searching:
            return 0
        }
    }
}





