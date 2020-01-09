//
//  EmptyScreenerCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/26/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyScreenerFavoriteCell: GeneralEmptyCell {
    override var emptyImage: UIImage {
        return UIImage(named: "Looking2") ?? super.emptyImage
    }
    
    override var emptyHeaderText: String {
        return "No Screeners Saved"
    }
    
    override var emptyDescriptionText: String {
        return "Get started! Search prebuilt screeners or build your own!."
    }
    
    override func setupImageView() {
        addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.heightAnchor.constraint(equalToConstant: 275),
            cellImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 50),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75)
        ])
    }
}

