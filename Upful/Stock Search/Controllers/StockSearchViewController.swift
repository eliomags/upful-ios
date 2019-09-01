//
//  StockSearchViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockSearchViewController: UITableViewController, UISearchBarDelegate {
    
    private enum ReuseID {
        static let stockCell = "stockCell"
    }
    
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
    
    
    // MARK: - Dependencies
    
    let intrinioAPI: IntrinioAPI
    
    // MARK: - Views
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = UISearchBar.Style.minimal
        sb.sizeToFit()
        sb.placeholder = "Search"
        sb.delegate = self
        return sb
    }()
    
    
    // MARK: - Initializer Functions
    
    init(networkingAPI: IntrinioAPI) {
        self.intrinioAPI = networkingAPI
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.tableHeaderView = searchBar
        tableView.register(StockSearchCell.self, forCellReuseIdentifier: ReuseID.stockCell)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupViews() {
        self.tableView.tableHeaderView = searchBar
    }
    
    
    // MARK: - Search Bar Delegate methods
    
    fileprivate func fetchCompanies(_ searchText: String) {
        intrinioAPI.searchByName(name: searchText) { (result) in
            switch result {
            case .success(let fetchedCompanies):
                self.displayData = fetchedCompanies
                if fetchedCompanies.isEmpty {
                    DispatchQueue.main.async {
                        self.tableView.setEmptyView(state: .emptyState(message: "Unable to find a company that matches your search.\nTry searching by ticker."))
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.tableView.setEmptyView(state: .errorState)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchCompanies(searchText)
    }
    
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayData.isEmpty {
            tableView.setEmptyView(state: .emptyState(message: "Search by company or by ticker."))
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
        let placeHolder = displayData[indexPath.item]
        let stockDetailsVC = StockDetailsViewController(ticker: placeHolder.ticker ?? "", companyName: placeHolder.name ?? "", intrinioApi: IntrinioAPI(), analyticsLogger: AnalyticsLogger())
        
        navigationController?.pushViewController(stockDetailsVC, animated: true)
    }
    
}





