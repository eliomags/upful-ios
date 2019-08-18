//
//  ManualSearchResultsTableViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol ManualSearchDelegate: class {
    func addSearchCriteria(criteria: ManualScreener)
    func addSearchParameter(parameterItem: ParameterItem, indexPath: IndexPath)
}

class SearchCriteriaTableViewController: UITableViewController {
    
    weak var delegate: ManualSearchDelegate?
    
    var manualSearchCriteriaItems: [[ManualScreener]] = []
    
    
    // MARK:- Initializer Methods
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        initializeDisplayData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureNavBar()
    }
    
    
    // MARK:- Data Setup
    
    fileprivate func initializeDisplayData() {
        var valuation: [ManualScreener] = []
        var financial: [ManualScreener] = []
        var performance: [ManualScreener] = []
        
        SearchCriteria.allCases.forEach { (criteria) in
            switch criteria.classification {
            case .valuation:
                valuation.append(ManualScreener(criteria: criteria, parameter: .none, value: nil))
            case .financial:
                financial.append(ManualScreener(criteria: criteria, parameter: .none, value: nil))
            case .performance:
                performance.append(ManualScreener(criteria: criteria, parameter: .none, value: nil))
            case .other:
                break
            }
        }
        manualSearchCriteriaItems.append(valuation)
        manualSearchCriteriaItems.append(financial)
        manualSearchCriteriaItems.append(performance)
    }
    
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Select Criteria"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return manualSearchCriteriaItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualSearchCriteriaItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = manualSearchCriteriaItems[indexPath.section][indexPath.row].criteria.explicit
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.addSearchCriteria(criteria: manualSearchCriteriaItems[indexPath.section][indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

