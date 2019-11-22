//
//  PopularCompanyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PopularCompanyViewController: UIViewController {
    private enum ReuseID: String {
        case companyCell
        case emptyCell
    }
    
    // MARK: - Dependencies
    
    let viewModel: PopularCompanyViewModel
    
    fileprivate func bindToViewModel() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.sendUpdates = { [weak self] (_) in
                self?.popularCompanyCollectionView.reloadData()
           }
        }
    }
                
    // MARK: - Views
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 12)
        layout.itemSize = CGSize(width: 170, height: 90)
        return layout
    }()
    
    lazy var popularCompanyCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(GenericCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.companyCell.rawValue)
        cv.register(EmptyStockSuggestionCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.emptyCell.rawValue)
        return cv
    }()

    // MARK: - Initializer
    
    init(viewModel: PopularCompanyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViews()
        bindToViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initialFetch()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(popularCompanyCollectionView)
        popularCompanyCollectionView.fillSuperview()
    }
    
}

extension PopularCompanyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.state == .loading { return 6 }
        return viewModel.popularCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell.rawValue, for: indexPath) as? GenericCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.setLoadingLabels()
            return cell
        case .loaded:
            let data = viewModel.popularCompanies[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell.rawValue, for: indexPath) as? GenericCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.setLoadedLabels()
            cell.configureLabels(company: data)
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .popular))
        let detailVC = StockDetailsContainerView(ticker: viewModel.popularCompanies[indexPath.item].header,
                                                 companyName: viewModel.popularCompanies[indexPath.item].details ?? "")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if viewModel.state == .loaded { return true }
        else { return false }
    }
}

