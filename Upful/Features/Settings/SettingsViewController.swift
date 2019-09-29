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
        ["Upgrade to Premium",
        "Restore Purchase"],
        ["Leave a Rating"],
        ["Leave a Suggestion",
        "Report an Issue"]
        ]
    
    

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
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = displayItems[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}
