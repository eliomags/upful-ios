//
//  StockSearchViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockSearchViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    private enum ReuseID {
        static let stockCell = "stockCell"
    }
    
    // MARK: - Dependencies
    
    let intrinioAPI: IntrinioAPI
    
    // MARK: - State
    
    private var displayData: [Company] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isTableEmpty: Bool {
        return displayData.isEmpty
    }
    
    // MARK: - Views
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.searchBar.tintColor = .black
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    // MARK: - Initializer Functions
    init(networkingAPI: IntrinioAPI) {
        self.intrinioAPI = networkingAPI
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.register(StockSearchCell.self, forCellReuseIdentifier: ReuseID.stockCell)
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationItem.title = "Search"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    fileprivate func fetchCompanies(_ searchText: String) {
        intrinioAPI.searchByName(name: searchText) { (result) in
            switch result {
            case .success(let fetchedCompanies):
                self.displayData = fetchedCompanies
                if fetchedCompanies.isEmpty {
                    DispatchQueue.main.async {
                        self.tableView.setEmptyView(state: .emptyState(title: "No Data.", message: "Unable to find a company that matches your search.\nTry searching by ticker."))
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.tableView.setEmptyView(state: .errorState)
                }
            }
        }
    }
    
    // MARK: - SearchBar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchCompanies(searchText)
    }
    
    // MARK: - ScrollView Delegate Methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.resignFirstResponder()
        view.endEditing(true)
        if scrollView.contentOffset.y < 0 {
            
        } else {
            
        }
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayData.isEmpty {
            tableView.setEmptyView(state: .emptyState(title: "Get Started.", message: "Search by company or by ticker."))
        } else {
            tableView.restore()
        }
        return displayData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.stockCell, for: indexPath) as? StockSearchCell else { return UITableViewCell() }
        cell.companyNameLabel.text = displayData[indexPath.item].name
        cell.companyTickerLabel.text = displayData[indexPath.item].ticker
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .nameSearch))
//        let selectedCompany = displayData[indexPath.item]
//        let detailsVC = StockDetailsContainerView(ticker: selectedCompany.ticker ?? "", companyName: selectedCompany.name ?? "")
//        navigationController?.pushViewController(detailsVC, animated: true)
    }
}





