//
//  ManualScreenSelectionContainerViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerHeaderView: UIView {
    // MARK: - Views

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Tap a cell to build your screener."
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.title2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 35/2
        button.layer.masksToBounds = true
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 75).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel])
        sv.spacing = 16
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
            clearButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -16)
        ])
        
        addSubview(headerLabel)
        headerLabel.anchor(top: layoutMarginsGuide.topAnchor,
                           leading: layoutMarginsGuide.leadingAnchor,
                           bottom: clearButton.layoutMarginsGuide.topAnchor,
                           trailing: layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: 16, left: 16, bottom: 24, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ManualScreenContainerViewController: UIViewController {
    
    private var viewModels: [[ManualScreenItemViewModel]] = []

    // MARK: - Views
    
    private lazy var headerView: ManualScreenContainerHeaderView = {
        let view = ManualScreenContainerHeaderView()
        view.clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
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
    
    @objc fileprivate func handleClear() {
        viewModels.forEach { section in
            section.forEach({ $0.resetParameter() })
        }
        collectionViews.forEach({ $0.collectionView.reloadData() })
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
}

extension ManualScreenContainerViewController: ManualScreenerItemUpdatable {
    func didDelete(at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row].resetParameter()
    }
    
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row] = manualScreenItemViewModel
    }
}
