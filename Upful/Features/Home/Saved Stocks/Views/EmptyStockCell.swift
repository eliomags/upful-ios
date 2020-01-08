//
//  EmptyScreenFavoriteCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyStockFavoriteCell: GeneralEmptyCell {
    override var emptyImage: UIImage {
        return UIImage(named: "Looking1") ?? super.emptyImage
    }

    override var emptyHeaderText: String {
        return "No Stocks Saved"
    }
    
    override var emptyDescriptionText: String {
        return "Start searching for stocks. Tap add button to get started."
    }
}

class ErrorFavoriteCell: GeneralEmptyCell {
    override var emptyImage: UIImage {
        return UIImage(systemName: "exclamationmark.icloud")?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            ?? UIImage()
    }

    override var emptyHeaderText: String {
        return "Error"
    }
    
    override var emptyDescriptionText: String {
        return "Error getting your data. Refresh to try again."
    }
}
