//
//  MenuViewContainer.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol MenubarContainerProtocol {
    var menubarControllers: [UIViewController] { get }
}

class MenuContainerViewController: UICollectionViewController, MenuBarViewDelegate, MenuViewItemDelegate, MenubarContainerProtocol {
    private struct Constants {
        static let cell1 = "cell1"
    }
    
    // TODO: - Inject ViewControllers
    var menubarControllers: [UIViewController] {
        return []
    }
    
    // MARK: - Views
    
    lazy var menuBarView: MenuBarView = {
        let menubarTitles = menubarControllers.map({ $0.title ?? "" })
        let view = MenuBarView(menuTitles: menubarTitles)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Initializer Functions
    
    override init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Life Cycle Functions
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        view.addSubview(menuBarView)
        menuBarView.anchor(top: view.layoutMarginsGuide.topAnchor,
                           leading: view.leadingAnchor, bottom: nil,
                           trailing: view.trailingAnchor)
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - View Set Up

    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: menuBarView.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.cell1)
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
            flowlayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Delegate Methods
    
    /// Menubar Methods
    /// Navigates to the designated child tableView based on the selected item index of the segmented control
    func didSelectIndex(at index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    /// Methods for hiding and presenting the menu bar when the child tableView has scrolled.
    /// We will check if the view is already animated before animating to improve performance.
    private var isMenuBarVisible = true
    
    func hideMenuBar() {
        if isMenuBarVisible == true {
            UIView.animate(withDuration: 0.2) {
                self.menuBarView.transform = CGAffineTransform(translationX: 0, y: -self.menuBarView.bounds.height)
            }
            isMenuBarVisible = !isMenuBarVisible
        }
    }

    func presentMenuBar() {
        if isMenuBarVisible == false {
            UIView.animate(withDuration: 0.2) {
                self.menuBarView.transform = .identity
            }
            isMenuBarVisible = !isMenuBarVisible
        }
    }
    
    // MARK: - ScrollView Delegate Methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDistance = scrollView.contentOffset.x
        menuBarView.placementViewLeadingConstraint = scrollDistance
        view.endEditing(true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetInt = targetContentOffset.move().x / menuBarView.frame.width
        menuBarView.setIndex(Int(targetInt))
//        presentMenuBar()
    }
}

extension MenuContainerViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menubarControllers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageIndex = indexPath.row
        let displayableCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cell1, for: indexPath)
        for i in 0..<menubarControllers.count {
            if i == indexPath.row {
                display(contentController: menubarControllers[pageIndex], on: displayableCell)
                return displayableCell
            }
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        menuBarView.setIndex(indexPath.row)
    }
}

extension MenuContainerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}












