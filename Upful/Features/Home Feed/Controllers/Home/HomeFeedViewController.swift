//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import GoogleMobileAds
import UIKit

class HomeFeedViewController: UITableViewController, HomeFeedNavigationDelegate, MenuBarDisplayable {
    var delegate: MenuViewItemDelegate?
    
    var menubarTitle: String = "Quick Search"
    

    // MARK: - Dependencies
    
    let analyticsLogger: AnalyticsLogger
    let presetFeedDataLoader: PresetFeedDataLoader

    var homeFeedItems: [[Any]] = []
    
    
    // MARK: - Initializer Methods
    
    init(analyitcs: AnalyticsLogger, presetDataLoader: PresetFeedDataLoader) {
        self.analyticsLogger = analyitcs
        self.presetFeedDataLoader = presetDataLoader
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()

        initializeFeedData()
        initializePopularCompanyData()
    }
    
    
    // MARK: - Data Setup
    
    fileprivate func initializeFeedData() {
        homeFeedItems.append(presetFeedDataLoader.configureCompanyList())
        homeFeedItems.append(presetFeedDataLoader.configureValueData())
        homeFeedItems.append(presetFeedDataLoader.configureGrowthData())
        homeFeedItems.append(presetFeedDataLoader.configureDividendData())
    }
    
    fileprivate func initializePopularCompanyData() {
        CompanyViewModel.configureCompanyList().forEach { (popularCompany) in
            NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .marketcap, frequency: .recent, completion: { (result) in
                switch result {
                case .success(let downloadedData):
                    if downloadedData.isEmpty { return }
                    DispatchQueue.main.async {
                        popularCompany.marketcap = Int(downloadedData.first?.value ?? 0)
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
            
            NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .pricetoearnings, frequency: .recent, completion: { (result) in
                switch result {
                case .success(let downloadedData):
                    if downloadedData.isEmpty { return }
                    DispatchQueue.main.async {
                        popularCompany.priceToEarnings = downloadedData.first?.value
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
    
    
    // MARK: - Delegate Methods
    
    func navigateToScreenerResults(searchParameters: [String]) {
        analyticsLogger.reportEvents(event: .screenForStocks(screenType: .quick))
        let searchResultVC = ScreenResultsViewController(searchParameters: searchParameters, networkingAPI: IntrinioAPI())
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    func navigateToDetails(popularCompany ticker: String, companyName: String) {
        let detailVC = StockDetailsContainerView(ticker: ticker, companyName: companyName)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension HomeFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default: return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return homeFeedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 0:
            let companyCell = PopularCompanyTableViewCell(popularCompanies: homeFeedItems[indexPath.section] as! [PopularCompany])
            companyCell.delegate = self
            
            return companyCell
        case 1,2,3:
            guard let screenerData = homeFeedItems[indexPath.section] as? [PresetScreenerViewModel] else { return emptyCell }
            let screenerCell = PresetScreenerTableViewCell(searches: screenerData)
            screenerCell.delegate = self
            
            return screenerCell
        default:
            return emptyCell
        }
    }
}

extension HomeFeedViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1,2,3: return UIScreen.main.bounds.height/6 + 30
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == homeFeedItems.count - 1 {
            return UIView()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let header = SectionHeaderLabel(padding: 16)
        view.addSubview(header)
        header.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 4, right: 18))
        let labelText = [
            "POPULAR COMPANIES",
            "EXPLORE VALUE STOCKS",
            "EXPLORE GROWTH STOCKS",
            "EXPLORE DIVIDEND STOCKS"
        ]
        header.text = labelText[section]
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 100 }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == homeFeedItems.count - 1 {
            return 80
        } else {
            return 25
        }
    }
}





