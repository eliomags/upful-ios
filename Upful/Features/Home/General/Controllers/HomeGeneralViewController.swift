//
//  HomeGeneralViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class HomeGeneralViewController: UIViewController, MenuBarDisplayable {
    
    weak var delegate: MenuViewItemDelegate?
    var menubarTitle: String = "General"
    
    private enum Section: Int {
        case news = 1
        case preference = 0
    }
    
    lazy var viewModel: HomeGeneralViewModel = {
        let vm = HomeGeneralViewModel()
        return vm
    }()
    
    // MARK: - Views
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleResfreshing), for: .valueChanged)
        return control
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.refreshControl = refreshControl
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupTableViewCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUpdates()
        viewModel.startPreferenceLoad()
        viewModel.startNewsLoad()
    }
    
    
    // MARK: - View Model Binding
    
    fileprivate func observeUpdates() {
        viewModel.sendUpdates = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.tableHeaderView = UIView()
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(NewsHeaderTableCell.self, forCellReuseIdentifier: "newsHeaderCell")
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: "newsCell")
    }
    
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing(_ sender: Any) {
        refreshControl.endRefreshing()
        viewModel.startNewsLoad()
    }
    
    
    // MARK: - Navigation
    
    fileprivate func handleSeeMoreNews() {
        let newsVC = NewsViewController()
        navigationController?.pushViewController(newsVC, animated: true)
    }
    
    
    // MARK: - TableView Cells
    
    fileprivate func makeNewsCells(_ indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            let newsHeaderCell = tableView.dequeueReusableCell(withIdentifier: "newsHeaderCell", for: indexPath) as! NewsHeaderTableCell
            if !viewModel.stockNews.isEmpty {
                newsHeaderCell.stockNews = viewModel.stockNews[indexPath.row]
            }
            return newsHeaderCell
        case 1,2:
            let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! SmallNewsCell
            if !viewModel.stockNews.isEmpty {
                newsCell.stockNews = viewModel.stockNews[indexPath.row]
            }
            return newsCell
        default:
            return UITableViewCell()
        }
    }
}

extension HomeGeneralViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.news.rawValue:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case Section.news.rawValue:
            return makeNewsCells(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.news.rawValue:
            let newsHeader = TableSectionHeaderView()
            newsHeader.headerTextLabel.text = "Recent News"
            newsHeader.buttonAction = { [weak self] in self?.handleSeeMoreNews() }
            return newsHeader
            
        case Section.preference.rawValue:
            let preferenceHeader = TableSectionHeaderView()
            preferenceHeader.headerTextLabel.text = "Stocks You May Like"
            preferenceHeader.buttonAction = { [weak self] in self?.handleSeeMoreNews() }
            return preferenceHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
        UIView.animate(withDuration: 0.3, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        })
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
