//
//  ManualSearchResultsTableViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SearchCriteriaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchCriteriaDelegate, MenuBarDisplayable {
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.setTableHeaderView(headerView: tableHeader)
        return tv
    }()
    
    var menuViewItemDelegate: MenuViewItemDelegate?
    var menubarTitle: String = "Custom"
    
    private enum ReuseID {
        static let criteriaCell = "criteriaCell"
    }
    
    // MARK: - Data
    
    private var manualSearchCriteriaItems: [[ManualScreenItem]] = []
    private var manualScreenItems: [ManualScreenItem] = []
    
    // MARK: - Views
    
    private lazy var tableHeader: TableHeaderView = {
        let v = TableHeaderView()
        v.detailsLabel.text = ""
        v.headerLabel.text = "Select your search criteria."
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return v
    }()
    
    private lazy var searchButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Add Parameters", for: .normal)
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleNavigation), for: .touchUpInside)
        b.backgroundColor = .appAccent3
        b.layer.cornerRadius = 8
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return b
    }()
    
    private lazy var footer: UIView = {
        let v = UIView()
        v.addSubview(searchButton)
        searchButton.anchor(top: nil, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 0, left: 16, bottom: 50, right: 16))
        v.backgroundColor = .clear
        return v
    }()
    
    
    // MARK: - Initializer Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        initializeDisplayData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = VersionManager.mainContainerBackground()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.shouldUpdateHeaderViewFrame() {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - View Setup
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ManualSearchCriteriaCell.self, forCellReuseIdentifier: ReuseID.criteriaCell)
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 24
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(searchButton)
        searchButton.anchor(top: nil,
                            leading: view.leadingAnchor,
                            bottom: view.layoutMarginsGuide.bottomAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 0, left: 16, bottom: 16, right: 16),
                            size: .init(width: 0, height: 40))
        
        view.addSubview(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: searchButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    func setupTableHeader() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = tableHeader
            if let parent = parent as? ExploreFeedContainer {
                       parent.collectionView.contentInset = UIEdgeInsets(top: tableHeader.intrinsicContentSize.height + 5,
                       left: 0, bottom: 0, right: 0)
            }
        }
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
    
    @objc fileprivate func handleNavigation() {
        if manualScreenItems.isEmpty {
            presentAlert()
            return
        }
        let manualSearchVC = ManualSearchViewController(manualScreenItems: self.manualScreenItems)
        self.navigationController?.pushViewController(manualSearchVC, animated: true)
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return manualSearchCriteriaItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualSearchCriteriaItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.criteriaCell, for: indexPath) as? ManualSearchCriteriaCell
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        cell?.textLabel?.text = manualScreenItem.criteria.explicit
        
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        manualScreenItems.append(manualScreenItem)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let manualScreenItem = manualSearchCriteriaItems[indexPath.section][indexPath.row]
        manualScreenItems = manualScreenItems.filter{( $0.criteria != manualScreenItem.criteria)}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 40 }
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 80
        } else {
            return 15
        }
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
        if #available(iOS 13.0, *) {
            self.textLabel?.textColor = selected ? .appAccent3 : .label
        } else {
            self.textLabel?.textColor = selected ? .appAccent3 : .black
        }
    }
}
