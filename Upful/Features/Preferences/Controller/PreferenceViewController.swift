//
//  PreferenceViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Dependencies
    
    let dataManager: PreferenceDataManager
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.tableHeaderView = UIView()
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - Initializer Methods
    
    init(dataManager: PreferenceDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupViews()
    }
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationItem.title = "Preferences"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleDone() {
        print("////////////////////")
        dataManager.savedPreferences.forEach { (preference) in
            print(preference)
        }
        print("////////////////////")
        dataManager.save()
        self.dismiss(animated: true)
    }
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let preferenceData = dataManager.data[section]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let preferenceCollectionView = GenericPreferenceCollectionViewController(preferences: preferenceData)
        display(contentController: preferenceCollectionView, on: cell)
        
        preferenceCollectionView.preferenceSelected = { [weak self] (selection) in
            self?.dataManager.update(selection)
        }
        preferenceCollectionView.preferenceDeSelected = { [weak self] (deSelection) in
            self?.dataManager.remove(deSelection)
        }
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return tableView.frame.height / 3 - 50}
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = ["Industry", "Growth", "Profitability", "Dividend"]
        let label = LargeSectionHeaderLabel(padding: 16)
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.text = headers[section].uppercased()
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


