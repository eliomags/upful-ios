//
//  ManualScreenSelectionContainerViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ManualScreenContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModels: [[ManualScreenItemViewModel]] = []
    
    private var selectedScreenItems: [ManualScreenItemViewModel] {
        return collectionViews.reduce([]) { (res, vc) -> [ManualScreenItemViewModel] in
            return vc.viewModels.filter({ $0.isSelected }) + res
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
    
    private lazy var runScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitle("BUILD", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
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
        addBuildView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if tableView.shouldUpdateHeaderViewFrame() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: - View Configuration
    
    fileprivate func addBuildView() {
        updateScreenButtonState()
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.anchor(top: nil, leading: view.leadingAnchor,
                                    bottom: view.layoutMarginsGuide.bottomAnchor,
                                    trailing: view.trailingAnchor)
    }
    
    fileprivate func updateScreenButtonState() {
        if selectedScreenItems.isEmpty {
            runScreenButton.isEnabled = false
            runScreenButton.backgroundColor = .lightGray
        } else {
            runScreenButton.isEnabled = true
            runScreenButton.backgroundColor = .appAccent3
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
    
    @objc fileprivate func handleBuildTap() {
        PermissionManager.shared.verifyScreenerNavigationPermission { (shouldNavigate) in
            if shouldNavigate {
                handleScreenResultNavigation()
                
            } else {
                let presenter = SubscriptionPresenter(type: .screeningLimit)
                presenter.present(in: self)
            }
        }
    }
    
    @objc fileprivate func handleClearTap() {
        collectionViews.forEach({
            $0.viewModels.forEach({ $0.resetParameter()})
            $0.collectionView.reloadData()
        })
        updateScreenButtonState()
        Vibration.success.vibrate()
    }
    
    // MARK: - Helpers
    
    private var coordinator: Coordinator?
    
    fileprivate func handleScreenResultNavigation() {
        AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .manual))

        let selectedManualScreenItems = selectedScreenItems.map { $0.manualScreenItem }
                
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
        collectionView.section = indexPath.section
        
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
            return 75
        } else {
            return 0
        }
    }
}

extension ManualScreenContainerViewController: ManualScreenerItemUpdatable {
    func didDelete(at indexPath: IndexPath) {
        Vibration.light.vibrate()
        updateScreenButtonState()
    }
    
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        Vibration.selection.vibrate()
        updateScreenButtonState()
    }
    
}

extension ManualScreenContainerViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {}
}
