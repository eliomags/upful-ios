//
//  SettingsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PreferenceDelegate {
    
    let displayItems: [[String]] = [
        ["Preferences"],
        
        ["Upgrade to Premium"],
        
        ["Leave a Suggestion",
        "Report an Issue",
        "Allow Tracking"],
        
        ["Leave a Rating"]
    ]
    
    // MARK: - Views
    
    lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: UITableView.Style.insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy var toggleTrackingSwitch: UISwitch = { [unowned self] in
        let tswitch = UISwitch()
        tswitch.isOn = AnalyticsLogger.instance.getAnalyticsPermission()
        tswitch.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        tswitch.isEnabled = PermissionManager.shared.isPremium
        return tswitch
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VersionManager.setNavigationBar(in: navigationController)
        VersionManager.navigationBarColor(in: navigationController)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    fileprivate func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleChange(_ sender: UISwitch) {
        AnalyticsLogger.instance.toggleAnalytics()
    }
    
    
    // MARK: - Preference Delegate Methods
    
    func didCancelSaving() {
        
    }
    
    func didCompleteSaving() {
        
    }
    
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = displayItems[indexPath.section][indexPath.row]
        if indexPath.section == 2 {
            if indexPath.row == 2 { cell.accessoryView = toggleTrackingSwitch }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
            // MARK - Preferences
        case 0 :
            let preferencePresenter = PreferencePresenter(presentingViewController: self)
            preferencePresenter.present()
            // MARK - Purchase
        case 1:
            switch row {
            case 0:
                let presenter = SubscriptionPresenter(type: .settings)
                presenter.present(in: self)
            default: break
            }
            // MARK - Support
        case 2:
            switch row {
            case 0:
                let suggestionVC = ViewSuggestionsVC()
                navigationController?.pushViewController(suggestionVC, animated: true)
            case 1:
                let issueVC = ReportPresenter(reportType: .issue)
                issueVC.present(in: self)
            case 2:
                if !PermissionManager.shared.isPremium {
                    let alertVC = UIAlertController(
                            title: "Upgrade",
                            message: "Tracking is used to gather data for improving your experience. Upgrade to premium to disable tracking.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alertVC.addAction(UIAlertAction(title: "Upgrade", style: .default, handler: { [weak self] (_) in
                        guard let self = self else { return }
                        let presenter = SubscriptionPresenter(type: .settings)
                        presenter.present(in: self)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                }
            default: break
            }
            // MARK - Review
        case 3:
            switch row {
            case 0:
                UserFeedbackPresenter.requestAppStoreReview()
            default: break
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = ["","purchase","support",""]
        let view = UIView()
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        view.addSubview(label)
        label.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: 16, bottom: 4, right: 0))
        label.text = headers[section].uppercased()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 40 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
}

// MARK: - Report Delegate

extension SettingsViewController: ReportDelegate {
    func showSuccess() {
        InformationViewPresenter().showReportSuccess(in: self)
    }
}

extension SettingsViewController: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {
        toggleTrackingSwitch.isEnabled = PermissionManager.shared.isPremium
    }
    
    func userDidSignUp() {
        toggleTrackingSwitch.isEnabled = PermissionManager.shared.isPremium
    }
}
