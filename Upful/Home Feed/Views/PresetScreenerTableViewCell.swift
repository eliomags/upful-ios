//
//  PresetScreenerTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PresetScreenerTableViewCell: UITableViewCell {
    
    let searches: [PresetScreener]
    
    private enum ReuseID: String {
        case presetCell
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.itemSize = CGSize(width: 150, height: 120)
        return layout
    }()
    
    lazy var presetSearchCollectionViewCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PresetScreenerCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.presetCell.rawValue)
        return cv
    }()
    
    
    init(searches: [PresetScreener]) {
        self.searches = searches
        super.init(style: .default, reuseIdentifier: nil)
        setupViews()
    }
    
    fileprivate func setupViews() {
        selectionStyle = .none
        addSubview(presetSearchCollectionViewCollectionView)
        presetSearchCollectionViewCollectionView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 4, right: 16)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PresetScreenerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = searches[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.presetCell.rawValue, for: indexPath) as? PresetScreenerCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = data.header
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did tap cell: ", indexPath)
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
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    let companyLogo: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 35).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 35).isActive = true
        return iv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [companyLogo, label])
        sv.alignment = .center
        sv.axis = .vertical
        sv.spacing = 2
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 12, left: 6, bottom: 8, right: 6)
        )
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}













