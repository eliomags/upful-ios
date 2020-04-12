//
//  ManualScreenSelectionContainerViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerViewController: UIViewController {
    
    private var viewModels: [[ManualScreenItemViewModel]] = [] 

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
    
    private lazy var runScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitle("Build", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(handleBuildTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(runScreenButton)
        runScreenButton.fillSuperview(padding: .init(top: 16, left: 32, bottom: 8, right: 32))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.35)
        return view
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
    
    fileprivate var shouldRemoveBuildButton: Bool {
        var selectedScreenItems: [ManualScreenItemViewModel] = []
        
        viewModels.forEach { (section) in
            selectedScreenItems += section.filter { $0.isSelected == true }
        }
        
        return selectedScreenItems.isEmpty
    }
    
    fileprivate func showBuildButton() {
        viewModels.forEach { (section) in
            if let _ = section.first(where: { $0.isSelected == true }) {
                view.addSubview(buttonBackgroundView)
                buttonBackgroundView.anchor(top: nil, leading: view.leadingAnchor,
                                            bottom: view.layoutMarginsGuide.bottomAnchor,
                                            trailing: view.trailingAnchor)
                return
            }
        }
    }
    
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
    
    // MARK: - Actions
    
    private var coordinator: Coordinator?

    @objc fileprivate func handleBuildTap() {
        var selectedManualScreenItems: [ManualScreenItem] = []
        viewModels.forEach { (section) in
            selectedManualScreenItems += section.filter({ $0.isSelected == true }).map({ $0.manualScreenItem })
        }
        print(selectedManualScreenItems.asURLComponents)
        print(selectedManualScreenItems.asDescription)
        
        AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .manual))
        coordinator = SearchResultsCoordinator(
            presenter: self,
            searchParameters: selectedManualScreenItems.asURLComponents,
            title: "Custom",
            screenerDescription: selectedManualScreenItems.asDescription,
            headerbackgroundColor: .appAccent3,
            id: UUID().uuidString,
            headerSymbol: nil
        )
        coordinator?.start()
    }
    
    @objc fileprivate func handleClearTap() {
        viewModels.forEach { section in
            section.forEach({ $0.resetParameter() })
        }
        
        collectionViews.forEach({
            $0.viewModels.forEach({ $0.resetParameter()})
            $0.collectionView.reloadData()
        })
        
        buttonBackgroundView.removeFromSuperview()
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
        
        if shouldRemoveBuildButton { buttonBackgroundView.removeFromSuperview() }
    }
    
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row] = manualScreenItemViewModel

        showBuildButton()
    }
}
