//
//  SavedScreenerCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SaveScreenerDelegate: class {
    var savedItems: [SavedItem] { get set }
    func editScreener(indexPath: IndexPath)
    func deleteScreener(indexPath: IndexPath)
}

class SavedScreenersCollectionViewController: UICollectionViewController {
    
    enum ReuseID {
        static let cell = "cell"
    }
    
    weak var delegate: SaveScreenerDelegate?
    
    
    // MARK: - Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(SavedScreenerCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.cell)
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowlayout.itemSize = CGSize(width: 170, height: 110)
            flowlayout.itemSize = CGSize(width: (UIScreen.main.bounds.width/2) + 40, height: (UIScreen.main.bounds.height/6))
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumInteritemSpacing = 5
            flowlayout.minimumLineSpacing = 8
            flowlayout.sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        }
    }
    
    
    // MARK: - CollectionView Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.savedItems.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.cell, for: indexPath) as? SavedScreenerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = delegate?.savedItems[indexPath.item].savedScreener.title
        cell.descriptionLabel.text = delegate?.savedItems[indexPath.item].configureDescription()
        cell.editSelected = { [weak self] in self?.delegate?.editScreener(indexPath: indexPath) }
        cell.removeSelected = { [weak self] in self?.delegate?.deleteScreener(indexPath: indexPath) }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlComponents = (delegate?.savedItems[indexPath.item].configureURLComponents()) ?? []
        if urlComponents == []  { return }
        let resultsVC = ScreenResultsViewController(searchParameters: urlComponents, networkingAPI: IntrinioAPI())
        parent?.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
}

class SavedScreenerCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    var removeButton: SmallRoundButton = {
        let button = SmallRoundButton()
        button.setImage(#imageLiteral(resourceName: "icons8-delete-30").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appAccent2
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    var editSelected: (()->())?
    var removeSelected: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        addSubview(removeButton)
        removeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: 3))
        addSubview(editButton)
        editButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 5, right: 3), size: CGSize(width: 40, height: 20))
        
        addSubview(titleLabel)
        titleLabel.anchor(top: removeButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: removeButton.trailingAnchor,
                          padding: .init(top: 2, left: 4, bottom: 0, right: 3))
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: editButton.topAnchor, trailing: titleLabel.trailingAnchor,
                                padding: .init(top: 2, left: 0, bottom: 2, right: 0))
        
        editButton.layer.cornerRadius = 10
        editButton.layer.masksToBounds = true
        
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setupActions() {
        editButton.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(handleRemoveTap), for: .touchUpInside)
    }
    
    @objc private func handleRemoveTap(_ sender: UIButton) {
        removeSelected?()
    }
    
    @objc private func handleEditTap(_ sender: UIButton) {
        editSelected?()
    }
}


