//
//  SuggestionsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 10/14/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SuggestionDelegate: class {
    func reload()
}

class StockSuggestionViewController: UIViewController {
    
    // MARK: - Dependencies

    let dispatchGroup = DispatchGroup()
    
    enum ReuseID {
        static let companyCell = "companyCell"
        static let noResultsCell = "noResultsCell"
        static let noPreferencesCell = "noPreferencesCell"
    }
    
    // MARK: - View Model
    
    let viewModel: SuggestionViewModel!

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
        
    init(viewModel: SuggestionViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        bindViewModelStateChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setState()
    }
        
    // MARK: - View Updates
    
    func bindViewModelStateChanges() {
        viewModel.stateChanged = { [weak self] (newState) in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    func navigateToStockDetails(ticker: String, name: String) {
        let detailsVC = StockDetailsContainerView(ticker: ticker, companyName: name)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

extension StockSuggestionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.state {
            
        case .empty, .noPreferencesSet:
            return 1
            
        case .pending, .isLoading:
            return 4
            
        default:
            return viewModel.stockData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.state {
            
        case .pending, .isLoading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.companyNameLabel.backgroundColor = UIColor(white: 0.92, alpha: 0.8)
            cell.tickerLabel.backgroundColor = UIColor(white: 0.92, alpha: 0.8)
            cell.marketcapStackView.valueLabel.backgroundColor = UIColor(white: 0.92, alpha: 0.8)
            cell.peStackView.valueLabel.backgroundColor = UIColor(white: 0.92, alpha: 0.8)
            return cell
            
        case .loaded:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
            let data = viewModel.stockData[indexPath.item]
            cell.companyNameLabel.backgroundColor = .clear
            cell.tickerLabel.backgroundColor = .clear
            cell.marketcapStackView.valueLabel.backgroundColor = .clear
            cell.peStackView.valueLabel.backgroundColor = .clear
            cell.companyNameLabel.text = data.name
            cell.tickerLabel.text = data.ticker
            cell.marketcapStackView.valueLabel.text = data.marketcap?.formatUsingAbbreviation()
            cell.peStackView.valueLabel.text = (data.pricetoearnings?.twoDecimal()) ?? "NA"
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
        switch viewModel.state {
            
        case .loaded:
            let data = viewModel.stockData[indexPath.item]
            AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .preference))
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
        switch viewModel.state {
            
        case .noPreferencesSet, .empty:
            return collectionView.bounds.size

        default:
            return CGSize(width: itemWidth, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 8
        
        switch viewModel.state {
            
        case .noPreferencesSet, .empty:
            return 0

        default:
            return padding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 8
        
        switch viewModel.state {
            
        case .noPreferencesSet, .empty:
            return 0

        default:
            return padding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 8
        switch viewModel.state {
            
        case .noPreferencesSet, .empty:
            return .zero

        default:
            return UIEdgeInsets(top: 0, left: (2.5 * padding), bottom: 4, right: padding)
        }
    }
}
