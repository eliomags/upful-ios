//
//  SavedStocksViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedStocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuBarDisplayable {
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var menubarTitle: String = "Stocks"
    
    lazy var viewModel: SavedStockVCViewModel = {
        let vm = SavedStockVCViewModel()
        return vm
    }()
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeStateChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadSavedStocks()
    }
    
    // MARK: - View Setup
    
    func setupTableView() {
        setupTableViewView()
        setupTableViewConstraints()
        setupTableViewFunctionality()
    }
    
    fileprivate func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: "resultsCellID")
    }
    
    fileprivate func setupTableViewFunctionality() {
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    // MARK: - View Model Observation
    
    func observeStateChanges() {
        viewModel.sendStateUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .new:
                break
            case .loading:
                self.handleLoadingState()
            case .loaded:
                self.handleLoadedState()
            case .empty:
                self.handleEmptyState()
            case .error:
                self.handleErrorState()
            }
        }
    }
    
    // MARK: - TableView Updates
    
    fileprivate func handleLoadingState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    fileprivate func handleLoadedState() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.isScrollEnabled = true
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.reloadData()
    }
    
    fileprivate func handleErrorState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.reloadData()
    }
    
    fileprivate func handleEmptyState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.reloadData()
        if let container = parent as? HomeContainerViewController {
            container.emphasizeButton()
        }
    }
    
    // MARK: - TableViewCell Updates
    
    fileprivate func showEmptyCell(for indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = EmptyStockFavoriteCell(style: .default, reuseIdentifier: nil)
        return emptyCell
    }
    
    fileprivate func showErrorCell(for indexPath: IndexPath) -> UITableViewCell {
        let errorCell = ErrorFavoriteCell(style: .default, reuseIdentifier: nil)
        return errorCell
    }
    
    fileprivate func showLoadedCell(for indexPath: IndexPath) -> UITableViewCell {
        let stockViewModels = viewModel.stockViewModels[indexPath.item]
        guard let loadedCell = tableView.dequeueReusableCell(withIdentifier: "resultsCellID") as? ResultsTableViewCell else { return UITableViewCell() }
        loadedCell.accessoryType = .disclosureIndicator
        loadedCell.backgroundColor = VersionManager.mainContainerBackground()
        loadedCell.companyTickerLabel.text = stockViewModels.stock.ticker
        loadedCell.companyNameLabel.text = stockViewModels.stock.name
        loadedCell.marketcapStackView.valueLabel.text = "$\(stockViewModels.stock.marketcap?.formatUsingAbbreviation() ?? " -")"
        loadedCell.pricetoearningsStackView.valueLabel.text = "\(stockViewModels.stock.pricetoearnings?.twoDecimal() ?? "-")"
        return loadedCell
    }
    
    // MARK: - TableView Delegate/Datasource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isLoaded = viewModel.state == .loaded
        return isLoaded ? viewModel.stockViewModels.count: 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .loaded:
            return showLoadedCell(for: indexPath)
        case .empty:
            return showEmptyCell(for: indexPath)
        case .error:
            return showErrorCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let loaded = viewModel.state == .loaded
        return loaded ? UITableView.automaticDimension: tableView.frame.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isLoaded = viewModel.state == .loaded
        let stockHeader = TableSectionHeaderView()
        stockHeader.headerTextLabel.text = "Saved Stocks"
        stockHeader.addButton.setTitle("", for: .normal)
        return isLoaded ? stockHeader: nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isLoaded = viewModel.state == .loaded
        return isLoaded ? 75: 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if viewModel.state == .loaded {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] ( _, _, _) in
                guard let self = self else { return }
                let stockViewModels = self.viewModel.stockViewModels[indexPath.item]
                self.viewModel.removeTicker(stockViewModels.stock.ticker)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.viewModel.refreshState()
                }
                Vibration.light.vibrate()
            }
            delete.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [delete])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.state == .loaded {
            let detailsVC = StockDetailsContainerView(
                ticker: viewModel.stockViewModels[indexPath.item].stock.ticker,
                companyName: viewModel.stockViewModels[indexPath.item].stock.name)
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .savedStock))
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - TableView Drag/Drop Delegate Methods

extension SavedStocksViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        switch viewModel.state {
        case .loaded:
            let ticker = viewModel.stockViewModels[indexPath.item].stock.ticker
            guard let data = ticker.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "kUTTypePlainText")
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = ticker
            Vibration.selection.vibrate()
            return [dragItem]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        guard let sourceIndexPath = coordinator.items[0].sourceIndexPath else { return }

        viewModel.stockViewModels.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        viewModel.saveDatasourceConfiguration()
        tableView.reloadData()
        coordinator.drop(coordinator.items[0].dragItem, toRowAt: destinationIndexPath)
        Vibration.success.vibrate()
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

