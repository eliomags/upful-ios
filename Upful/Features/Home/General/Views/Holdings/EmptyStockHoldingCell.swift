//
//  EmptyStockHoldingCell.swift
//  Upful
//
//  Created by Yanik Simpson on 3/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class EmptyStockHoldingCell: UITableViewCell {
    
    // MARK: - Views
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.numberOfLines = 4
        label.text = "Its a bit empty here...\nTap to start searching for stocks!"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = VersionManager.collectionCellColor()
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                                padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(contentBackground)
        contentBackground.anchor(top: topAnchor, leading: leadingAnchor,
                                     bottom: bottomAnchor, trailing: trailingAnchor,
                                     padding: .init(top: 8, left: 12, bottom: 8, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("No coder")
    }
}
