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
    let intrinioAPI: IntrinioAPI
    
    
    // MARK:- State
    
    private(set) var isLoading: Bool = false {
        didSet {
            observeStateChanges(isLoading)
        }
    }
    
    private func observeStateChanges(_ state: Bool) {
        self.showActivitySpinner(state)
    }
    

    // MARK: - DataSource
    
    var searchResults = [AnyObject]() {
        didSet {
            DispatchQueue.main.async {
                self.feedTableView.reloadData()
            }
        }
    }
    
    struct ReuseId {
        static let resultsCellID = "resultsCellID"
        static let bannerAdCell = "BannerViewCell"
    }
    
    
    // MARK: Banner Ad Setup
    
    var adsToLoad = [GADBannerView]()
    var loadStateForAds = [GADBannerView: Bool]()
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    var adInterval = 12
    let adViewHeight = CGFloat(100)
    
    
    // MARK: - Views
    
    lazy var feedTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.register(ResultsTableViewCell.self, forCellReuseIdentifier: ReuseId.resultsCellID)
        tv.register(BannerAdTableViewCell.self, forCellReuseIdentifier: ReuseId.bannerAdCell)
        return tv
    }()
    
    var loadingView: UIView = {
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
    
    let sortButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Sort", for: .normal)
        return b
    }()

    
    // MARK: - Initializer Methods
    
    init(searchParameters: [String], networkingAPI: IntrinioAPI) {
        self.searchParameters = searchParameters
        self.intrinioAPI = networkingAPI
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        fetchTableData(parameters: searchParameters, fetchType: .initial)
        view.addSubview(feedTableView)
        feedTableView.fillSuperview()
        isLoading = true
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
        let index = adInterval
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
            adInterval += 12
            return
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
    
    private enum FetchType {
        case initial, appending
    }
    
    private func fetchTableData(parameters: [String], fetchType: FetchType) {
        var searchKeys = ""
        parameters.forEach { (parameter) in
            searchKeys += "\(parameter),"
        }
        intrinioAPI.performStockScreening(parameters: searchKeys) { (result) in
            switch result {
            case .success(let fetchedData):
                switch fetchType {
                case .initial: self.searchResults = fetchedData
                case .appending: self.searchResults.append(contentsOf: fetchedData)
                }
                self.fetchCompanyFinancialData(searchResults: fetchedData)
                self.isLoading = false
                DispatchQueue.main.async {
                    self.addBannerAds()
                    self.preloadNextAd()
                }
            case .failure(_):
                self.isLoading = false
                DispatchQueue.main.async {
                    self.feedTableView.setEmptyView(state: .errorState)
                }
            }
        }
    }
    
    private func getPriceToEarningsData(_ searchResult: Stock) {
        NetworkService.shared.intrioAPI.fetchStockSpecificFinancial(ticker: searchResult.ticker ?? "", financial: .pricetoearnings, frequency: .recent, completion: { (result) in
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
    
    private func fetchCompanyFinancialData(searchResults: [Stock]) {
        guard !searchResults.isEmpty else {
            DispatchQueue.main.async { self.feedTableView.setEmptyView(state: .emptyState(message: "No data to display.")) }
            return
        }
        searchResults.forEach { (searchResult) in
            getPriceToEarningsData(searchResult)
        }
    }
    
    fileprivate func setupNavBar() {
        sortButton.addTarget(self, action: #selector(handleSortTap), for: .touchUpInside)
        self.title = "Search Results"
        navigationController?.navigationBar.prefersLargeTitles = true
        let sortButton = UIBarButtonItem(customView: self.sortButton)
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    // MARK: - Actions
    
    @objc private func handleSortTap(_ sender: UIButton) {
        intrinioAPI.screenPage = 1
        let sortMenu = UIAlertController(title: nil, message: "Choose Sort", preferredStyle: .actionSheet)
        
        let marketCapAscAction = UIAlertAction(title: "Market Cap Ascending", style: .default, handler: { _ in
            self.intrinioAPI.sortDirection = .asc
            self.feedTableView.reloadData()
            self.fetchTableData(parameters: self.searchParameters, fetchType: .initial)
        })
        let marketCapDescAction = UIAlertAction(title: "Market Cap Descending", style: .default, handler: { _ in
            self.intrinioAPI.sortDirection = .desc
            self.feedTableView.reloadData()
            self.fetchTableData(parameters: self.searchParameters, fetchType: .initial)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [marketCapAscAction, marketCapDescAction, cancelAction].forEach { (action) in
            sortMenu.addAction(action)
        }
        self.present(sortMenu, animated: true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScreenResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isScrollEnabled = !searchResults.isEmpty
        if searchResults.isEmpty { tableView.separatorStyle = .none }
        if !searchResults.isEmpty { tableView.restore() }
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultsCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.resultsCellID) as? ResultsTableViewCell else { return UITableViewCell() }
        
        if let screenResult = searchResults[indexPath.item] as? Stock {
            guard let ticker = screenResult.ticker else { return resultsCell }
            resultsCell.companyTickerLabel.text = ticker
            resultsCell.companyNameLabel.text = screenResult.name
            resultsCell.marketcapStackView.valueLabel.text = "$\(screenResult.marketcap?.formatUsingAbbreviation() ?? " -")"
            resultsCell.pricetoearningsStackView.valueLabel.text = "\(screenResult.pricetoearnings?.twoDecimal() ?? "-")"
        }
        
        if let bannerView = searchResults[indexPath.item] as? GADBannerView {
            let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: ReuseId.bannerAdCell, for: indexPath)
            for subview in reusableAdCell.contentView.subviews { subview.removeFromSuperview() }
            reusableAdCell.contentView.addSubview(bannerView)
            bannerView.fillSuperview()
            return reusableAdCell
        }
        
        return resultsCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = searchResults.count - 1
        if !isLoading && indexPath.row == lastElement && lastElement > 8 {
            fetchTableData(parameters: searchParameters, fetchType: .appending)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCompany = searchResults[indexPath.item] as? Stock {
            self.navigationController?.pushViewController(StockDetailsViewController(ticker: selectedCompany.ticker ?? "", companyName: selectedCompany.name ?? "", intrinioApi: IntrinioAPI(), analyticsLogger: AnalyticsLogger()), animated: true)
        }
    }
}

extension ScreenResultsViewController {
    func showActivitySpinner(_ shouldShowSpinner: Bool) {
        if shouldShowSpinner {
            self.view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        if !shouldShowSpinner {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
            }
        }
    }
}

