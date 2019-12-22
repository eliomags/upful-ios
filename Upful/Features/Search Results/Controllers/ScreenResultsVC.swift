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
    
    // MARK:- State
    
    private(set) var isLoading: Bool = false {
        didSet { observeStateChanges(isLoading) }
    }
    
    private func observeStateChanges(_ state: Bool) {
        self.showActivitySpinner(state)
    }

    // MARK: - DataSource
    
    var searchResults = [Stock]() {
        didSet {
            feedTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    struct ReuseId {
        static let resultsCellID = "resultsCellID"
    }
    
    // MARK: - Views
    
    lazy var feedTableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.register(ResultsTableViewCell.self, forCellReuseIdentifier: ReuseId.resultsCellID)
        return tv
    }()
    
    var loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.startAnimating()
        v.addSubview(activityView)
        activityView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 30, left: 30, bottom: 30, right: 30))
        v.layer.cornerRadius = 15
        v.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return v
    }()
    
    lazy var sortButton: SortButton = { [unowned self] in
        let button = SortButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortTap)))
        return button
    }()
    
    // MARK: - Initializer Methods
    
    init(searchParameters: [String], networkingAPI: IntrinioAPI) {
        self.searchParameters = searchParameters
        self.intrinioAPI = networkingAPI
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        fetchTableData(parameters: searchParameters, fetchType: .initial)
        view.addSubview(feedTableView)
        feedTableView.fillSuperview()
        isLoading = true
    }

    // MARK: - View Set Up
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Results"
        navigationItem.largeTitleDisplayMode = .never
        let sortButton = UIBarButtonItem(customView: self.sortButton)
        navigationItem.rightBarButtonItem = sortButton
    }

    // MARK: - Fileprivate Functions
    
    private enum FetchType {
        case initial, appending
    }
    
    private func fetchTableData(parameters: [String], fetchType: FetchType) {
        var searchKeys = ""
        parameters.forEach { (parameter) in
            searchKeys += "\(parameter),"
        }
        intrinioAPI.performStockScreening(parameters: searchKeys) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedData):
                switch fetchType {
                case .initial: self.searchResults = fetchedData
                case .appending: self.searchResults.append(contentsOf: fetchedData)
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? ResultsTableViewCell else { return UITableViewCell() }

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
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ScreenResultsViewController {
    func showActivitySpinner(_ shouldShowSpinner: Bool) {
        if shouldShowSpinner {
            self.view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        if !shouldShowSpinner {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
            }
        }
    }
}

