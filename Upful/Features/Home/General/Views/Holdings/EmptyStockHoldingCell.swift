//
//  EmptyStockHoldingCell.swift
//  Upful
//
//  Created by Yanik Simpson on 3/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyStockHoldingCell: UITableViewCell {
    
    // MARK: - Views
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.numberOfLines = 4
        label.text = "Its a bit empty here...\nYour purchased stocks will appear here."
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = VersionManager.collectionCellColor()
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: layoutMarginsGuide.topAnchor,
                                leading: layoutMarginsGuide.leadingAnchor,
                                bottom: layoutMarginsGuide.bottomAnchor,
                                trailing: layoutMarginsGuide.trailingAnchor,
                                padding: .init(top: 8, left: 4, bottom: 8, right: 4))
    }
    
    required init?(coder: NSCoder) {
        fatalError("No coder")
    }
}
