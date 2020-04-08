//
//  ManualScreenViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenViewController: UICollectionViewController {
    
    private var viewModels: [ManualScreenItemViewModel] = []
    
    // MARK: - Initializer
    
    override init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
        title = "Custom"
        collectionView.register(ManualScreenItemCollectionViewCell.self, forCellWithReuseIdentifier: "screenerOption")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModels()
    }
    
    // MARK: - View Configuration
    
    fileprivate func configureViewModels() {
        viewModels = SearchCriteria.allCases
            .sorted(by: { $0.classification.rawValue < $1.classification.rawValue })
            .filter({ $0.classification != .other })
            .map { ManualScreenItem(criteria: $0) }
            .map { ManualScreenItemViewModel(manualScreenItem: $0) }
    }
}

extension ManualScreenViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CriteriaClassification.valuation.rawValue:
            return SearchCriteria.allCases.filter { $0.classification == .valuation }.count
            
        case CriteriaClassification.financial.rawValue:
            return SearchCriteria.allCases.filter { $0.classification == .financial }.count
            
        case CriteriaClassification.performance.rawValue:
            return SearchCriteria.allCases.filter { $0.classification == .performance }.count
            
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenerOption", for: indexPath) as? ManualScreenItemCollectionViewCell
        let viewModel: ManualScreenItemViewModel
        
        switch indexPath.section {
        case CriteriaClassification.valuation.rawValue:
            viewModel = viewModels
                .filter { $0.manualScreenItem.criteria.classification == .valuation }[indexPath.item]
            cell?.viewModel = viewModel
            
        case CriteriaClassification.financial.rawValue:
            viewModel = viewModels
                .filter { $0.manualScreenItem.criteria.classification == .financial }[indexPath.item]
            cell?.viewModel = viewModel
            
        case CriteriaClassification.performance.rawValue:
            viewModel = viewModels
                .filter { $0.manualScreenItem.criteria.classification == .performance }[indexPath.item]
            cell?.viewModel = viewModel
            
        default:
            break
        }
        
        return cell ?? UICollectionViewCell()
    }
}

extension ManualScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
