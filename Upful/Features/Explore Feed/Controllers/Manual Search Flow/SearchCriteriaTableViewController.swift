//
//  ManualSearchResultsTableViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SearchCriteriaTableViewController: UITableViewController, SearchCriteriaDelegate, MenuBarDisplayable {
    
    var delegate: MenuViewItemDelegate?
    
    var menubarTitle: String = "Manual Search"
    
   
    private enum ReuseID {
        static let criteriaCell = "criteriaCell"
    }
    
    
    // MARK: - Data
    
    private var manualSearchCriteriaItems: [[ManualScreenItem]] = []
    private var manualScreenItems: [ManualScreenItem] = []
    
    
    // MARK: - Views

    private lazy var addCriteriaButton: CustomRoundButton = {
        let b = CustomRoundButton()
        b.setBackgroundImage(#imageLiteral(resourceName: "icons8-plus-math-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        b.addTarget(self, action: #selector(handleNavigation), for: .touchUpInside)
        return b
    }()
    
    
    // MARK: - Initializer Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        initializeDisplayData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = .groupTableViewBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.addSubview(addCriteriaButton)
        addCriteriaButton.anchor(
            top: nil, leading: nil, bottom: self.parent?.view.layoutMarginsGuide.bottomAnchor, trailing: self.parent?.view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 45, right: 25))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addCriteriaButton.removeFromSuperview()
    }
    
    
    // MARK: - View Setup
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ManualSearchCriteriaCell.self, forCellReuseIdentifier: ReuseID.criteriaCell)
        tableView.tableHeaderView = UIView()
        tableView.sectionHeaderHeight = 60
        tableView.backgroundColor = .white
    }
    
    
    // MARK: - Delegate Method
    
    func remove(indexPath: IndexPath) {
        for section in 0...manualSearchCriteriaItems.count - 1 {
            for row in 0..<manualSearchCriteriaItems[section].count {
                if manualSearchCriteriaItems[section][row].criteria == manualScreenItems[indexPath.row].criteria {
                    tableView.deselectRow(at: IndexPath(row: row, section: section), animated: true)
                }
            }
        }
        manualScreenItems.remove(at: indexPath.row)
    }
    
    func updateScreenerItems(with updatedItems: [ManualScreenItem]) {
        self.manualScreenItems = updatedItems
    }
    
    
    // MARK: - Actions
    
    @objc fileprivate func handleNavigation(_ sender: UIButton) {
        if manualScreenItems.isEmpty {
            presentAlert()
            return
        }
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = .identity
            }, completion: { (_) in
                let manualSearchVC = ManualSearchViewController(manualScreenItems: self.manualScreenItems,
                                                                analyticsLogger: AnalyticsLogger())
                manualSearchVC.delegate = self
                self.navigationController?.pushViewController(manualSearchVC, animated: true)
            })
        }
    }
    
    fileprivate func presentAlert() {
        let alert = UIAlertController(title: "", message: "Please add at least one criteria to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Setup
    
    fileprivate func initializeDisplayData() {
        var valuation: [ManualScreenItem] = []
        var financial: [ManualScreenItem] = []
        var performance: [ManualScreenItem] = []
        
        SearchCriteria.allCases.forEach { (criteria) in
            switch criteria {
            case .bookvaluepershare: break
            default:
                switch criteria.classification {
                case .valuation:
                    valuation.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
                case .financial:
                    financial.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
                case .performance:
                    performance.append(ManualScreenItem(criteria: criteria, parameter: .none, value: nil))
                case .other:
                    break
                }
            }
        }
        manualSearchCriteriaItems.append(valuation)
        manualSearchCriteriaItems.append(financial)
        manualSearchCriteriaItems.append(performance)
    }
    

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return manualSearchCriteriaItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualSearchCriteriaItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.criteriaCell, for: indexPath) as? ManualSearchCriteriaCell
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        cell?.textLabel?.text = manualScreenItem.criteria.explicit
        
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        manualScreenItems.append(manualScreenItem)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        manualScreenItems = manualScreenItems.filter{( $0.criteria != manualScreenItem.criteria)}
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let header = SmallSectionHeaderLabel(padding: 16)
        view.addSubview(header)
        header.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 4, right: 18))
        let labelText = [
            "VALUATION METRICS",
            "FINANCIAL METRICS",
            "GROWTH METRICS",
        ]
        header.text = labelText[section]
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 90 }
        return 25
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 80
        } else {
            return 15
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ManualSearchCriteriaCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        self.textLabel?.font = selected ? .details2 : .details1
    }
}
