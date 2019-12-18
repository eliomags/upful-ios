//
//  SavedScreenersViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedScreenerViewController: UIViewController, MenuBarDisplayable {
    var delegate: MenuViewItemDelegate?
    var menubarTitle: String = "Screeners"
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.backgroundColor = VersionManager.mainContainerBackground()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
}
