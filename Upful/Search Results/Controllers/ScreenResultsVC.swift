//
//  ScreenResultsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import GoogleMobileAds
import UIKit

class BannerAdTableViewCell: UITableViewCell {
    
}

class ScreenResultsViewController: UIViewController, GADBannerViewDelegate {
    
    // MARK: - Dependencies
    
    let searchParameters: [String]

    
    // MARK: - DataSource
    
    var searchResults = [AnyObject]()
    
    struct ReuseId {
        static let resultsCellID = "resultsCellID"
        static let bannerAdCell = "BannerViewCell"
    }
    
    
    // MARK: Banner Ad Setup
    
    var adsToLoad = [GADBannerView]()
    var loadStateForAds = [GADBannerView: Bool]()
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    let adInterval = 8
    let adViewHeight = CGFloat(100)
    
    
    // MARK: - State
    
    private var dataPage = 1
    private var isLoadingData = false
    
    
    // MARK: - Views
    
    lazy var feedTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.register(ResultsTableViewCell.self, forCellReuseIdentifier: ReuseId.resultsCellID)
        tv.register(BannerAdTableViewCell.self, forCellReuseIdentifier: ReuseId.bannerAdCell)
        return tv
    }()
    
    let loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.startAnimating()
        v.addSubview(activityView)
        activityView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 30, left: 30, bottom: 30, right: 30))
        v.layer.cornerRadius = 15
        v.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return v
    }()

    
    // MARK: - Initializer Methods
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    
    // MARK: - GADBannerView delegate methods
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        loadStateForAds[bannerView] = true
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ad:", error.localizedDescription)
        preloadNextAd()
    }
    
    /// Adds banner ads to the tableViewItems list.
    func addBannerAds() {
        var index = adInterval
        // Ensure subview layout has been performed before accessing subview sizes.
        feedTableView.layoutIfNeeded()
        while index < searchResults.count {
            let adSize = GADAdSizeFromCGSize(
                CGSize(width: feedTableView.contentSize.width, height: adViewHeight))
            let adView = GADBannerView(adSize: adSize)
            adView.adUnitID = adUnitID
            adView.rootViewController = self
            adView.delegate = self
            
            searchResults.insert(adView, at: index)
            adsToLoad.append(adView)
            loadStateForAds[adView] = false
            index += adInterval
        }
    }
    
    /// Preload banner ads sequentially. Dequeue and load next ad from `adsToLoad` list.
    func preloadNextAd() {
        if !adsToLoad.isEmpty {
            let ad = adsToLoad.removeFirst()
            let adRequest = GADRequest()
            adRequest.testDevices = [ kGADSimulatorID ]
            ad.load(adRequest)
        }
    }
    

    // MARK: - Fileprivate Functions
    
    fileprivate func fetchTableData(parameters: [String]) {
        var searchKeys = ""
        parameters.forEach { (parameter) in
            searchKeys += "\(parameter),"
        }
        NetworkService.shared.intrioAPI.getScreenRequest(parameters: searchKeys, page: dataPage) { (result) in
            switch result {
            case .success(let fetchedData):
                self.searchResults.append(contentsOf: fetchedData)
                self.fetchCompanyFinancialData()
                self.isLoadingData = false
                DispatchQueue.main.async {
                    self.addBannerAds()
                    self.preloadNextAd()
                    self.showActivitySpinner(!fetchedData.isEmpty)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.feedTableView.setEmptyView(state: .errorState)
                }
            }
        }
        dataPage += 1
    }
    
    fileprivate func getEbitData(_ searchResult: ScreenResult) {
        NetworkService.shared.intrioAPI.getCompanyFinancials(ticker: searchResult.ticker ?? "", financial: SearchCriteria.ebitgrowth.rawValue, completion: { (result) in
            switch result {
            case .success(let downloadedData):
                DispatchQueue.main.async {
                    searchResult.ebitgrowth = downloadedData.first?.value
                    self.feedTableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    fileprivate func getPriceToEarningsData(_ searchResult: ScreenResult) {
        NetworkService.shared.intrioAPI.getCompanyFinancials(ticker: searchResult.ticker ?? "", financial: SearchCriteria.pricetoearnings.rawValue, completion: { (result) in
            switch result {
            case .success(let downloadedData):
                guard !downloadedData.isEmpty else { return }
                DispatchQueue.main.async {
                    searchResult.pricetoearnings = downloadedData.first?.value
                    self.feedTableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    fileprivate func getDividendYieldData(_ searchResult: ScreenResult) {
        NetworkService.shared.intrioAPI.getCompanyFinancials(ticker: searchResult.ticker ?? "", financial: SearchCriteria.dividendyield.rawValue, completion: { (result) in
            switch result {
            case .success(let downloadedData):
                guard !downloadedData.isEmpty else { return }
                DispatchQueue.main.async {
                    searchResult.divyield = downloadedData.first?.value
                    self.feedTableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    fileprivate func fetchCompanyFinancialData() {
        guard !searchResults.isEmpty else {
            DispatchQueue.main.async {
                self.feedTableView.setEmptyView(state: .emptyState)
            }
            return
        }
        
        searchResults.forEach { (searchResult) in
            if let searchResult = searchResult as? ScreenResult {
                getDividendYieldData(searchResult)
                getPriceToEarningsData(searchResult)
                getEbitData(searchResult)
            }
        }
    }
    
    fileprivate func setupNavBar() {
        self.title = "Search Results"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScreenResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showActivitySpinner(searchResults.isEmpty)
        tableView.isScrollEnabled = !searchResults.isEmpty
        
        if searchResults.isEmpty {
            tableView.separatorStyle = .none
        }
        if !searchResults.isEmpty {
            tableView.restore()
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? ResultsTableViewCell else { return UITableViewCell() }
        if let screenResult = searchResults[indexPath.item] as? ScreenResult {
            guard let ticker = screenResult.ticker else { return resultsCell }
            resultsCell.companyTickerLabel.text = ticker
            resultsCell.companyNameLabel.text = screenResult.name
            resultsCell.marketcapStackView.valueLabel.text = "$\(screenResult.marketcap?.formatUsingAbbreviation() ?? " -")"
            resultsCell.pricetoearningsStackView.valueLabel.text = "\(screenResult.pricetoearnings?.twoDecimal() ?? "-")"
            resultsCell.dividendyieldStackView.valueLabel.text = "\(screenResult.divyield?.convertToPercent() ?? "-")%"
            resultsCell.ebitgrowthStackView.valueLabel.text = "\(screenResult.ebitgrowth?.convertToPercent() ?? "-")%"
        }
        
        if let bannerView = searchResults[indexPath.item] as? GADBannerView {
            let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.bannerAdCell, for: indexPath)
            
            for subview in reusableAdCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            reusableAdCell.contentView.addSubview(bannerView)
            bannerView.fillSuperview()
            
            return reusableAdCell
        }
        
        
        return resultsCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = searchResults.count - 1
        if !isLoadingData && indexPath.row == lastElement {
            fetchTableData(parameters: searchParameters)
            isLoadingData = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(StockDetailsViewController(), animated: true)
    }
}

extension ScreenResultsViewController {
    func showActivitySpinner(_ shouldShowSpinner: Bool) {
        
        if shouldShowSpinner {
            self.view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: feedTableView.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: feedTableView.centerYAnchor).isActive = true
        }
        if !shouldShowSpinner {
            loadingView.removeFromSuperview()
        }
    }
}

