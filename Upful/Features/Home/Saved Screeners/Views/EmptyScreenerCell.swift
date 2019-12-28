//
//  EmptyScreenerCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/26/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyScreenerFavoriteCell: GeneralEmptyCell {
    
    override var buttonLook: GeneralEmptyCell.ButtonLook {
        return .bordered
     }
    
    override var emptyHeaderText: String {
        return "Saved Screeners"
    }
    
    override var emptyDescriptionText: String {
        return "You have no screeners saved.\nAdd and name a screener to get started."
    }
    
    override var buttonText: String {
        return "Add Screener"
    }
}

