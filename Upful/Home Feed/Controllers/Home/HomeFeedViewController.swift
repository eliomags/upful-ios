//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import GoogleMobileAds
import UIKit

class HomeFeedViewController: UIViewController, GADBannerViewDelegate, HomeFeedNavigationDelegate {

    // MARK:- Dependencies
    
    let analyticsLogger: AnalyticsLogger
    var homeFeedItems: [[FeedItem]] = []
    
    
    // MARK:- Views
    
    lazy var stateView: HomeFeedStateView = {
        let v = HomeFeedStateView()
        v.delegate = self
        return v
    }()
    
    lazy var quickSearchTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .backgroundColor
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.tableFooterView = UIView()
        tv.tableHeaderView = UIView()
        return tv
    }()
    
    let manualTableVC = SearchCriteriaTableViewController(style: .grouped)
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        bannerView.backgroundColor = .clear
        return bannerView
    }()
    
    
    // MARK:- Initializer Methods
    
    init(analyitcs: AnalyticsLogger) {
        self.analyticsLogger = analyitcs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureNavBar()
        setupViews()
        setupTableView(for: quickSearchTableView)
        setupBannerView()
        initializeFeedData()
        initializePopularCompanyData()
        AppStoreReviewHelper.checkAndAskForReview(checkType: .newSession)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: -
    
    fileprivate func initializeFeedData() {
        let presetViewModel = PresetScreenverViewModel()
        homeFeedItems.append(CompanyViewModel.configureCompanyList())
        homeFeedItems.append(presetViewModel.configureValueData())
        homeFeedItems.append(presetViewModel.configureGrowthData())
        homeFeedItems.append(presetViewModel.configureDividendData())
    }
    
    fileprivate func initializePopularCompanyData() {
        CompanyViewModel.configureCompanyList().forEach { (popularCompany) in
            NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .marketcap, frequency: .recent, completion: { (result) in
                switch result {
                case .success(let downloadedData):
                    if downloadedData.isEmpty { return }
                    DispatchQueue.main.async {
                        popularCompany.marketcap = Int(downloadedData.first?.value ?? 0)
                        self.quickSearchTableView.reloadData()
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
                        self.quickSearchTableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
    
    
    // MARK:- View Setup
    
    fileprivate func setupTableView(for tableView: UIView) {
        view.insertSubview(tableView, at: 0)
        tableView.anchor(
            top: stateView.layoutMarginsGuide.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Upful"
        navigationController!.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController!.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    // MARK:- Setup Banner View
    
    fileprivate func setupViews() {
        view.addSubview(stateView)
        stateView.anchor(
            top: view.layoutMarginsGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 50))
    }
    
    func setupBannerView() {
        addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.layoutMarginsGuide.bottomAnchor,
                          trailing: view.trailingAnchor,
                          size: CGSize(width: 0, height: 0))
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            bannerView.alpha = 1
            bannerView.frame = CGRect(x: 0, y: 0, width: bannerView.intrinsicContentSize.width, height: bannerView.intrinsicContentSize.height)
        })
    }
    
    
    // MARK:- Navigation
    
    func navigateToScreenerResults(searchParameters: [String]) {
        analyticsLogger.reportEvents(event: .screenForStocks(screenType: .quick))
        
        let searchResultVC = ScreenResultsViewController(searchParameters: searchParameters, networkingAPI: IntrinioAPI())
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    func navigateToDetails(popularCompany ticker: String, companyName: String) {
        let detailsVC = StockDetailsViewController(ticker: ticker, companyName: companyName, intrinioApi: IntrinioAPI(), analyticsLogger: AnalyticsLogger())
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

extension HomeFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default: return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeFeedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 0:
            let companyCell = PopularCompanyTableViewCell(popularCompanies: homeFeedItems[indexPath.section] as! [PopularCompany])
            companyCell.delegate = self
            return companyCell
        case 1,2,3:
            guard let screenerData = homeFeedItems[indexPath.section] as? [PresetScreener] else { return emptyCell }
            let screenerCell = PresetScreenerTableViewCell(searches: screenerData)
            screenerCell.delegate = self
            return screenerCell
        default:
            return emptyCell
        }
    }
}

extension HomeFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1,2,3: return 210
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == homeFeedItems.count - 1 {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderLabel(padding: 16)
        let labelText = [
            "POPULAR COMPANIES",
            "EXPLORE VALUE STOCKS",
            "EXPLORE GROWTH STOCKS",
            "EXPLORE DIVIDEND STOCKS"
        ]
        header.text = labelText[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == homeFeedItems.count - 1 {
            return 50
        } else {
            return 25
        }
    }
}

extension HomeFeedViewController: HomeFeedStateDelegate {
    
    func configureQuickSearch() {
        manualTableVC.remove()
        setupTableView(for: quickSearchTableView)
        quickSearchTableView.reloadData()
    }
    
    func configureManualSearch() {
        quickSearchTableView.removeFromSuperview()
        self.add(manualTableVC)
        setupTableView(for: manualTableVC.view)
    }
}




