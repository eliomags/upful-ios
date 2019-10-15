//
//  SuggestionsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 10/14/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockSuggestionViewController: UIViewController {
    
    // MARK: - Dependencies
    
    let networkingAPI: IntrinioAPI
    let preferenceDataManager: PreferenceDataManager

    let dispatchGroup = DispatchGroup()
    
    enum ReuseID {
        static let companyCell = "companyCell"
        static let noResultsCell = "noResultsCell"
        static let noPreferencesCell = "noPreferencesCell"
    }
    
    // MARK: - State
    
    enum State {
        case pending
        case isLoading
        case loaded
        case noPreferencesSet
        case empty
    }
    
    var state: State = .pending {
        didSet {
            handleStateChange()
        }
    }
    
    var groupedPreferences: [[String]]
    var stockData: [Stock] = []

    
    // MARK: - Views
    
    lazy var layout: UICollectionViewFlowLayout = {
        let padding: CGFloat = 8
        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 2) - (2 * padding)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding + 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: (1 * padding), bottom: 4, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: 90)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PopularCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.companyCell)
        collectionView.register(EmptyStockSuggestionCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.noResultsCell)
        collectionView.register(AddPreferenceCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.noPreferencesCell)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Initializer Functions
        
    init(dataManager: PreferenceDataManager = .init(), networkingAPI: IntrinioAPI = .init()) {
        self.preferenceDataManager = dataManager
        self.networkingAPI = networkingAPI
        self.groupedPreferences = dataManager.getGroupedPreferences()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if preferenceDataManager.didUpdateData {
            hasNetworkingCompleted = false
            stockData.removeAll()
            setState()
        }
    }
    
    // MARK: - State Methods
    
    func setState() {
        if groupedPreferences.isEmpty {
            state = .noPreferencesSet
        } else {
            state = .isLoading
        }
    }
    
    func shuffleResults() {
        if stockData.count <= 4 { return }
        stockData.shuffle()
        let difference = stockData.count - 4
        stockData.removeLast(difference)
    }
    
    func checkForRecievedData() {
        if self.stockData.isEmpty {
            self.state = .empty
        } else {
            self.shuffleResults()
            self.state = .loaded
        }
    }
    
    func handleStateChange() {
        switch state {

        case .pending:
            break
            
        case .isLoading:
            fetchData()
            
            dispatchGroup.notify(queue: .main) {
                self.hasNetworkingCompleted = true
                self.checkForRecievedData()
            }
            
        case .loaded, .noPreferencesSet, .empty:
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    var hasNetworkingCompleted = false
    
    func fetchData() {
        guard groupedPreferences.count > 0 else { return }
        guard hasNetworkingCompleted == false else { return }
        
        for count in 0...groupedPreferences.count - 1 {
            dispatchGroup.enter()
            var searchKeys = ""
            groupedPreferences[count].forEach { (parameter) in
                searchKeys += "\(parameter),"
            }

            fetchStockData(parameter: searchKeys)
        }
    }

    private func fetchStockData(parameter: String) {
        networkingAPI.screenForPreferences(parameters: parameter) { (result) in
            switch result {
                
            case .success(let fetchedData):
                self.stockData.append(contentsOf: fetchedData)
                self.dispatchGroup.leave()
                
            case .failure(let error):
                switch error {
                case .urlError:
                    print("URL Error")
                default:
                    print(error.localizedDescription)
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    func navigateToStockDetails(ticker: String, name: String) {
        let detailsVC = StockDetailsContainerView(ticker: ticker, companyName: name)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

extension StockSuggestionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
            
        case .empty, .noPreferencesSet:
            return 1
            
        case .pending:
            return 2
        default:
            return stockData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
            
        case .pending, .isLoading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.companyNameLabel.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
            cell.tickerLabel.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
            cell.marketcapStackView.valueLabel.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
            cell.peStackView.valueLabel.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
            return cell
            
        case .loaded:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.companyNameLabel.text = stockData[indexPath.item].name
            cell.tickerLabel.text = stockData[indexPath.item].ticker
            cell.marketcapStackView.valueLabel.text = stockData[indexPath.item].marketcap?.formatUsingAbbreviation()
            cell.peStackView.valueLabel.text = (stockData[indexPath.item].pricetoearnings?.twoDecimal()) ?? "NA"
            return cell
            
        case .noPreferencesSet:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.noPreferencesCell, for: indexPath) as? AddPreferenceCollectionViewCell else { return UICollectionViewCell() }
            return cell
            
        case .empty:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.noResultsCell, for: indexPath) as? EmptyStockSuggestionCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch state {
            
        case .loaded:
            let data = stockData[indexPath.item]
            navigateToStockDetails(ticker: data.ticker!, name: data.name!)
            
        case .empty, .noPreferencesSet:
            let presenter = PreferencePresenter()
            presenter.present(in: self)
            
        default:
            break
        }
    }
}

extension StockSuggestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 2) - (3 * padding)
        switch state {
            
        case .noPreferencesSet, .empty:
            return collectionView.bounds.size

        default:
            return CGSize(width: itemWidth, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 8
        
        switch state {
            
        case .noPreferencesSet, .empty:
            return 0

        default:
            return padding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 8
        
        switch state {
            
        case .noPreferencesSet, .empty:
            return 0

        default:
            return padding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 8
        switch state {
            
        case .noPreferencesSet, .empty:
            return .zero

        default:
            return UIEdgeInsets(top: 0, left: (2.5 * padding), bottom: 4, right: padding)
        }
    }
}
