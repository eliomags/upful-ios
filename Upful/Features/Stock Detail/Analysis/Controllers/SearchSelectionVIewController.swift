//
//  SearchSelectionVIewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/15/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SearchSelectionViewController: UIViewController {
    struct Constants {
        static let criteriaCell = "CriteriaCell"
    }
    
    // MARK: - State

    var data: [[ManualScreenItem]] = []
    weak var delegate: ChartUpdatable?
    let chartType: ChartType
    
    // MARK: - Views
    
    lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return button
    }()
    
    lazy var tableHeader: TableHeaderView = {
        let header = TableHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.heightAnchor.constraint(equalToConstant: header.intrinsicContentSize.height).isActive = true
        header.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        header.headerLabel.text = "Select a criteria."
        header.detailsLabel.text = ""
        return header
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.tableHeaderView = tableHeader
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Initializer Functions
    
    init(chartType: ChartType) {
        self.chartType = chartType
        super.init(nibName: nil, bundle: nil)
        initializeDisplayData()
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        setupTableHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        let cancel = UIBarButtonItem(customView: cancelButton)
        cancel.tintColor = .black
        navigationItem.leftBarButtonItem = cancel
    }
    
    fileprivate func setupTableView() {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark { tableView.backgroundColor = .black }
        } else { tableView.backgroundColor = .groupTableViewBackground }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.criteriaCell)
        tableView.contentInsetAdjustmentBehavior = .automatic
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    fileprivate func setupTableHeader() {
        tableView.tableHeaderView = tableHeader
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    // MARK: - Data Setup
    
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
                case .name, .industrycategory, .none: break
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

extension SearchSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.criteriaCell, for: indexPath)
        cell.textLabel?.font = UIFont.details1
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].criteria.explicit)"
        
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
