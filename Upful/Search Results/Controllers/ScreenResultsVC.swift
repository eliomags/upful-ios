//
//  ScreenResultsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ScreenResultsViewController: UIViewController {
    
    // MARK:- Dependencies
    
    let searchParameters: [String]

    
    // MARK:- DataSource
    
    var searchResults: [SearchResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.feedTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Views
    
    lazy var feedTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    
    // MARK:- Initializer Methods
    
    init(searchParameters: [String]) {
        self.searchParameters = searchParameters
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        fetchTableData(parameters: searchParameters)
        
        view.addSubview(feedTableView)
        feedTableView.fillSuperview()
    }

    
    // MARK:- Fileprivate Functions
    
    fileprivate func fetchTableData(parameters: [String]) {
        var searchKeys = ""
        parameters.forEach { (parameter) in
            searchKeys += "\(parameter),"
        }
        NetworkService.shared.intrioAPI.getScreenRequest(parameters: searchKeys) { (result) in
            switch result {
            case .success(let fetchedData):
                self.searchResults = fetchedData
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScreenResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.text = searchResults[indexPath.item].ticker!
        cell.detailTextLabel?.text = String(searchResults[indexPath.item].marketcap ?? 0)
        return cell
    }
    
}


class CompanyOverviewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



