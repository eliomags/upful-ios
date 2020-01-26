//
//  MenuViewHeader.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol MenuBarViewDelegate: class {
    func selectedIndex(_ index: Int)
    func presentMenuBar()
    func hideMenuBar()
}

final class MenuBarView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 60)
    }
    private struct Constants {
        static let menuCellID = "menuCellID"
    }
    
    // MARK: - Dependencies
    
    let menuTitles: [String]
    weak var delegate: MenuBarViewDelegate?

    // MARK: - Views
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        let itemWidth = UIScreen.main.bounds.width/CGFloat(self.menuTitles.count)
        l.itemSize = CGSize(width: itemWidth, height: 60)
        l.sectionInset = UIEdgeInsets.zero
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        l.scrollDirection = .horizontal
        return l
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = VersionManager.mainContainerBackground()
        cv.register(MenuItemCell.self, forCellWithReuseIdentifier: Constants.menuCellID)
        cv.automaticallyAdjustsScrollIndicatorInsets = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var placementView: UIView = {
        let v = UIView()
        v.backgroundColor = .appAccent3
        return v
    }()
    
    var placementViewLeadingConstraint: CGFloat = 0 {
        didSet {
            let translationDistance = placementViewLeadingConstraint/CGFloat(self.menuTitles.count)
            placementView.transform = CGAffineTransform(translationX: translationDistance, y: 0)
        }
    }
    
    // MARK: - Initializer
    
    init(menuTitles: [String]) {
        self.menuTitles = menuTitles
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.menuTitles = []
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        
        let itemWidth = UIScreen.main.bounds.width/CGFloat(self.menuTitles.count)-50
        
        addSubview(placementView)
        placementView.anchor(top: nil, leading: leadingAnchor,
                             bottom: bottomAnchor, trailing: nil,
                             padding: .init(top: 0, left: 25, bottom: 0, right: 0),
                             size: .init(width: itemWidth, height: 1.5))
        
//        placementView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        placementView.widthAnchor.constraint(equalToConstant: itemWidth-15).isActive = true
//        placementView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - API
    
    func setIndex(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
}

    // MARK: - MenuBarViewController Methods

extension MenuBarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = menuTitles[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuCellID,
                                                      for: indexPath) as? MenuItemCell
        cell?.label.text = title
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedIndex(indexPath.row)
    }
}

private class MenuItemCell: UICollectionViewCell {
    let label: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .gray
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(label)
        label.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelected() : setDeSelected()
        }
    }
    
    func setSelected() {
        label.textColor = .appAccent3
    }
    
    func setDeSelected() {
        label.textColor = .gray
    }
}

