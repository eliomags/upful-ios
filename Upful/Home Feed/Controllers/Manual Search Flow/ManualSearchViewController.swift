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
}

class ManualSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManualSearchDelegate {
    
    // MARK: - Dependencies
    
    let analyticsLogger: AnalyticsLogger
    
    var manualScreenItems: [ManualScreenItem] {
        didSet {
            if manualScreenItems.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    weak var delegate: SearchCriteriaDelegate?

    
    // MARK:- Views
    
    lazy var header: ManualSearchHeaderView = {
        let v = ManualSearchHeaderView()
        return v
    }()
    
    
    lazy var searchButton: CustomButton = {
        let b = CustomButton(type: .system)
        b.setTitle("SEARCH", for: .normal)
        b.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return b
    }()
    
    lazy var manualSearchSearchTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .backgroundColor
        tv.separatorStyle = .none
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
    
    init(manualScreenItems: [ManualScreenItem], analyticsLogger: AnalyticsLogger) {
        self.manualScreenItems = manualScreenItems
        self.analyticsLogger = analyticsLogger
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.backgroundColor = .backgroundColor
        view.addSubview(manualSearchSearchTableView)
        manualSearchSearchTableView.fillSuperview()
        view.addSubview(searchButton)
        searchButton.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor,
                            padding: .init(top: 0, left: 16, bottom: 50, right: 16))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - View Set up
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Upful"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Actions
    
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
        analyticsLogger.reportEvents(event: .screenForStocks(screenType: .manual))
        
        let screenerResultsVC = ScreenResultsViewController(searchParameters: configureURLComponents(), networkingAPI: IntrinioAPI())
        navigationController?.pushViewController(screenerResultsVC, animated: true)
    }
    
    fileprivate func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        manualScreenItems.forEach { (manualScreenerItem) in
            urlComponents.append(manualScreenerItem.criteria.rawValue + "\(manualScreenerItem.parameter.rawValue)~\(manualScreenerItem.value ?? 0)")
        }
        return urlComponents
    }
    
    fileprivate func presentAlert() {
        let alert = UIAlertController(title: "Search Failed", message: "Please add a search parameter to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK:- Delegate Methods
    
    func addSearchCriteria(criteria: ManualScreenItem) {
        manualScreenItems.append(criteria)
    }
    
    func addSearchParameter(parameterItem: ParameterItem, indexPath: IndexPath) {
        manualScreenItems[indexPath.item].parameter = parameterItem.parameter
        manualScreenItems[indexPath.item].value = parameterItem.value
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
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return footer
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        } else {
            return 0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








