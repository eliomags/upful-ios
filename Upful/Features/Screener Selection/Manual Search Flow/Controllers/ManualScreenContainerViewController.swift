//
//  ManualScreenSelectionContainerViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerViewController: UIViewController {
    
    private var viewModels: [[ManualScreenItemViewModel]] = [] {
        didSet {
            viewModels.forEach { section in
                section.forEach {
                    if $0.isSelected {
                        print($0.titleText)
                    }
                }
            }
        }
    }

    // MARK: - Views
    
    private lazy var headerView: ManualScreenContainerHeaderView = {
        let view = ManualScreenContainerHeaderView()
        view.clearButton.addTarget(self, action: #selector(handleClearTap), for: .touchUpInside)
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.separatorStyle = .none
        tv.backgroundColor = .systemBackground
        tv.showsVerticalScrollIndicator = false
        tv.setTableHeaderView(headerView: headerView)
        return tv
    }()
    
    private lazy var collectionViews: [ManualScreenViewController] = {
        let views = viewModels.map{ ManualScreenViewController(manualScreenItemViewModels: $0) }
        views.forEach{ $0.delegate = self }
        
        return views
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Custom"
        configureViewModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.shouldUpdateHeaderViewFrame() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
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
    
    @objc fileprivate func handleClearTap() {
        viewModels.forEach { section in
            section.forEach({ $0.resetParameter() })
        }
        
        collectionViews.forEach({
            $0.viewModels.forEach({ $0.resetParameter()})
            $0.collectionView.reloadData()
        })
    }
}

// MARK: - TableView Delegate Methods

extension ManualScreenContainerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return collectionViews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let collectionView = collectionViews[indexPath.section]
        
        display(contentController: collectionView, on: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (100 * 2) + (16 * 3)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModels.count-1 {
            return 100
        } else {
            return 0
        }
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
