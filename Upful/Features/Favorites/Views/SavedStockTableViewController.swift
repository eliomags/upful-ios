//
//  SavedStockCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/23/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SavedStockDelegate: class {
    var savedStocks: [SavedStock] { get set }
    func removeSavedCompany(index: IndexPath)
}

class CustomSizeTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
}

class SavedStockTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SavedStockDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tvcell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.separatorStyle = .singleLine
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.savedStocks.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tvcell")
        cell.textLabel?.text = delegate?.savedStocks[indexPath.item].ticker
        cell.detailTextLabel?.text = delegate?.savedStocks[indexPath.item].companyName
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}









