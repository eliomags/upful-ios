//
//  PopularCompanyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import SDWebImage

class PopularCompanyTableViewCell: UITableViewCell {
    private enum ReuseID: String {
        case companyCell
    }
    
    let popularCompanies: [PopularCompany]
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 70, height: 70)
        return layout
    }()
    
    lazy var popularCompanyCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PopularCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.companyCell.rawValue)
        return cv
    }()
    
    
    init(popularCompanies: [PopularCompany]) {
        self.popularCompanies = popularCompanies
        super.init(style: .default, reuseIdentifier: nil)
        setupViews()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(popularCompanyCollectionView)
        popularCompanyCollectionView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 2, left: 16, bottom: 2, right: 16)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopularCompanyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = popularCompanies[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell.rawValue, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = data.header
        cell.logoImage(urlText: data.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("did tap cell: ", indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PopularCompanyCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PopularCompanyCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell?.transform = .identity
        }
    }
}


class PopularCompanyCollectionViewCell: UICollectionViewCell {
    
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
        backgroundColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = (contentView.bounds.height / 2) - 3
        layer.masksToBounds = true
    }
    
    fileprivate func logoImage(urlText: String) {
        guard let logoUrl = URL(string: urlText) else { return }
        SDWebImageManager.shared.loadImage(with: logoUrl, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.companyLogo.image = image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}













