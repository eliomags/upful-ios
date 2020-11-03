//
//  ManualScreenItemCollectionViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualScreenItemCollectionViewCell: UICollectionViewCell {
    
    var viewModel: ManualScreenItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.titleText
            detailLabel.text = viewModel.descriptionText
            viewModel.isSelected ? handleSelectedState() : handleDeSelectedState()
        }
    }
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appAccent3
        label.textAlignment = .center
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .heavy)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 6
        sv.axis = .vertical
        sv.distribution = .fill
        return sv
    }()
    
    lazy var removeButton: CancelButton = {
        let button = CancelButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let size: CGFloat = 20
        button.layer.cornerRadius = size/2
        button.layer.masksToBounds = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTap)))
        return button
    }()
    
            
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        contentView.addSubview(contentStackView)
        contentStackView
            .setTopAnchor(padding: 16)
            .setLeadingAnchor(padding: 16)
            .setTrailingAnchor(padding: 16)
            .setBottomAnchor(padding: 16)
        backgroundColor = VersionManager.collectionCellColor()
    }

    var handleCancelTap: (() -> Void)?
    
    fileprivate func handleSelectedState() {
        let size: CGFloat = 20
        
        contentView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.heightAnchor.constraint(equalToConstant: size),
            removeButton.widthAnchor.constraint(equalToConstant: size),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1)
        ])
    }
    
    fileprivate func handleDeSelectedState() {
        removeButton.removeFromSuperview()
    }
    
    @objc fileprivate func cancelTap() {
        handleCancelTap?()
    }
}
