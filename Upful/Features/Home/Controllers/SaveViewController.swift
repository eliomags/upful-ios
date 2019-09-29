//
//  SaveViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedItem {
    var savedScreener: SavedScreener
    var savedParameters: [SavedScreenerParameter]
    
    init(savedScreener: SavedScreener, savedParameters: [SavedScreenerParameter]) {
        self.savedScreener = savedScreener
        self.savedParameters = savedParameters
    }
    
    func configureDescription() -> String {
        var str = ""
        for param in savedParameters {
            var description = ""
            description.append(SearchCriteria(rawValue: param.criteria)!.explicit + " ")
            description.append(SearchParameter(rawValue: param.parameter)!.explicit + " ")
            switch SearchCriteria(rawValue: param.criteria)!.parameterType {
            case .percentage:
                description.append("\(param.value.convertToPercent())%\n")
            case .number:
                description.append("$\(Int(param.value).formatUsingAbbreviation())\n")
            case .ratio:
                description.append("\(param.value.twoDecimal())\n")
            default: break
            }
            str.append(description)
        }
        return str
    }
    
    func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        savedParameters.forEach { (savedParam) in
            let criteria = SearchCriteria(rawValue: savedParam.criteria)!.rawValue
            let parameter = SearchParameter(rawValue: savedParam.parameter)!.rawValue
            urlComponents.append(criteria + "\(parameter)~\(savedParam.value)")
        }
        return urlComponents
    }
}

final class SaveViewController: UITableViewController, SaveScreenerDelegate, NoteVCDelegate {
    
    // MARK: - Dependencies
    
    let persistenceService = PersistenceService.shared
    
    enum ReuseID {
        static let savedScreenCell = "savedScreenCell"
        static let savedCompanyCell = "savedCompanyCell"
    }
    
    
    // MARK: - State
    
    var isSavedScreenersEmpty: Bool {
        return savedItems.isEmpty
    }
    
    var isSavedStocksEmpty: Bool {
        return savedStocks.isEmpty
    }
    
    fileprivate func observeState() {
//        tableView.isScrollEnabled = !(isSavedScreenersEmpty && isSavedStocksEmpty)
        saveScreenerCollectionViewController.collectionView.reloadData()
        tableView.reloadData()
    }
    
    
    // MARK: - Display Data
    
    var savedItems: [SavedItem] = [] {
        didSet {
            observeState()
        }
    }
    var savedStocks: [SavedStock] = [] {
        didSet {
            observeState()
        }
    }

    var displayData: [[Any]] {
        return [
            [saveScreenerCollectionViewController],
            savedStocks
        ]
    }
    
    
    // MARK: - Views
    
    lazy var saveScreenerCollectionViewController: SavedScreenersCollectionViewController = {
        let controller = SavedScreenersCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.dataSource = self
        return controller
    }()
    
    
    // MARK: - Initializer Methods

    override func viewDidLoad() {
        super.viewDidLoad()
       setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        loadSavedStocks()
        configureSavedItemsToDisplay()
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.savedScreenCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.savedCompanyCell)
        configureNavBar()
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = ""
        let save = UIBarButtonItem(title: "Notes", style: .done, target: self, action: #selector(handleNotesTap))
        navigationItem.rightBarButtonItems = [save]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc private func handleNotesTap(_ sender: Any) {
        let notesVC = NotesViewController(delegate: self)
        let navVC = UINavigationController(rootViewController: notesVC)
        present(navVC, animated: true, completion: nil)
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
            self.savedItems = items
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
    }
    
    
    // MARK: - Delegate Methods
    
    func editScreener(indexPath: IndexPath) {
        var manualScreenItems = [ManualScreenItem]()
        
        /// Create [ManualScreenItems] to pass to the ManualSearchVC to configure the items
        savedItems[indexPath.item].savedParameters.forEach { (param) in
            let criteria = SearchCriteria(rawValue: param.criteria)
            let parameter = SearchParameter(rawValue: param.parameter)
            let manualScreenItem = ManualScreenItem(criteria: criteria!, parameter: parameter!, value: param.value)
            manualScreenItems.append(manualScreenItem)
        }
        let manualSearchVC = ManualSearchViewController(manualScreenItems: manualScreenItems, analyticsLogger: AnalyticsLogger())
        manualSearchVC.screenerTitleText = savedItems[indexPath.item].savedScreener.title
        navigationController?.pushViewController(manualSearchVC, animated: true)
    }
    
    func deleteScreener(indexPath: IndexPath) {
        removeFavoriteScreener(savedItems[indexPath.item].savedScreener.title)
        savedItems.remove(at: indexPath.item)
    }
    
    func displaySuccessNote() {
        ViewPresenter.displaySuccessActionView(in: self)
    }
    
    
    // MARK: - Navigation
    
    fileprivate func navigateToAddScreener() {
        let searchCriteriaVC = SearchCriteriaTableViewController(style: .grouped)
        navigationController?.pushViewController(searchCriteriaVC, animated: true)
    }
    
    fileprivate func navigateToAddStock() {
        let searchResultsVC = ScreenResultsViewController(searchParameters: [], networkingAPI: IntrinioAPI())
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    
    // MARK: - Fileprivate Functions
    
    private func display(contentController content: UIViewController, on view: UIView) {
        self.addChild(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if isSavedStocksEmpty { return 1 }
            return savedStocks.count
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if isSavedScreenersEmpty {
                let emptyCell = EmptyScreenerFavoriteCell(style: .default, reuseIdentifier: nil)
                    emptyCell.cellAction = { [weak self] in
                        self?.navigateToAddScreener()
                }
                return emptyCell
            }
            let savedScreenerCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.savedScreenCell, for: indexPath)
            display(contentController: saveScreenerCollectionViewController, on: savedScreenerCell)
            return savedScreenerCell
        case 1:
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
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 { return [] }
        if indexPath.section == 1 {
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
        if indexPath.section == 1 {
            if !isSavedStocksEmpty {
                let detailsVC = StockDetailsContainerView(
                ticker: savedStocks[indexPath.item].ticker,
                companyName: savedStocks[indexPath.item].companyName)
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if isSavedScreenersEmpty || savedItems.count == 1 { return tableView.frame.height/2 - 50 }
            if !isSavedScreenersEmpty && savedItems.count > 1 { return tableView.frame.height/2 - 10 }
            return UITableView.automaticDimension
        case 1:
            if isSavedStocksEmpty { return tableView.frame.height/2 - 50 }
            if !isSavedStocksEmpty { return UITableView.automaticDimension }
            return UITableView.automaticDimension
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = ["Screeners","stocks"]
        switch section {
        case 0:
            let screenerHeader = ActionableTableHeader()
            screenerHeader.headerTextLabel.text = headerText[section].uppercased()
            screenerHeader.showButton(isSavedScreenersEmpty)
            screenerHeader.buttonAction = { [weak self] in
                self?.navigateToAddScreener()
            }
            return screenerHeader
        case 1:
            let stockHeader = ActionableTableHeader()
            stockHeader.headerTextLabel.text = headerText[section].uppercased()
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
        if section == displayData.count - 1 { return 30 }
        return 12
    }
}



