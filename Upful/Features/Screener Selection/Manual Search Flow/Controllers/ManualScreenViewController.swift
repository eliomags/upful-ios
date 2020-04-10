//
//  ManualScreenViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenViewController: UICollectionViewController {
    
    private var viewModels: [[ManualScreenItemViewModel]] = []
    
    // MARK: - Initializer
    
    override init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
        title = "Custom"
        collectionView.register(ManualScreenItemCollectionViewCell.self, forCellWithReuseIdentifier: "screenerOption")
        collectionView.register(ManualScreenSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeaderID")
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
        viewModels = [
            getViewModels(from: .valuation),
            getViewModels(from: .financial),
            getViewModels(from: .performance)
        ]
    }
    
    fileprivate func getViewModels(from classification: CriteriaClassification) -> [ManualScreenItemViewModel] {
        return SearchCriteria.allCases
            .filter({ $0.classification == classification })
            .map { ManualScreenItem(criteria: $0) }
            .map { ManualScreenItemViewModel(manualScreenItem: $0) }
    }
    
    // MARK: - Navigation
    
    func presentManualSearchItemUpdaterVC(for screenerItem: ManualScreenItem,at selectedIndexPath: IndexPath) {
        let updaterVC = NewManualScreenerItemUpdateViewController(selectedIndexPath: selectedIndexPath, screenerItem: screenerItem)
        updaterVC.delegate = self
        updaterVC.modalPresentationStyle = .overCurrentContext
        
        self.tabBarController?.present(updaterVC, animated: true, completion: nil)
    }
}

extension ManualScreenViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenerOption", for: indexPath) as? ManualScreenItemCollectionViewCell
        let viewModel: ManualScreenItemViewModel = viewModels[indexPath.section][indexPath.row]
        cell?.viewModel = viewModel
        cell?.handleCancelTap = {
            viewModel.resetParameter()
            collectionView.reloadItems(at: [indexPath])
        }

        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "sectionHeaderID",
                                                                             for: indexPath) as? ManualScreenSectionHeaderView
            switch indexPath.section {
            case CriteriaClassification.valuation.rawValue:
                headerView?.headerTextLabel.text = "Valuation"
                
            case CriteriaClassification.financial.rawValue:
                headerView?.headerTextLabel.text = "Financial"
                
            case CriteriaClassification.performance.rawValue:
                headerView?.headerTextLabel.text = "Performance"
            default:
                assertionFailure("Only Performance, Valuation and Financial options (3) allowed to be displayed.")
            }
            return headerView ?? UICollectionReusableView()
        }
        fatalError()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manualScreenItem = viewModels[indexPath.section][indexPath.row].manualScreenItem
        presentManualSearchItemUpdaterVC(for: manualScreenItem, at: indexPath)
    }
}

extension ManualScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
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

extension ManualScreenViewController: ManualScreenItemUpdaterDelegate {
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        viewModels[indexPath.section][indexPath.row] = manualScreenItemViewModel
        collectionView.reloadItems(at: [indexPath])
    }
}
