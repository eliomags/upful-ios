//
//  PresetScreenerTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol HomeFeedNavigationDelegate: class {
    func navigateToScreenerResults(searchParameters: [String])
    func navigateToDetails(popularCompany ticker: String, companyName: String)
}

class PresetScreenerTableViewCell: UITableViewCell {
    
    weak var delegate: HomeFeedNavigationDelegate?
    
    let presetSearches: [PresetScreenerViewModel]
    
    private enum ReuseID: String {
        case presetCell
    }
        
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/2) + 40, height: (UIScreen.main.bounds.height/6))
        return layout
    }()
    
    lazy var presetSearchCollectionViewCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.register(PresetScreenerCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.presetCell.rawValue)
        return cv
    }()
    
    
    init(searches: [PresetScreenerViewModel]) {
        self.presetSearches = searches
        super.init(style: .default, reuseIdentifier: nil)
        setupViews()
    }
    
    fileprivate func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(presetSearchCollectionViewCollectionView)
        presetSearchCollectionViewCollectionView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 2, left: 0, bottom: 2, right: 0)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.presetSearches = []
        super.init(coder: aDecoder)
    }
}

extension PresetScreenerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetSearches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screenerData = presetSearches[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.presetCell.rawValue, for: indexPath) as? PresetScreenerCollectionViewCell else { return UICollectionViewCell() }
        cell.configureView(viewModel: screenerData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchParameters = presetSearches[indexPath.item].presetScreener.urlComponents
        delegate?.navigateToScreenerResults(searchParameters: searchParameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PresetScreenerCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell?.alpha = 0.5
            cell?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PresetScreenerCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell?.alpha = 1
            cell?.transform = .identity
        }
    }
}


class PresetScreenerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appAccent3
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIView.ContentMode.scaleToFill
        return iv
    }()
    
    lazy var headerBackgroundView: UIView = {
        let iv = UIView()
        let imagePadding = 2
        iv.backgroundColor = .clear
        iv.layer.masksToBounds = false
        iv.addSubview(cellImageView)
        cellImageView.anchor(
            top: iv.topAnchor, leading: iv.leadingAnchor, bottom: iv.bottomAnchor, trailing: iv.trailingAnchor,
            padding: .init(top: 2, left: 2, bottom: 2, right: 2))
        return iv
    }()
    
    let screenerTypeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .secondaryText
        return l
    }()
    
    let detailLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = NSTextAlignment.left
        l.numberOfLines = 0
        l.textColor = .gray
        l.font = .details1
        return l
    }()
    
    lazy var detailsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, detailLabel])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()
    
    lazy var viewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8
        v.addSubview(detailsStackView)
        detailsStackView.anchor(
            top: v.topAnchor,
            leading: v.leadingAnchor,
            bottom: nil,
            trailing: v.trailingAnchor,
            padding: .init(top: 15, left: 15, bottom: 0, right: 15)
        )
        return v
    }()
    
    
    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.layer.masksToBounds = true
        layer.masksToBounds = true
        setupShadow(intensity: .light, color: .black)
        addSubview(viewBackground)
        viewBackground.fillSuperview()
        
        addSubview(headerBackgroundView)
        headerBackgroundView.anchor(
            top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 4, left: 8, bottom: 0, right: 9), size: .init(width: 40, height: 40))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView(viewModel: PresetScreenerViewModel) {
        headerLabel.text = viewModel.presetScreener.header
        detailLabel.text = viewModel.presetScreener.details
        cellImageView.image = viewModel.icon
    }
}













