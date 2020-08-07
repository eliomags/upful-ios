//
//  SearchCriteriaSelectionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class SearchCriteriaSelectionViewController: UIViewController {
    
    struct Constants {
        static let criteriaCell = "CriteriaCell"
    }
    
    // MARK: - State
    
    weak var delegate: ChartSearchCriteriaSelectionDelegate?
    
    var currentSearchCriteria: SearchCriteria?
    private(set) var data: [[ManualScreenItem]] = []
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.tableHeaderView = UIView()
        return tv
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDisplayData()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.criteriaCell)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Data Setup
    
    fileprivate func initializeDisplayData() {
        var values: [ManualScreenItem] = []
        var valuation: [ManualScreenItem] = []
        var financial: [ManualScreenItem] = []
        
        SearchCriteria.allCases.forEach { criteria in
            switch criteria.classification {
            case .valuation:
                switch criteria {
                case .evtoebit, .evtofcff:
                    break
                default:
                    valuation.append(ManualScreenItem(criteria: criteria))
                }
            case .financial:
                financial.append(ManualScreenItem(criteria: criteria))
            case .performance:
                break
            case .other:
                switch criteria {
                case .name, .industrycategory, .none: break
                default: values.append(ManualScreenItem(criteria: criteria))
                }
            }
        }
        data.append(values)
        data.append(valuation)
        data.append(financial)
    }
    
    fileprivate func handleCrtieriaTap(criteria: SearchCriteria) {
        AnalyticsLogger.instance.reportEvents(event: .selectedAnalysis(criteria: criteria))
        
        dismiss(animated: true) {
            if let currentSearchCriteria = self.currentSearchCriteria {
                self.delegate?.didChangeSearchCriteria(previousSearchCriteria: currentSearchCriteria,
                                                       updatedSearchCriteria: criteria)
            }
        }
    }
}

extension SearchCriteriaSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.criteriaCell, for: indexPath)
        let searchCriteria = data[indexPath.section][indexPath.row].criteria
        cell.textLabel?.font = UIFont.details1
        cell.textLabel?.text = "\(searchCriteria.explicit)"
        
        if let currentSearchCriteria = currentSearchCriteria {
            if currentSearchCriteria == searchCriteria {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCrtieriaTap(criteria: data[indexPath.section][indexPath.row].criteria)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let header = SmallSectionHeaderLabel(padding: 16)
        view.addSubview(header)
        header.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 4, right: 18))
        let labelText = ["FINANCIAL STATEMENT VALUES", "VALUATION", "FINANCIAL"]
        header.text = labelText[section].uppercased()
        return view
    }
}
