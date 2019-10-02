//
//  SubscriptionDetailsCollectionView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SubscriptionFeatureDataSource: class {
    var subscriptionOfferings: [SubscriptionFeatureViewModel] { get set }
}

class SubscriptionDetailsCollectionView: UICollectionViewController {
    
    var dataSource: SubscriptionFeatureDataSource?
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = dataSource?.subscriptionOfferings.count ?? 1
        control.currentPage = 0
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
    }
    

    // MARK: - View Setup
    
    fileprivate func setupCollectionView() {
        collectionView.register(SubscriptionOfferingCell.self, forCellWithReuseIdentifier: "infocell")
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.itemSize = collectionView.bounds.size
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumInteritemSpacing = 0
            flowlayout.minimumLineSpacing = 0
            flowlayout.sectionInset = .zero
        }
    }
    
    fileprivate func setupPageControl() {
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 7).isActive = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.subscriptionOfferings.count ?? 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infocell", for: indexPath) as? SubscriptionOfferingCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .clear
        cell.offeringImageView.image = dataSource?.subscriptionOfferings[indexPath.item].image
        cell.offeringTitleLabel.text = dataSource?.subscriptionOfferings[indexPath.item].title
        cell.offeringDescriptionLabel.text = dataSource?.subscriptionOfferings[indexPath.item].description
        return cell
    }
}

