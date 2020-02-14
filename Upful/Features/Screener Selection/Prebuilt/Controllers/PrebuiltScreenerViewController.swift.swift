//
//  ScreenerSelectionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class PrebuiltScreenerViewController: UITableViewController {
    enum Section: Int {
        case popular, all
    }
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var coordinator: Coordinator?
    
    lazy var logicController: PrebuiltScreenerLogicController = {
        let lc = PrebuiltScreenerLogicController()
        return lc
    }()
    
    // MARK: - Views
    
    private lazy var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleResfreshing), for: .valueChanged)
        return control
    }()
            
    // MARK: - Initializer
    
    init() {
        super.init(style: .grouped)
        title = "Pre-built"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStateUpdates()
        logicController.loadScreeners()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        tableView.refreshControl = tableRefreshControl
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.register(ScreenerPreviewTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Controller Binding
    
    fileprivate func getStateUpdates() {
        logicController.sendStateUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loading:
                LoadingViewPresenter.show(in: self)
            default:
                LoadingViewPresenter.remove()
            }
            self.tableView.reloadData()
            self.tableRefreshControl.endRefreshing()
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleResfreshing(_ sender: UIRefreshControl) {
        tableRefreshControl.endRefreshing()
        logicController.loadScreeners()

    }
     
    // MARK: - Cell Creation
    
    fileprivate func makeScreenerCells(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScreenerPreviewTableViewCell
        let section = indexPath.section
        var viewModel: ScreenerViewModel

        if section == Section.popular.rawValue {
            viewModel = logicController.popularScreenerViewModels[indexPath.row]
            cell?.titleLabel.text = viewModel.title
            cell?.descriptionLabel.text = viewModel.description
            cell?.iconImageView.image = viewModel.getSymbol()
            cell?.iconImageViewBackground.backgroundColor = viewModel.getColor()
        }
        if section == Section.all.rawValue {
            viewModel = logicController.screenerViewModels[indexPath.row]
            cell?.titleLabel.text = viewModel.title
            cell?.descriptionLabel.text = viewModel.description
            cell?.iconImageView.image = viewModel.getSymbol()
            cell?.iconImageViewBackground.backgroundColor = viewModel.getColor()
        }
        cell?.showLoaded()
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: - TableView Delegate/Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.popular.rawValue:
            return logicController.popularScreenerViewModels.count
        case Section.all.rawValue:
            return logicController.screenerViewModels.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeScreenerCells(for: indexPath)
    }
    
    fileprivate func handleScreenerTap(at indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case Section.popular.rawValue:
            let popularScreener = logicController.popularScreenerViewModels[indexPath.row]
            coordinator = SearchResultsCoordinator(presenter: self,
                                                   searchParameters: popularScreener.searchParameters,
                                                   title: popularScreener.title,
                                                   screenerDescription: popularScreener.description,
                                                   headerbackgroundColor: popularScreener.getColor(),
                                                   headerSymbol: popularScreener.getSymbol())
            coordinator?.start()
        case Section.all.rawValue:
            let screenerViewModel = logicController.screenerViewModels[indexPath.row]
            coordinator = SearchResultsCoordinator(presenter: self,
                                                   searchParameters: screenerViewModel.searchParameters,
                                                   title: screenerViewModel.title,
                                                   screenerDescription: screenerViewModel.description,
                                                   headerbackgroundColor: screenerViewModel.getColor(),
                                                   headerSymbol: screenerViewModel.getSymbol())
            coordinator?.start()
        default: break
        }
    }
    
    var pendingAction: ((_ indexPath: IndexPath) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PermissionManager.shared.verifyScreenerNavigationPermission { (permissionGranted) in
            if permissionGranted {
                AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .quick))
                logicController.incrementScreenerInterest(at: indexPath)
                handleScreenerTap(at: indexPath)
            } else {
                pendingAction?(indexPath)
                let presenter = SubscriptionPresenter(type: .screeningLimit)
                presenter.present(in: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isDataLoaded = logicController.popularScreenerViewModels.isEmpty && logicController.screenerViewModels.isEmpty
        if !isDataLoaded {
            let header = TableSectionHeaderView()
            switch section {
            case Section.popular.rawValue:
                header.headerTextLabel.text = "Popular Screeners"
            case Section.all.rawValue:
                header.headerTextLabel.text = "Available Screeners"
            default: break
            }
            header.addButton.setTitle("", for: .normal)
            return header
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = .identity
        }
    }
}

// MARK: - SubscriptionViewControllerDelegate Methods

extension PrebuiltScreenerViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {
        pendingAction = { [weak self] (indexPath) in
            guard let self = self else { return }
            self.handleScreenerTap(at: indexPath)
        }
    }
}
