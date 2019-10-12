//
//  ManualSearchParametersTableViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol ManualSearchDelegate: class {
    func addSearchParameter(parameterItem: ParameterItem, indexPath: IndexPath)
}

class ManualSearchParametersTableViewController: UITableViewController {
    
    // MARK:- Dependencies
    
    let criteria: String
    let screenerItem: ManualScreenItem
    let selectedIndexPath: IndexPath
    
    var manualSearchParameterItems: [ParameterItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ManualSearchDelegate?
    

    // MARK:- Initializer Methods
    
    init(selectedIndexPath: IndexPath, screenerItem: ManualScreenItem) {
        self.screenerItem = screenerItem
        self.criteria = screenerItem.criteria.explicit
        self.selectedIndexPath = selectedIndexPath
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        initializeData()
        configureNavBar()
    }
    
    
    // MARK:- Data Initialization
    
    fileprivate func configureRatioData() {
        [3.0, 5, 10, 15, 20, 25, 30, 40, 50, 60, 80, 100].forEach { (value) in
            SearchParameter.allCases.forEach { (param) in
                if param != .none && param != .equal {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            }
        }
    }
    
    fileprivate func configurePercentageData() {
        [0.0, 0.01, 0.03, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.60, 0.80].forEach { (value) in
            SearchParameter.allCases.forEach { (param) in
                if param != .none && param != .equal  {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            }
        }
    }
    
    fileprivate func configureMarketCapData() {
        [50_000_000_000.0, 10_000_000_000, 3_000_000_000,1_000_000_000, 500_000_000, 100_000_000].forEach { (value) in
            SearchParameter.allCases.forEach({ (param) in
                if param != .none && param != .equal  {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            })
        }
    }
    
    fileprivate func initializeData() {
        manualSearchParameterItems.append(ParameterItem(parameter: .none, value: 0))
        switch screenerItem.criteria.parameterType {
        case .ratio:
            configureRatioData()
        case .percentage:
            configurePercentageData()
        case .number:
            configureMarketCapData()
        case .other:
            break
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationItem.title = criteria
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualSearchParameterItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let displayData = manualSearchParameterItems[indexPath.item]
        cell.textLabel?.font = .details1
        
        if displayData.parameter != .none {
            if screenerItem.criteria.parameterType == .percentage {
                cell.textLabel?.text = displayData.parameter.explicit + " " + "\(displayData.value.convertToPercent())%"
            }
            if screenerItem.criteria.parameterType == .ratio {
                cell.textLabel?.text = displayData.parameter.explicit + " " + String(Int(displayData.value))
            }
            if screenerItem.criteria.parameterType == .number {
                cell.textLabel?.text = displayData.parameter.explicit + " $" + Int(displayData.value).formatUsingAbbreviation()
            }
        } else {
            cell.textLabel?.text = displayData.parameter.explicit
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedParameterItem = manualSearchParameterItems[indexPath.item]
        delegate?.addSearchParameter(parameterItem: selectedParameterItem, indexPath: selectedIndexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







