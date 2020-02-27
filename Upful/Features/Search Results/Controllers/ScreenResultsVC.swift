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
    
    lazy var viewModel: SearchResultsViewModel = {
        let vm = SearchResultsViewModel()
        vm.delegate = self
        return vm
    }()
            
    // MARK: - Properties
            
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
        b.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Initializer Methods
    
    init(searchParameters: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.searchParameters = searchParameters
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
        setSavedState()
        loadStocks()
    }

    // MARK: - View Setup
    
    fileprivate func contentViewSetup() {
        view.backgroundColor = .systemBackground
        view.addSubview(resultsDescriptionHeaderLabel)
        resultsDescriptionHeaderLabel.anchor(
            top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor,
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
    
    // MARK: - View Configuration
    
    fileprivate func setSavedState() {
        viewModel.checkIfScreenerCurrentlySaved { (isSaved) in
            self.saveButton.isSelected = isSaved
        }
    }

    // MARK: - Fileprivate Functions
    
    fileprivate func loadStocks() {
        LoadingViewPresenter.show(in: self)
        viewModel.screenForStocks()
    }
    
    fileprivate func saveScreener() {
        if viewModel.screener?.title == "Custom" {
            let alert = UIAlertController(
                            title: "Add to Favorites",
                            message: "Give your screener a name.",
                            preferredStyle: .alert
            )
            alert.addTextField { (titleTextField) in
                titleTextField.text = self.viewModel.screener?.title
                titleTextField.placeholder = "Title"
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                var titleTextFieldText = alert?.textFields![0].text
                if titleTextFieldText == "" { titleTextFieldText = "No Title" }
                self.viewModel.handleSaveCompletion(with: titleTextFieldText ?? "No Title")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.viewModel.handleSaveCompletion(with: viewModel.screener?.title ?? "No Title")
        }
    }
    
    private func fetchCompanyFinancialData(searchResults: [Stock]) {
        guard !searchResults.isEmpty else {
            DispatchQueue.main.async { self.feedTableView.setEmptyView(state: .emptyState(title: "No Data.", message: "No data to display.")) }
            return
        }
    }

    // MARK: - Actions
    
    /// Handles sorting the loaded Search Results by Market Cap through a UIAlertController
    @objc private func handleSortTap(_ sender: UIButton) {
        let sortMenu = UIAlertController(title: nil, message: "Choose Sort", preferredStyle: .actionSheet)
        let marketCapAscAction = UIAlertAction(title: "Market Cap Ascending", style: .default, handler: { _ in
            self.viewModel.changeScreenerDirection()
            self.feedTableView.reloadData()
        })
        let marketCapDescAction = UIAlertAction(title: "Market Cap Descending", style: .default, handler: { _ in
            self.viewModel.changeScreenerDirection()
            self.feedTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [marketCapAscAction, marketCapDescAction, cancelAction].forEach { (action) in
            sortMenu.addAction(action)
        }
        self.present(sortMenu, animated: true, completion: nil)
    }
        
    @objc private func handleSaveTap(_ sender: UIButton) {
        if !sender.isSelected {
            saveScreener()
        } else {
            sender.isSelected = !sender.isSelected
            viewModel.deleteScreener()
        }
    }
}

extension ScreenResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isScrollEnabled = !viewModel.searchResults.isEmpty
        if viewModel.searchResults.isEmpty { tableView.separatorStyle = .none }
        if !viewModel.searchResults.isEmpty {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? CompanyPreviewTableViewCell else { return UITableViewCell() }
        let screenResult = viewModel.searchResults[indexPath.item]
        let ticker = screenResult.ticker
        resultsCell.accessoryType = .disclosureIndicator
        resultsCell.companyTickerLabel.text = ticker
        resultsCell.companyNameLabel.text = screenResult.name
        resultsCell.marketcapStackView.valueLabel.text = "$\(screenResult.marketcap?.formatUsingAbbreviation() ?? " -")"
        resultsCell.pricetoearningsStackView.valueLabel.text = "\(screenResult.pricetoearnings?.twoDecimal() ?? "-")"
        return resultsCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.searchResults.count - 1
        if indexPath.row == lastElement - 1 && lastElement > 10 {
            viewModel.screenForStocks()
        }
//        if !isLoading && indexPath.row == lastElement && lastElement > 8 {
//            fetchTableData(parameters: searchParameters, fetchType: .appending)
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .searchResult))
        let selectedCompany = viewModel.searchResults[indexPath.item]
        let detailVC = StockDetailsContainerView(ticker: selectedCompany.ticker, companyName: selectedCompany.name)
        
        RemoteStockManager.updateInterest(for: selectedCompany.ticker, name: selectedCompany.name)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ScreenResultsViewController: SearchResultsViewModelDelegate {
    func didCompleteStockFetch(fetchedStocks: [Stock]) {
        DispatchQueue.main.async {
            LoadingViewPresenter.remove()
            if !fetchedStocks.isEmpty {
                self.feedTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            } else if self.viewModel.searchResults.isEmpty {
                self.feedTableView.setEmptyView(state: .emptyState(title: "No Data.", message: "No data to display."))
                self.feedTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }
        }
    }
    
    func didFailStockFetch(with error: NetworkError, for stock: Stock?) {
        print(error)
    }
    
    func didCompleteScreenerSave() {
        saveButton.isSelected = true
        feedTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func didFailScreenerSave() {
        let presenter = SubscriptionPresenter(type: .savedStockLimit)
        presenter.present(in: self)
    }
}

extension ScreenResultsViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    func userDidSignUp() {}
}
