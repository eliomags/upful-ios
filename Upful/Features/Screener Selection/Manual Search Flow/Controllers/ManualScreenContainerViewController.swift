//
//  ManualScreenSelectionContainerViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenContainerViewController: UITableViewController {
    
    private var viewModels: [[ManualScreenItemViewModel]] = []

    // MARK: - Views
    
    private lazy var collectionViews: [ManualScreenViewController] = {
        let views = viewModels.map { ManualScreenViewController(manualScreenItemViewModels: $0) }
        views.forEach{ $0.delegate = self }
        return views
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableView.Style = .grouped) {
        super.init(style: style)
        title = "Custom"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModels()
    }
    
    // MARK: - View Configuration
    
    fileprivate func configureViewModels() {
        viewModels = [
            getViewModels(from: .valuation),
            getViewModels(from: .financial),
            getViewModels(from: .performance)
        ]
    }
    
    fileprivate func getViewModels(from classification: CriteriaClassification) -> [ManualScreenItemViewModel] {
        return SearchCriteria.allCases
            .filter({ $0.classification == classification })
            .map { ManualScreenItem(criteria: $0) }
            .map { ManualScreenItemViewModel(manualScreenItem: $0) }
    }
    
    // MARK: - TableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return collectionViews.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let collectionView = collectionViews[indexPath.section]
        
        display(contentController: collectionView, on: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (100 * 2) + (16 * 3)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        
        let size = UIFont.preferredFont(forTextStyle: .caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .light)
        
        switch section {
        case CriteriaClassification.valuation.rawValue:
            label.text = "VALUATION"
            
        case CriteriaClassification.financial.rawValue:
            label.text = "FINANCIAL"
            
        case CriteriaClassification.performance.rawValue:
            label.text = "PERFORMANCE"
        default:
            assertionFailure("Only Performance, Valuation and Financial options (3) allowed to be displayed.")
        }
        return view
    }
}

extension ManualScreenContainerViewController: ManualScreenerItemUpdatable {
    func didDelete(at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row].resetParameter()
    }
    
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row] = manualScreenItemViewModel
    }
}
