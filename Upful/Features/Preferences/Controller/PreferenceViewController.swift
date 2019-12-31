//
//  PreferenceViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: PreferenceDelegate?
    
    
    // MARK: - Dependencies
    
    let dataManager: PreferenceDataManager
    
    // MARK: - Views
    
    lazy var preferenceHeaderView: PreferenceHeaderView = {
        let view = PreferenceHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = VersionManager.mainContainerBackground()
        view.separatorStyle = .none
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = self
        view.dataSource = self
        view.setTableHeaderView(headerView: preferenceHeaderView)
        return view
    }()
    
    lazy var cancelButton: CancelButton = { [unowned self] in
        let view = CancelButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return view
    }()
    
    lazy var saveButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .appAccent3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Initializer Methods
    
    init(dataManager: PreferenceDataManager = .init()) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground()
        setupNavBar()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.shouldUpdateHeaderViewFrame() {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationItem.title = "Preferences"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupViews() {
        view.addSubview(saveButton)
        saveButton.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 16, right: 16),
            size: .init(width: 0, height: 40))
        
        view.addSubview(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: saveButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true, completion: {
            self.delegate?.didCancelSaving()
        })
    }
    
    @objc fileprivate func handleDone() {
        dataManager.save()
        AnalyticsLogger.instance.reportEvents(event: .preferencesSet)
        self.dismiss(animated: true, completion: {
            self.delegate?.didCompleteSaving()
        })
    }
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    var industryContentHeight: CGFloat = 0 {
        didSet{
            if didUpdateIndustryConstraint == false {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    var defaultContentHeight: CGFloat = 0 {
        didSet{
            if didUpdateDefaultConstraint == false {
                for section in 0...dataManager.data.count - 1 {
                    tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
                }
            }
        }
    }
    var didUpdateIndustryConstraint = false
    var didUpdateDefaultConstraint = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let preferenceData = dataManager.data[section]
        var preferenceCollectionView: GenericPreferenceCollectionViewController
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch section {
        case 0:
             preferenceCollectionView = IndustryPreferenceCollectionViewController(
                preferences: preferenceData,
                savedPreferenceIds: dataManager.retrieveSavedIDs())
            preferenceCollectionView.contentUpdated = { [weak self] contentHeight in
                self?.industryContentHeight = contentHeight
                self?.didUpdateIndustryConstraint = true
            }
        default:
            preferenceCollectionView = GenericPreferenceCollectionViewController(
                preferences: preferenceData,
                savedPreferenceIds: dataManager.retrieveSavedIDs())
            preferenceCollectionView.contentUpdated = { [weak self] contentHeight in
                self?.defaultContentHeight = contentHeight
                self?.didUpdateDefaultConstraint = true
            }
        }
        display(contentController: preferenceCollectionView, on: cell)
        preferenceCollectionView.preferenceSelected = { [weak self] (selection) in
            self?.dataManager.update(selection)
        }
        
        preferenceCollectionView.preferenceDeSelected = { [weak self] (deSelection) in
            self?.dataManager.remove(deSelection)
        }
        cell.backgroundColor = VersionManager.mainContainerBackground()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if industryContentHeight == 0 { return tableView.frame.height / 2 + 20 }
            return industryContentHeight
        }
        if #available(iOS 13.0, *) {
            if defaultContentHeight == 0 { return 65 }
            else { return defaultContentHeight + 8 }
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = ["Select Up to 3 Industry Categories",
                       "Select a Growth Preference",
                       "Select a Profitability Preference",
                       "Select a Dividend Preference"
                    ]
        let label = LargeSectionHeaderLabel(padding: 16)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.text = headers[section]
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


