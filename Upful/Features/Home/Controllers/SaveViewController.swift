//
//  SaveViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class SaveViewController: UITableViewController, SaveScreenerDelegate, NoteVCDelegate, ActionHeaderDelegate {
    
    // MARK: - Dependencies
    
    let persistenceService = PersistenceService.shared

    enum ReuseID {
        static let suggestionCell = "suggestionCell"
        static let savedScreenCell = "savedScreenCell"
        static let savedCompanyCell = "savedCompanyCell"
        static let screenerHeaderView = "screenerHeaderView"
    }
    
    // MARK: - State
            
    var isSavedScreenersEmpty: Bool {
        return savedScreeners.isEmpty
    }
    
    var isSavedStocksEmpty: Bool {
        return savedStocks.isEmpty
    }
    
    fileprivate func observeScreenerState() {
        saveScreenerCollectionViewController.collectionView.reloadData()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        if isSavedScreenersEmpty { tableView.reloadData() }
    }
    
    private func observeSavedStockState() {
        tableView.reloadData()
    }
    
    // MARK: - Display Data
    
    var savedScreeners: [SavedItem] = [] {
        didSet {
            observeScreenerState()
        }
    }
    var savedStocks: [SavedStock] = [] {
        didSet {
            observeSavedStockState()
        }
    }

    var displayData: [[Any]] {
        return [
            savedStocks,
            [saveScreenerCollectionViewController],
            savedStocks
        ]
    }
    
    // MARK: - Views
    
    lazy var notesButton: NotesButton = {
        let button = NotesButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNotesTap)))
        return button
    }()
    
    lazy var preferenceVC: StockSuggestionViewController = {
        let preferenceVC = StockSuggestionViewController()
        return preferenceVC
    }()
    
    lazy var saveScreenerCollectionViewController: SavedScreenersCollectionViewController = {
        let controller = SavedScreenersCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.dataSource = self
        controller.delegate = self
        return controller
    }()
    
    // MARK: - Initializer Methods
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedStocks()
        configureSavedItemsToDisplay()
        configureNavBar()
    }
    
    // MARK: - View Setup
        
    fileprivate func setUpTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(ActionableTableHeader.self, forHeaderFooterViewReuseIdentifier: ReuseID.screenerHeaderView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.savedScreenCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.savedCompanyCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.suggestionCell)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
    }

    // MARK: - Core Data
    
    /// This method fetches and filters the [SavedScreenerParameters] with the corresponding title attribute
    private func getParameters(named title: String) -> [SavedScreenerParameter] {
        var parameters = [SavedScreenerParameter]()
        let savedParameters = SavedScreenerParameter.createfetchRequest()
        savedParameters.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        do {
            parameters = try PersistenceService.shared.persistentContainer.viewContext.fetch(savedParameters)
        } catch {
            print(error.localizedDescription)
        }
        return parameters
    }
    
    private func configureSavedItemsToDisplay() {
        let request = SavedScreener.createfetchRequest()
        var screeners: [SavedScreener] = []
        var items: [SavedItem] = []
        do {
            screeners = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            screeners.forEach { (screener) in
                let savedItem = SavedItem(savedScreener: screener, savedParameters: getParameters(named: screener.title))
                items.append(savedItem)
            }
            self.savedScreeners = items
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadSavedStocks() {
        let request = SavedStock.createfetchRequest()
        do {
            savedStocks = try persistenceService.persistentContainer.viewContext.fetch(request)
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } catch {
            print("Fetch failed", error.localizedDescription)
        }
    }
    
    private func removeFavoriteCompany(_ ticker: String) {
        let fetchRequest = SavedStock.createfetchRequest()
        let context = PersistenceService.shared.persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", ticker)
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeFavoriteScreener(_ title: String) {
        let context = PersistenceService.shared.persistentContainer.viewContext
        
        /// We need to delete all search parameters corresponding to the deleted Screener title
        let paramRequest = SavedScreenerParameter.createfetchRequest()
        paramRequest.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        do {
            let searchParameters = try context.fetch(paramRequest)
            for parameter in searchParameters { context.delete(parameter) }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
        
        let request = SavedScreener.createfetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
            }
            persistenceService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
        Vibration.light.vibrate()
    }
    
    // MARK: - Custom Delegate Methods
    
    func editScreener(indexPath: IndexPath) {
        var manualScreenItems = [ManualScreenItem]()
        /// Create [ManualScreenItems] to pass to the ManualSearchVC to configure the items
        savedScreeners[indexPath.item].savedParameters.forEach { (param) in
            let criteria = SearchCriteria(rawValue: param.criteria)
            let parameter = SearchParameter(rawValue: param.parameter)
            let manualScreenItem = ManualScreenItem(criteria: criteria!, parameter: parameter!, value: param.value)
            manualScreenItems.append(manualScreenItem)
        }
        let manualSearchVC = ManualSearchViewController(manualScreenItems: manualScreenItems)
        manualSearchVC.screenerTitleText = savedScreeners[indexPath.item].savedScreener.title
        navigationController?.pushViewController(manualSearchVC, animated: true)
    }
    
    func deleteScreener(indexPath: IndexPath) {
        removeFavoriteScreener(savedScreeners[indexPath.item].savedScreener.title)
        savedScreeners.remove(at: indexPath.item)
    }
    
    func displaySuccessNote() {
        InformationViewPresenter.showSaveSuccess(in: self)
    }
    
    func observeSavedScreenerState(isEditing: Bool) {
        let header = tableView.headerView(forSection: displayData.firstIndex(where: { (savedScreener) -> Bool in
            return  [self.saveScreenerCollectionViewController] == savedScreener as? [SavedScreenersCollectionViewController]
        })!) as? ActionableTableHeader
        header?.animateButton(isStateChanged: isEditing)
    }
    
    // MARK: - Navigation
    
    fileprivate func navigateToAddScreener() {
        let searchCriteriaVC = CreateScreenerTableViewController()
        navigationController?.pushViewController(searchCriteriaVC, animated: true)
    }
    
    fileprivate func navigateToAddStock() {
        let searchResultsVC = ScreenResultsViewController(searchParameters: [], networkingAPI: IntrinioAPI())
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    @objc private func handleNotesTap(_ sender: Any) {
        let presenter = NotesPresenter()
        presenter.present(in: self)
    }
    
    // MARK: - TableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            if isSavedStocksEmpty { return 1 }
            return savedStocks.count
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.suggestionCell, for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            display(contentController: preferenceVC, on: cell)
            return cell
            
        case 1:
            if isSavedScreenersEmpty {
                let emptyCell = EmptyScreenerFavoriteCell(style: .default, reuseIdentifier: nil)
                    emptyCell.cellAction = { [weak self] in
                        self?.navigateToAddScreener()
                }
                return emptyCell
            }
            let savedScreenerCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.savedScreenCell, for: indexPath)
            savedScreenerCell.backgroundColor = .clear
            display(contentController: saveScreenerCollectionViewController, on: savedScreenerCell)
            return savedScreenerCell
            
        case 2:
            if isSavedStocksEmpty {
                let emptyCell = EmptyStockFavoriteCell(style: .default, reuseIdentifier: nil)
                emptyCell.cellAction = { [weak self] in
                    self?.navigateToAddStock()
                }
                return emptyCell
            }
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: ReuseID.savedCompanyCell)
            cell.textLabel?.text = savedStocks[indexPath.item].ticker
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            cell.detailTextLabel?.text = savedStocks[indexPath.item].companyName
            cell.detailTextLabel?.textColor = .gray
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
            cell.addSeparator()
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 || indexPath.section == 1 { return [] }
        if indexPath.section == 2 {
            if !isSavedStocksEmpty {
                guard let savedStock = displayData[indexPath.section][indexPath.row] as? SavedStock else { return nil }
                let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                    self.removeFavoriteCompany(savedStock.ticker)
                    self.savedStocks.remove(at: indexPath.item)
                }
                return [delete]
            } else {
                return []
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if !isSavedStocksEmpty {
                let detailsVC = StockDetailsContainerView(
                ticker: savedStocks[indexPath.item].ticker,
                companyName: savedStocks[indexPath.item].companyName)
                AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .savedStock))
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            
        case 0:
            if self.preferenceVC.viewModel.state == .noPreferencesSet {
                return (tableView.frame.height / 5) - 30
            } else {
                return 200
            }
        case 1:
            let height: CGFloat = 340
            if isSavedScreenersEmpty { return (tableView.frame.height / 3) + 20 }
            if savedScreeners.count == 1 { return (height / 3) + 20 }
            if savedScreeners.count == 2 { return (height / 2) + 50 }
            if savedScreeners.count >= 3 { return height }
            return UITableView.automaticDimension
            
        case 2:
            if isSavedStocksEmpty { return tableView.frame.height/2 - 50 }
            if !isSavedStocksEmpty { return UITableView.automaticDimension }
            return UITableView.automaticDimension
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 80 }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = [
            "Stocks You May Like",
            "Saved Screeners",
            "Saved Stocks"
        ]
        switch section {
            
        case 0 :
            let header = LargeSectionHeaderLabel(padding: 16)
            header.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            header.text = headerText[section]
            return header
            
        case 1:
            let screenerHeader = ActionableTableHeader(reuseIdentifier: ReuseID.screenerHeaderView)
            screenerHeader.headerTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            screenerHeader.headerTextLabel.text = headerText[section]
            screenerHeader.showButton(isSavedScreenersEmpty)
            screenerHeader.editButtonAction = { [weak self] in
                self?.saveScreenerCollectionViewController.isLongPressEnabled = false
            }
            screenerHeader.buttonAction = { [weak self] in
                self?.navigateToAddScreener()
            }
            return screenerHeader
            
        case 2:
            let stockHeader = ActionableTableHeader()
            stockHeader.headerTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            stockHeader.headerTextLabel.text = headerText[section]
            stockHeader.showButton(isSavedStocksEmpty)
            stockHeader.buttonAction = { [weak self] in
                self?.navigateToAddStock()
            }
            return stockHeader
        default: return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

