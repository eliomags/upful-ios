//
//  ScreenerSelectionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 12/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class ScreenerSelectionViewController: UICollectionViewController, MenuBarDisplayable {
    
    // MARK: - Dependencies
    // Core data for knowing currently saved screeners based on name
    // Core data for saving screener
    // Firestore for loading screeners
    // Delegate for dismissing and passing values to home
    
    weak var menuViewItemDelegate: MenuViewItemDelegate?
    var menubarTitle: String = "Pre-built"
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 4, right: 12)
        layout.itemSize = CGSize(width: 170, height: 150)
        return layout
    }()
    
    
    // MARK: - Initializer
    
    init() {
        super.init(collectionViewLayout: self.layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupCollectionView() {
        collectionView.register(ScreenerPreviewCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleSaveTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // TODO: - Handle Saving/Deletion
        
    }
    
    // MARK: - Cell Creation
    
    fileprivate func makeScreenerCells(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ScreenerPreviewCollectionViewCell
        cell?.saveButton.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: - CollectionView Delegate/Datasource Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return makeScreenerCells(for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            let parentVC = self.parent as? ScreenerSelectionContainerView
            parentVC?.screenerSelectionDelegate?.didSelectScreener(searchParameters: [])
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = .identity
        }
    }
}
