//
//  SettingsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let displayItems: [[String]] = [
        ["Preferences"],
        
        ["Upgrade to Premium",
        "Restore Purchase"],
        
        ["Leave a Suggestion",
        "Report an Issue",
        "Allow Tracking"],
        
        ["Leave a Rating"]
    ]
    
    // MARK: - Views
    
    lazy var toggleTrackingSwitch: UISwitch = {
        let tswitch = UISwitch()
        tswitch.isOn = AnalyticsLogger.instance.getAnalyticsPermission()
        tswitch.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        return tswitch
    }()
    
    @objc fileprivate func handleChange(_ sender: UISwitch) {
        AnalyticsLogger.instance.toggleAnalytics()
    }
    
    // MARK: - Initializer Methods

    override func loadView() {
        super.loadView()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - TableView DataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = displayItems[indexPath.section][indexPath.row]
        if indexPath.section == 2 {
            if indexPath.row == 2 {
                cell.accessoryView = toggleTrackingSwitch
            }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
            // MARK - Preferences
        case 0 :
            let preferencePresenter = PreferencePresenter()
            preferencePresenter.present(in: self)
        case 1:
            switch row {
            case 0, 1:
                let presenter = SubscriptionPresenter()
                presenter.present(in: self)
            default: break
            }
            // MARK - Purchase
        case 2:
            switch row {
            case 0:
                let suggestionVC = ReportPresenter(reportType: .suggestion)
                suggestionVC.present(in: self)
            case 1:
                let issueVC = ReportPresenter(reportType: .issue)
                issueVC.present(in: self)
            default: break
            }
            // MARK - Review
        case 3:
            switch row {
            case 0:
                AppStoreReviewHelper.requestAppStoreReview()
            default: break
            }
            
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = ["","purchase","support",""]
        let view = UIView()
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        view.addSubview(label)
        label.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: 16, bottom: 4, right: 0))
        label.text = headers[section].uppercased()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 { return 40 }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
}

