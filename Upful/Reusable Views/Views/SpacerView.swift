//
//  SpacerView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

/// This view is used as a separator in stackViews as shown in StockDetailsVC Metrics Section

class SpacerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8839988112, green: 0.8841472864, blue: 0.8839792609, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            if traitCollection.userInterfaceStyle == .light {
                heightAnchor.constraint(equalToConstant: 0.25).isActive = true
            }
        } else {
            heightAnchor.constraint(equalToConstant: 0.25).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}




