//
//  SearchSelectionVIewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/15/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SearchSelectionViewController: UITableViewController {
    struct Constants {
        static let criteriaCell = "CriteriaCell"
    }
    
    // MARK: - State

    var data: [[ManualScreenItem]] = []
    weak var delegate: ChartUpdatable?
    let chartType: ChartType
    
    // MARK: - State
    
    lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return button
    }()
    
    
    // MARK: - Initializer Functions
    
    init(chartType: ChartType) {
        self.chartType = chartType
        super.init(style: .grouped)
        initializeDisplayData()
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.criteriaCell)
        let saveButton = UIBarButtonItem(customView: cancelButton)
        saveButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = saveButton
        
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: -
    
    fileprivate func initializeDisplayData() {
        var values: [ManualScreenItem] = []
        var valuation: [ManualScreenItem] = []
        var financial: [ManualScreenItem] = []
        var performance: [ManualScreenItem] = []
        SearchCriteria.allCases.forEach { (criteria) in
            switch criteria.classification {
            case .valuation:
                switch criteria {
                case .evtoebit, .evtofcff:
                    break
                default:
                    valuation.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
                }
            case .financial:
                financial.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
            case .performance:
                performance.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
            case .other:
                switch criteria {
                case .name, .none: break
                default: values.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
                }
            }
        }
        data.append(values)
        data.append(valuation)
        data.append(financial)
        data.append(performance)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleDismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    fileprivate func handleCrtieriaTap(criteria: SearchCriteria) {
        AnalyticsLogger.instance.reportEvents(event: .selectedAnalysis(criteria: criteria))

        dismiss(animated: true) {
            self.delegate?.updateChartData(chartType: self.chartType, criteria: criteria)
        }
    }
}

extension SearchSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.criteriaCell, for: indexPath)
        cell.textLabel?.font = UIFont.details1
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].criteria.explicit)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCrtieriaTap(criteria: data[indexPath.section][indexPath.row].criteria)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let header = SmallSectionHeaderLabel(padding: 16)
        view.addSubview(header)
        header.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 4, right: 18))
        let labelText = [
            "FINANCIAL STATEMENT VALUES",
            "VALUATION",
            "FINANCIAL",
            "GROWTH"
        ]
        header.text = labelText[section].uppercased()
        return view
    }
}
