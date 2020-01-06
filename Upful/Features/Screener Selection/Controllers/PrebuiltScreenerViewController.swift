//
//  ScreenerSelectionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class PrebuiltScreenerViewController: UITableViewController, MenuBarDisplayable {
    
    // MARK: - Dependencies
    // Core data for knowing currently saved screeners based on name
    // Core data for saving screener
    // Firestore for loading screeners
    // Delegate for dismissing and passing values to home
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var menubarTitle: String = "Pre-built"
    
    lazy var logicController: PrebuiltScreenerLogicController = {
        let lc = PrebuiltScreenerLogicController()
        return lc
    }()
    
    // MARK: - Initializer
    
    init() { super.init(style: .grouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStateUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logicController.loadScreeners()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.register(ScreenerPreviewTableViewCell.self, forCellReuseIdentifier: "cell") 
    }
    
    // MARK: - Controller Binding
    
    fileprivate func getStateUpdates() {
        logicController.sendStateUpdates = { [weak self] (state) in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleSaveTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // TODO: - Handle Saving/Deletion
    }
        
    // MARK: - Cell Creation
    
    fileprivate func makeScreenerCells(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScreenerPreviewTableViewCell
        cell?.saveButton.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        
        if !logicController.screenerViewModels.isEmpty {
            cell?.showLoaded()
            let viewModel = getScreenerViewModel(for: indexPath)
            cell?.titleLabel.text = viewModel.title
            cell?.descriptionLabel.text = viewModel.description
            cell?.loadImage(urlString: viewModel.imageUrlString)
        }

        return cell ?? UITableViewCell()
    }
    
    // MARK: - Helpers
    
    fileprivate func getScreenerViewModel(for indexPath: IndexPath) -> ScreenerViewModel {
        return logicController.screenerViewModels[indexPath.row]
    }
    
    // MARK: - TableView Delegate/Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isEmpty = logicController.screenerViewModels.isEmpty
        return isEmpty ? 10 : logicController.screenerViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeScreenerCells(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !logicController.screenerViewModels.isEmpty {
            dismiss(animated: true, completion: {
                let searchParameters = self.getScreenerViewModel(for: indexPath).searchParameters
                let parentVC = self.parent as? ScreenerSelectionContainerView
                parentVC?.screenerSelectionDelegate?.didSelectScreener(searchParameters: searchParameters)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableSectionHeaderView()
        header.headerTextLabel.text = "Available Screeners"
        header.addButton.setTitle("", for: .normal)
        return header
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
