//
//  HomeGeneralViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class HomeGeneralViewController: UIViewController, MenuBarDisplayable, PreferenceDelegate {
        
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var menubarTitle: String = "General"
    
    private enum Section: Int {
        case preference = 0
        case news = 1
    }
    
    lazy var logicController: HomeGeneralLogicController = {
        let vm = HomeGeneralLogicController()
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
        observeViewModelNewsUpdates()
        observeViewModelPreferenceUpdates()
        logicController.fetchTableData()
    }
    
    // MARK: - View Model Binding

    fileprivate func observeViewModelPreferenceUpdates() {
        logicController.sendPreferenceStateUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loaded, .new:
                self.tableView.reloadSections([Section.preference.rawValue], with: .automatic)
                self.refreshControl.endRefreshing()
            default:
                break
            }
        }
    }
    
    fileprivate func observeViewModelNewsUpdates() {
        logicController.sendNewsStateUpdates = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections([Section.news.rawValue], with: .automatic)
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewCells() {
        tableView.register(NewsHeaderTableCell.self, forCellReuseIdentifier: "newsHeaderCell")
        tableView.register(SmallNewsCell.self, forCellReuseIdentifier: "newsCell")
        tableView.register(CompanyPreviewTableViewCell.self, forCellReuseIdentifier: "resultsCellID")
        tableView.register(NoPreferenceTableViewCell.self, forCellReuseIdentifier: "noPreferenceCellID")
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing(_ sender: Any) {
        refreshControl.endRefreshing()
        logicController.fetchTableData()
    }
    
    fileprivate func handleStockSuggestionCellSelection(for indexPath: IndexPath) {
        switch logicController.preferenceState{
        case .new:
            let presenter = PreferencePresenter(presentingViewController: self)
            presenter.present()
        case .loaded:
            let ticker = logicController.stocksYouMayLike[indexPath.row].ticker
            let name = logicController.stocksYouMayLike[indexPath.row].name
            let detailsVC = StockDetailsContainerView(ticker: ticker, companyName: name)
            RemoteStockManager.update(ticker, name: name)
            navigationController?.pushViewController(detailsVC, animated: true)
        default:
            break
        }
    }
    
    fileprivate func handleNewsCellSelection(for indexPath: IndexPath) {
        if !logicController.stockNews.isEmpty {
            let newsURLString = logicController.stockNews[indexPath.row].newsUrl
            let newsWebVC = WebViewViewController(urlString: newsURLString)
            let navVC = UINavigationController(rootViewController: newsWebVC)
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func handleSeeMoreNews() {
        let newsVC = NewsViewController()
        navigationController?.pushViewController(newsVC, animated: true)
    }
    
    fileprivate func handleSeeMoreSuggestedStocks() {
        let randomSavedSearchParameters = logicController.getRandomPreferenceGroup()
        let resultsVC = ScreenResultsViewController(searchParameters: randomSavedSearchParameters)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    // MARK: - Preference Delegate Methods
    
    func didCancelSaving() {}
    
    func didCompleteSaving() {
        logicController.startPreferenceLoad()
    }
    
    // MARK: - TableView Cells
    
    fileprivate func makeNoPreferenceSetCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let noPreferenceSetCell = tableView.dequeueReusableCell(withIdentifier: "noPreferenceCellID") as? NoPreferenceTableViewCell else { return UITableViewCell() }
        return noPreferenceSetCell
    }
    
    fileprivate func makeStockCells(_ indexPath: IndexPath) -> UITableViewCell {
        guard let loadedCell = tableView.dequeueReusableCell(withIdentifier: "resultsCellID") as? CompanyPreviewTableViewCell else { return UITableViewCell() }
        loadedCell.accessoryType = .disclosureIndicator
        loadedCell.backgroundColor = VersionManager.mainContainerBackground()

        if logicController.preferenceState == .loaded {
            let stock = logicController.stocksYouMayLike[indexPath.item]
            loadedCell.companyTickerLabel.text = stock.ticker
            loadedCell.companyNameLabel.text = stock.name
            loadedCell.marketcapStackView.valueLabel.text = "$\(stock.marketcap?.formatUsingAbbreviation() ?? " -")"
            loadedCell.pricetoearningsStackView.valueLabel.text = "\(stock.pricetoearnings?.twoDecimal() ?? "-")"
        }
        return loadedCell
    }
    
    fileprivate func makeNewsCells(_ indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            let newsHeaderCell = tableView.dequeueReusableCell(withIdentifier: "newsHeaderCell", for: indexPath) as! NewsHeaderTableCell
            if !logicController.stockNews.isEmpty {
                newsHeaderCell.stockNews = logicController.stockNews[indexPath.row]
            }
            return newsHeaderCell
        case 1,2:
            let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! SmallNewsCell
            if !logicController.stockNews.isEmpty {
                newsCell.stockNews = logicController.stockNews[indexPath.row]
            }
            return newsCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate/Datasource Methods

extension HomeGeneralViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.preference.rawValue:
            let isLoadedState = logicController.preferenceState == .loaded
            let isNewState = logicController.preferenceState == .new
            if isNewState { return 1 }
            if isLoadedState { return logicController.stocksYouMayLike.count }
            else { return 0 }
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
        case Section.preference.rawValue:
            if logicController.preferenceState == .loaded { return makeStockCells(indexPath) }
            if logicController.preferenceState == .new { return makeNoPreferenceSetCell(indexPath) }
        default: return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.preference.rawValue:
            let preferenceHeader = TableSectionHeaderView()
            preferenceHeader.headerTextLabel.text = "Stocks You May Like"
            preferenceHeader.buttonAction = { [weak self] in self?.handleSeeMoreSuggestedStocks() }
            return preferenceHeader
        case Section.news.rawValue:
            let newsHeader = TableSectionHeaderView()
            newsHeader.headerTextLabel.text = "Recent News"
            newsHeader.buttonAction = { [weak self] in self?.handleSeeMoreNews() }
            return newsHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case Section.preference.rawValue:
            return 15
        case Section.news.rawValue:
            return 140
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        switch section {
        case Section.preference.rawValue:
            switch logicController.preferenceState {
            case .new:
                return true
            case .loading:
                return false
            case .loaded:
                return true
            case .error:
                return false
            }
        case Section.news.rawValue:
            return !logicController.stockNews.isEmpty
        default:
            return false
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case Section.preference.rawValue:
            handleStockSuggestionCellSelection(for: indexPath)
        case Section.news.rawValue:
            handleNewsCellSelection(for: indexPath)
        default: break
        }
    }
}

