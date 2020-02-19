//
//  SavedScreenersViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedScreenerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var coordinator: Coordinator?

    lazy var viewModel: SavedScreenersViewModel = {
        let vm = SavedScreenersViewModel()
        return vm
    }()
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Screeners"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupTableViewFunctionality()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeStateUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadScreeners()
    }
    
    // MARK: - TableView Updates
    
    func observeStateUpdates() {
        viewModel.sendStateChanges = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .new:
                break
            case .loading:
                self.handleLoadingState()
            case .loaded:
                self.handleLoadedState()
            case .error:
                self.handleErrorState()
            case .empty:
                self.handleEmptyState()
            }
        }
    }
    
    fileprivate func handleLoadingState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    fileprivate func handleLoadedState() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.isScrollEnabled = true
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.reloadData()
    }
    
    fileprivate func handleErrorState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.reloadData()
    }
    
    fileprivate func handleEmptyState() {
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.reloadData()
        if let container = parent as? HomeContainerViewController {
            container.emphasizeButton()
        }
    }
    
    // MARK: - View Setup
    
    func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.register(ScreenerPreviewTableViewCell.self, forCellReuseIdentifier: "screenerCell")
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupTableViewFunctionality() {
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    // MARK: - Navigation
    
//    fileprivate func handleScreenerEdit(_ screener: Screener) {
//        let manualScreenItems = screener.manualScreenItems
//        let manualSearchVC = ManualSearchViewController(manualScreenItems: manualScreenItems)
//        manualSearchVC.screenerTitleText = screener.title
//        navigationController?.pushViewController(manualSearchVC, animated: true)
//    }
    
    // MARK: - TableView Cells
    
    fileprivate func showLoadedCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let screenerCell = tableView.dequeueReusableCell(withIdentifier: "screenerCell", for: indexPath) as? ScreenerPreviewTableViewCell  else { return UITableViewCell() }
        let screener = viewModel.screeners[indexPath.row]
        screenerCell.titleLabel.text = screener.title
        screenerCell.descriptionLabel.text = screener.description
        screenerCell.iconImageView.image = screener.getSymbol()
        screenerCell.iconImageViewBackground.backgroundColor = screener.getColorMap()
        screenerCell.showLoaded()
        return screenerCell
    }

    // MARK: - TableView Delegate/Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isLoaded = viewModel.state == .loaded
        return isLoaded ? viewModel.screeners.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .loaded:
            return showLoadedCell(for: indexPath)
        case .empty:
            return EmptyScreenerFavoriteCell(style: .default, reuseIdentifier: nil)
        case .error:
            return ErrorFavoriteCell(style: .default, reuseIdentifier: nil)
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func handleSearchResultNavigation(with screener: Screener) {
        PermissionManager.shared.verifyScreenerNavigationPermission { (shouldNavigate) in
            if shouldNavigate {
                coordinator = SearchResultsCoordinator(presenter: self, screener: screener)
                coordinator?.start()
            }
            if !shouldNavigate {
                let presenter = SubscriptionPresenter(type: .screeningLimit)
                presenter.present(in: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.state {
        case .loaded:
            AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .saved))
            let screener = viewModel.screeners[indexPath.row]
            handleSearchResultNavigation(with: screener)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isLoaded = viewModel.state == .loaded
        return isLoaded ? 104 : tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isLoaded = viewModel.state == .loaded
        let screenerHeader = TableSectionHeaderView()
        screenerHeader.headerTextLabel.text = "Saved Screeners"
        screenerHeader.addButton.setTitle("", for: .normal)
        return isLoaded ? screenerHeader : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isLoaded = viewModel.state == .loaded
        return isLoaded ? 75 : 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if viewModel.state == .loaded {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] ( _, _, _) in
                guard let self = self else { return }
                let screener = self.viewModel.screeners[indexPath.row]
                self.viewModel.removeScreener(screener.id)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.viewModel.refreshState()
                }
                Vibration.light.vibrate()
            }
//            let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] ( _, _, _) in
//                guard let self = self else { return }
//                let screener = self.viewModel.screeners[indexPath.row]
//                self.handleScreenerEdit(screener)
//            }
//            edit.backgroundColor = .appAccent2
//            edit.image = UIImage(systemName: "pencil")
            delete.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [delete])
        }
        return nil
    }
}

// MARK: - TableView Drag/Drop Delegate Methods

extension SavedScreenerViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        switch viewModel.state {
        case .loaded:
            let screenerID = viewModel.screeners[indexPath.item].id
            guard let data = screenerID.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "kUTTypePlainText")
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = screenerID
            Vibration.light.vibrate()
            return [dragItem]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        guard let sourceIndexPath = coordinator.items[0].sourceIndexPath else { return }
        viewModel.screeners.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        viewModel.saveDatasourceConfiguration()
        tableView.reloadData()
        coordinator.drop(coordinator.items[0].dragItem, toRowAt: destinationIndexPath)
        Vibration.light.vibrate()
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension SavedScreenerViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {
        showNotificationSetupView()
    }
    
    func userDidSignUp() {}
}
