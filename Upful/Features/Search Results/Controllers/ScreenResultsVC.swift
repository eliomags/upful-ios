//
//  ScreenResultsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class ScreenResultsViewController: UIViewController {
    
    // MARK: - Dependencies
    
    let searchParameters: [String]
    let intrinioAPI: IntrinioAPI
    
    // Load currently saved screeners to determine save state
    var localScreenerLoader: LocalScreenerLoaderProtocol? = LocalScreenerLoader()
    
    // Save new screener/Override screener with same name
    
    // MARK: - Properties
    
    var headerBackground: UIColor?
    
    // MARK:- State
    
    private(set) var isLoading: Bool = false {
        didSet { observeStateChanges() }
    }
    
    private func observeStateChanges() {
        DispatchQueue.main.async {
            if self.isLoading {
                LoadingViewPresenter.show(in: self)
            } else {
                LoadingViewPresenter.remove()
            }
        }
    }

    // MARK: - DataSource
    
    private var searchResults = [Stock]() {
        didSet {
            feedTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    fileprivate struct ReuseId {
        static let resultsCellID = "resultsCellID"
    }
    
    // MARK: - Views
    
    let resultsDescriptionHeaderLabel: ResultsDescriptionView = {
        let v = ResultsDescriptionView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 165).isActive = true
        return v
    }()
    
    lazy var feedTableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.setTableHeaderView(headerView: headerView)
        tv.register(CompanyPreviewTableViewCell.self, forCellReuseIdentifier: ReuseId.resultsCellID)
        return tv
    }()
    
    lazy var sortButton: SortButton = { [unowned self] in
        let button = SortButton()
        button.backgroundColor = UIColor(white: 0.4, alpha: 0.35)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortTap)))
        return button
    }()
    
    lazy var saveButton: SaveButton = {
        let b = SaveButton()
        return b
    }()
    
    // MARK: - Initializer Methods
    
    init(searchParameters: [String], networkingAPI: IntrinioAPI = .init()) {
        self.searchParameters = searchParameters
        self.intrinioAPI = networkingAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        contentViewSetup()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkScreenerStatus()
        fetchTableData(parameters: searchParameters, fetchType: .initial)
        isLoading = true
    }

    // MARK: - View Set Up
    
    fileprivate func contentViewSetup() {
        view.backgroundColor = .systemBackground
        view.addSubview(resultsDescriptionHeaderLabel)
        resultsDescriptionHeaderLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor,
                                      bottom: nil, trailing: view.trailingAnchor)
        view.addSubview(feedTableView)
        feedTableView.fillSuperview()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        let sortButton = UIBarButtonItem(customView: self.sortButton)
        let saveButton = UIBarButtonItem(customView: self.saveButton)
        navigationItem.rightBarButtonItems = [saveButton, sortButton]
    }

    // MARK: - Fileprivate Functions
    
    fileprivate func checkScreenerStatus() {
        localScreenerLoader?.loadSavedScreeners(completion: { (res) in
            switch res {
            case .success(let screeners):
                print(screeners.map { $0.title })
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    private enum FetchType {
        case initial, appending
    }

    private func fetchTableData(parameters: [String], fetchType: FetchType) {
        let searchKeys = parameters.joined(separator: ",").filter({ $0 != " " })
        intrinioAPI.performStockScreening(parameters: searchKeys) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedData):
                switch fetchType {
                case .initial:
                    self.searchResults = fetchedData
                case .appending:
                    self.searchResults.append(contentsOf: fetchedData)
                }
                self.fetchCompanyFinancialData(searchResults: fetchedData)
                self.isLoading = false
            case .failure(_):
                self.isLoading = false
                DispatchQueue.main.async {
                    self.feedTableView.setEmptyView(state: .errorState)
                }
            }
        }
    }
    
    private func getPriceToEarningsData(_ searchResult: Stock) {
        NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: searchResult.ticker, financial: .pricetoearnings, frequency: .recent, completion: { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let companyHistorics):
                guard !companyHistorics.isEmpty else { return }
                
                DispatchQueue.main.async {
                    searchResult.pricetoearnings = companyHistorics.first?.value
                    self.feedTableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    private func fetchCompanyFinancialData(searchResults: [Stock]) {
        guard !searchResults.isEmpty else {
            DispatchQueue.main.async { self.feedTableView.setEmptyView(state: .emptyState(title: "No Data.", message: "No data to display.")) }
            return
        }
        searchResults.forEach { (searchResult) in
            getPriceToEarningsData(searchResult)
        }
    }

    // MARK: - Actions
    
    /// Handles sorting the loaded Search Results by Market Cap through a UIAlertController
    @objc private func handleSortTap(_ sender: UIButton) {
        intrinioAPI.screenPage = 1
        let sortMenu = UIAlertController(title: nil, message: "Choose Sort", preferredStyle: .actionSheet)
        
        let marketCapAscAction = UIAlertAction(title: "Market Cap Ascending", style: .default, handler: { _ in
            self.intrinioAPI.sortDirection = .asc
            self.feedTableView.reloadData()
            self.fetchTableData(parameters: self.searchParameters, fetchType: .initial)
        })
        let marketCapDescAction = UIAlertAction(title: "Market Cap Descending", style: .default, handler: { _ in
            self.intrinioAPI.sortDirection = .desc
            self.feedTableView.reloadData()
            self.fetchTableData(parameters: self.searchParameters, fetchType: .initial)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [marketCapAscAction, marketCapDescAction, cancelAction].forEach { (action) in
            sortMenu.addAction(action)
        }
        self.present(sortMenu, animated: true, completion: nil)
    }
}

extension ScreenResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isScrollEnabled = !searchResults.isEmpty
        if searchResults.isEmpty { tableView.separatorStyle = .none }
        if !searchResults.isEmpty {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? CompanyPreviewTableViewCell else { return UITableViewCell() }
        let screenResult = searchResults[indexPath.item]
        let ticker = screenResult.ticker
        resultsCell.accessoryType = .disclosureIndicator
        resultsCell.companyTickerLabel.text = ticker
        resultsCell.companyNameLabel.text = screenResult.name
        resultsCell.marketcapStackView.valueLabel.text = "$\(screenResult.marketcap?.formatUsingAbbreviation() ?? " -")"
        resultsCell.pricetoearningsStackView.valueLabel.text = "\(screenResult.pricetoearnings?.twoDecimal() ?? "-")"
        return resultsCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = searchResults.count - 1
        if !isLoading && indexPath.row == lastElement && lastElement > 8 {
            fetchTableData(parameters: searchParameters, fetchType: .appending)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .searchResult))
        let selectedCompany = searchResults[indexPath.item]
        let detailVC = StockDetailsContainerView(ticker: selectedCompany.ticker, companyName: selectedCompany.name)
        
        RemoteStockManager.updateInterest(for: selectedCompany.ticker, name: selectedCompany.name)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
