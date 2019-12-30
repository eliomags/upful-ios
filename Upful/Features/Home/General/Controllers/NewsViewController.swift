//
//  NewsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    fileprivate lazy var viewModel: NewsViewModel = {
        let vm = NewsViewModel()
        return vm
    }()
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableViewCells()
        observeUpdates()
        viewModel.startNewsLoad()
    }
    

    // MARK: -
    
    fileprivate func observeUpdates() {
        viewModel.sendUpdates = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationItem.title = "News"
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: "newsCell")
    }
    
    
    // MARK: - TableView Delegate/Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isEmptyViewModel = viewModel.stockNews.isEmpty
        return isEmptyViewModel ? 5: viewModel.stockNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? SmallNewsCell else { return UITableViewCell() }
        
        if !viewModel.stockNews.isEmpty {
            let stockNewsViewModel = viewModel.stockNews[indexPath.row]
            newsCell.stockNews = stockNewsViewModel
        }
        
        return newsCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected", indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

