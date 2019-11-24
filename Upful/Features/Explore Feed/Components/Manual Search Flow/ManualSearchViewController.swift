//
//  ManualSearchViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SearchCriteriaDelegate: class {
    func remove(indexPath: IndexPath)
    func updateScreenerItems(with updatedItems: [ManualScreenItem])
}

class ManualSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManualSearchDelegate {
    
    // MARK: - Dependencies
        
    var manualScreenItems: [ManualScreenItem] {
        didSet {
            if manualScreenItems.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    weak var delegate: SearchCriteriaDelegate?

    // MARK:- Views
    
    lazy var header: TableHeaderView = {
        let v = TableHeaderView()
        v.headerLabel.text = "Add your parameters."
        v.detailsLabel.text = " "
        return v
    }()
    
    lazy var searchButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("SEARCH", for: .normal)
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        b.backgroundColor = .appAccent3
        b.layer.cornerRadius = 8
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return b
    }()
    
    lazy var manualSearchSearchTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = VersionManager.mainContainerBackground()
        tv.separatorStyle = .singleLine
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var footer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.addSubview(searchButton)
        searchButton.anchor(top: nil, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 0, left: 16, bottom: 50, right: 16))
        return v
    }()
    
    
    // MARK:- Initializer Methods
    
    init(manualScreenItems: [ManualScreenItem]) {
        self.manualScreenItems = manualScreenItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.backgroundColor = VersionManager.mainContainerBackground()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.manualSearchSearchTableView.shouldUpdateHeaderViewFrame() {
            self.manualSearchSearchTableView.beginUpdates()
            self.manualSearchSearchTableView.endUpdates()
        }
    }
    
    // MARK: - View Functions
    
    fileprivate func setupViews() {
        view.addSubview(searchButton)
        searchButton.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 16, right: 16),
            size: .init(width: 0, height: 40))
        
        view.addSubview(manualSearchSearchTableView)
        manualSearchSearchTableView.anchor(top: view.layoutMarginsGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: searchButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = ""
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearCriteriaTapped))
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveTap))
        navigationItem.rightBarButtonItems = [save,clearButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Actions
    
    fileprivate func presentAlert() {
        let alert = UIAlertController(title: "Search Failed", message: "Please add a search parameter to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Saved Successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        manualScreenItems.forEach { (manualScreenerItem) in
            urlComponents.append(manualScreenerItem.criteria.rawValue + "\(manualScreenerItem.parameter.rawValue)~\(manualScreenerItem.value ?? 0)")
        }
        return urlComponents
    }
    
    @objc fileprivate func handleSearch(_ sender: UIButton) {
        if manualScreenItems.isEmpty {
            presentAlert()
            return
        }
        for item in manualScreenItems {
            if item.parameter == .none {
                presentAlert()
                return
            }
        }
        AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .manual))
        let screenerResultsVC = ScreenResultsViewController(searchParameters: configureURLComponents(), networkingAPI: IntrinioAPI())
        navigationController?.pushViewController(screenerResultsVC, animated: true)
    }
    
    @objc fileprivate func clearCriteriaTapped(_ sender: UIBarButtonItem) {
        for _ in 0..<manualScreenItems.count {
            guard manualScreenItems.count > 0 else { return }
            delegate?.remove(indexPath: IndexPath(row: 0, section: 0))
        }
        delegate?.updateScreenerItems(with: [])
        manualScreenItems.removeAll()
    }
    
    private func checkCurrentParameters(completion: (()->())) {
        var isSuitable = true
        manualScreenItems.forEach { (manualScreenItem) in
            if manualScreenItem.parameter.rawValue == SearchParameter.none.rawValue {
                isSuitable = false
            }
        }
        if !isSuitable {
            InformationViewPresenter.displayErrorActionView(in: self, message: "Please add search parameters to your screen before saving.")
            return
        }
        if isSuitable { completion() }
    }
    
    
    // MARK: - Core Data Functionality
    
    var screenerTitleText: String = "No Title"
    
    private func updateScreenerParameters(title: String, completion: (()->Void)) {
        
        /// Remove all screener Parameters with the title
        
        let request = SavedScreenerParameter.createfetchRequest()
        let context = PersistenceService.shared.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "savedScreener.title == %@", title)
        do {
            let parameters = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            for parameter in parameters {
                context.delete(parameter)
            }
            PersistenceService.shared.saveContext()
        } catch {
            print(error.localizedDescription)
            return
        }
        
        /// Remove currently saved screener with the title
        
        let savedScreenerRequest = SavedScreener.createfetchRequest()
        savedScreenerRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            let objects = try context.fetch(savedScreenerRequest)
            for object in objects {
                context.delete(object)
            }
            PersistenceService.shared.saveContext()
        } catch {
            print(error.localizedDescription)
            return
        }
        completion()
    }
    
    private func saveParameters(with destination: SavedScreener) {
        manualScreenItems.forEach { (screenerItem) in
            let screenerParameter = SavedScreenerParameter(context: PersistenceService.shared.persistentContainer.viewContext)
            screenerParameter.value = screenerItem.value ?? 0
            screenerParameter.parameter = screenerItem.parameter.rawValue
            screenerParameter.criteria = screenerItem.criteria.rawValue
            screenerParameter.savedScreener = destination
            PersistenceService.shared.saveContext()
        }
    }
    
    fileprivate func handleSaveCompletion(_ titleTextFieldText: String?) {
        self.updateScreenerParameters(title: titleTextFieldText ?? "No Title", completion: {
            let savedScreener = SavedScreener(context: PersistenceService.shared.persistentContainer.viewContext)
            savedScreener.title = titleTextFieldText ?? "No Title"
            savedScreener.screenDescription = ""
            self.saveParameters(with: savedScreener)
            AnalyticsLogger.instance.reportEvents(event: .savedScreener(description: configureURLComponents().joined(separator: ",")))
            PersistenceService.shared.saveContextWithCompletion(completion: { [unowned self] in
                InformationViewPresenter.showSaveSuccess(in: self)
            })
        })
    }
    
    fileprivate func saveScreener() {
        self.checkCurrentParameters { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Add to Favorites", message: "Give your screener a name.", preferredStyle: .alert)
            alert.addTextField { (titleTextField) in
                titleTextField.text = self.screenerTitleText
                titleTextField.placeholder = "Title"
            }
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                var titleTextFieldText = alert?.textFields![0].text
                if titleTextFieldText == "" { titleTextFieldText = "No Title" }
                self.handleSaveCompletion(titleTextFieldText)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Action
    
    @objc private func handleSaveTap(_ sender: UIBarButtonItem) {
        PermissionManager.shared.getSaveScreenerPermission { [unowned self] (permissionGranted, error) in
            if let _ = error {
                let alertVC = UIAlertController(title: "Error", message: "There was an error.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertVC, animated: true)
            }
            
            if !permissionGranted {
                let presenter = SubscriptionPresenter()
                presenter.present(in: self)
            }
            
            if permissionGranted {
                self.saveScreener()
            }
        }
    }
    

    // MARK:- Delegate Methods
    
    func addSearchCriteria(criteria: ManualScreenItem) {
        manualScreenItems.append(criteria)
    }
    
    func addSearchParameter(parameterItem: ParameterItem, indexPath: IndexPath) {
        manualScreenItems[indexPath.item].parameter = parameterItem.parameter
        manualScreenItems[indexPath.item].value = parameterItem.value
        delegate?.updateScreenerItems(with: manualScreenItems)
        manualSearchSearchTableView.reloadData()
    }
    
    
    // MARK:- Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualScreenItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        let parameter = manualScreenItems[indexPath.item].parameter
        let criteria = manualScreenItems[indexPath.item].criteria
        let value = manualScreenItems[indexPath.item].value
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = criteria.explicit
        cell.textLabel?.font = .details1
        cell.detailTextLabel?.font = .details2
        if parameter != .none {
            if criteria.parameterType == .percentage {
                cell.detailTextLabel?.text = parameter.explicit + " " + "\(value!.convertToPercent())%"
            }
            if manualScreenItems[indexPath.item].criteria.parameterType == .ratio {
                cell.detailTextLabel?.text = parameter.explicit + " " + String(Int(value ?? 0))
            }
            if manualScreenItems[indexPath.item].criteria.parameterType == .number {
                cell.detailTextLabel?.text = parameter.explicit + " $" + Int(value ?? 0).formatUsingAbbreviation()
            }
        } else {
            cell.detailTextLabel?.text = parameter.explicit
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchParamsVC = ManualSearchParametersTableViewController(selectedIndexPath: indexPath, screenerItem: manualScreenItems[indexPath.item])
        searchParamsVC.delegate = self
        
        self.navigationController?.pushViewController(searchParamsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            self.manualScreenItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.manualSearchSearchTableView.reloadData()
            self.delegate?.remove(indexPath: indexPath)
        }
        delete.backgroundColor = .negative
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220
        } else {
            return 0
        }
    }
}

extension ManualSearchViewController: PresentationControllerDelegate {
    func presentationControllerdDidDismiss() {}
}







