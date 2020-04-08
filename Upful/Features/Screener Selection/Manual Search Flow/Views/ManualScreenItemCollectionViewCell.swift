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
            detailLabel.text = viewModel.descritionText
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
        label.textColor = .systemGray
        label.textAlignment = .center
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.subheadline).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
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
        addSubview(contentStackView)
        contentStackView
            .setCenterYAnchor(relativeTo: self, padding: 16)
            .setLeadingAnchor(padding: 16)
            .setTrailingAnchor(padding: 16)
            .setBottomAnchor(padding: 0)
        backgroundColor = VersionManager.collectionCellColor()
    }
}
