//
//  ManualScreenViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenViewController: UICollectionViewController {
    
    private var longPress: UILongPressGestureRecognizer?
    private(set) var viewModels: [ManualScreenItemViewModel]
    weak var delegate: ManualScreenerItemUpdatable?
    
    var section: Int?
    
    // MARK: - Initializer
    
    init(manualScreenItemViewModels: [ManualScreenItemViewModel]) {
        self.viewModels = manualScreenItemViewModels
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.register(ManualScreenItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: "screenerOption")
        collectionView.register(ManualScreenSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "sectionHeaderID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLongPress()
    }
    
    func setupLongPress() {
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress?.minimumPressDuration = 0.25
        collectionView.addGestureRecognizer(longPress!)
    }
    
    // MARK: - Navigation
    
    func presentManualSearchItemUpdaterVC(for screenerItem: ManualScreenItem,at selectedIndexPath: IndexPath) {
        let updaterVC = ManualScreenerItemUpdateViewController(selectedIndexPath: selectedIndexPath, screenerItem: screenerItem)
        updaterVC.delegate = self
        updaterVC.modalPresentationStyle = .overCurrentContext
        
        tabBarController?.present(updaterVC, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
    
        let point = gesture.location(in: collectionView)
        
        if let selectedIndexPath = collectionView.indexPathForItem(at: point) {
            let viewModel = viewModels[selectedIndexPath.item]
            let screenerDescriptionVC = ScreenerDescriptionViewController()
            screenerDescriptionVC.modalPresentationStyle = .overCurrentContext
            screenerDescriptionVC.equation = viewModel.manualScreenItem.criteria.equation
            screenerDescriptionVC.titleString = viewModel.manualScreenItem.criteria.explicit
            screenerDescriptionVC.descriptionString = viewModel.manualScreenItem.criteria.definition
            
            Vibration.light.vibrate()
            
            tabBarController?.present(screenerDescriptionVC, animated: true, completion: nil)
        }
    }
}

extension ManualScreenViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenerOption",
                                                      for: indexPath) as? ManualScreenItemCollectionViewCell
        let viewModel: ManualScreenItemViewModel = viewModels[indexPath.row]
        cell?.viewModel = viewModel
        
        cell?.handleCancelTap = { [unowned self] in
            guard let section = self.section else { return }
            viewModel.resetParameter()

            self.delegate?.didDelete(at: IndexPath(row: indexPath.row, section: section))
            
            collectionView.reloadItems(at: [indexPath])
        }

        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manualScreenItem = viewModels[indexPath.row].manualScreenItem
        presentManualSearchItemUpdaterVC(for: manualScreenItem, at: indexPath)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15, animations: {
            cell?.transform = .identity
        }) { (_) in
            cell?.isSelected = false
        }
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

extension ManualScreenViewController: ManualScreenItemUpdaterDelegate {
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath) {
        guard let section = section else { return }

        viewModels[indexPath.row] = manualScreenItemViewModel
        delegate?.didUpdate(manualScreenItemViewModel: manualScreenItemViewModel,
                            at: IndexPath(row: indexPath.row, section: section))
    
        collectionView.reloadItems(at: [indexPath])
    }
}
