//
//  EmptyScreenFavoriteCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyScreenerFavoriteCell: GeneralEmptyCell {
    
    override var emptyImage: UIImage {
        return #imageLiteral(resourceName: "icons8-skyscrapers-100").withRenderingMode(.alwaysOriginal)
    }
    
    override var emptyDescription: String {
        return "You have no screeners saved."
    }
}


class EmptyStockFavoriteCell: GeneralEmptyCell {
    
    override var emptyImage: UIImage {
        return #imageLiteral(resourceName: "icons8-company-100").withRenderingMode(.alwaysOriginal)
    }
    
    override var emptyDescription: String {
        return "You have no stocks saved."
    }
}

