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
    
    struct ReuseId {
        static let resultsCellID = "resultsCellID"
    }
    
    var searchResults: [ScreenResult] = [] {
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
        feedTableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: ReuseId.resultsCellID)
        
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
                self.setupData()
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
    
    fileprivate func setupData() {
        searchResults.forEach { (searchResult) in
            guard let ticker = searchResult.ticker else { return }
            NetworkService.shared.intrioAPI.getCompanyData(ticker: ticker, completion: { (result) in
                switch result {
                case .success(let downloadedData):
                    downloadedData.standardizedFinancials.forEach({ (financial) in
                        DispatchQueue.main.async {
                            if financial.dataTag.tag == SearchCriteria.pricetoearnings.rawValue {
                                searchResult.pricetoearnings = financial.value
                            }
                            if financial.dataTag.tag == SearchCriteria.dividendyield.rawValue {
                                searchResult.divyield = financial.value
                            }
                            if financial.dataTag.tag == SearchCriteria.ebitgrowth.rawValue {
                                searchResult.ebitgrowth = financial.value
                            }
                        }
                    })
                case .failure(_):
                    break
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? ResultsTableViewCell else { return UITableViewCell() }
//        let cell = ResultsTableViewCell(style: .value1, reuseIdentifier: nil)
        
        guard let ticker = searchResults[indexPath.item].ticker else { return resultsCell }
        resultsCell.companyTickerLabel.text = ticker
        resultsCell.companyNameLabel.text = searchResults[indexPath.item].name
        resultsCell.marketcapStackView.valueLabel.text = "$\(searchResults[indexPath.item].marketcap?.formatUsingAbbreviation() ?? " -")"
        resultsCell.pricetoearningsStackView.valueLabel.text = "\(searchResults[indexPath.item].pricetoearnings?.twoDecimal() ?? "-")"
        resultsCell.dividendyieldStackView.valueLabel.text = "\(searchResults[indexPath.item].divyield?.convertToPercent() ?? "-")%"
        resultsCell.ebitgrowthStackView.valueLabel.text = "\(searchResults[indexPath.item].ebitgrowth?.convertToPercent() ?? "-")%"

        return resultsCell
    }
    
}



