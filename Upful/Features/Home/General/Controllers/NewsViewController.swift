//
//  NewsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    fileprivate lazy var logicController: NewsLogicController = {
        let lc = NewsLogicController()
        return lc
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setupNavBar()
        setupTableViewCells()
        observeUpdates()
        logicController.startNewsLoad()
    }

    // MARK: -
    
    fileprivate func observeUpdates() {
        logicController.sendUpdates = { [weak self] in
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
        let isEmptyViewModel = logicController.stockNews.isEmpty
        return isEmptyViewModel ? 5: logicController.stockNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? SmallNewsCell else { return UITableViewCell() }
        if !logicController.stockNews.isEmpty {
            let stockNewsViewModel = logicController.stockNews[indexPath.row]
            newsCell.stockNews = stockNewsViewModel
        }
        return newsCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNewsURLString = logicController.stockNews[indexPath.row].newsUrl
        let webVC = WebViewViewController(urlString: selectedNewsURLString)
        let navVC = UINavigationController(rootViewController: webVC)
        present(navVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

