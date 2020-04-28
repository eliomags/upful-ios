//
//  HomeFeedAuxiliaryActionView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class HomeFeedAuxiliaryActionView: AuxiliaryActionView {
        
    // MARK: - Views
    
    let preferenceButton: MultilineButton = {
        let imageIcon: UIImage = UIImage(systemName: "plus.app")?
            .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
            .withTintColor(UIColor.appAccent3, renderingMode: .alwaysOriginal) ?? UIImage()
        let button = MultilineButton(title: "Edit Preferences", image: imageIcon)
        return button
    }()
    let suggestionButton: MultilineButton = {
        let imageIcon: UIImage = UIImage(systemName: "message.circle")?
            .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
            .withTintColor(UIColor.appAccent3, renderingMode: .alwaysOriginal) ?? UIImage()
        let button = MultilineButton(title: "Send Suggestion", image: imageIcon)
        return button
    }()
    let premiumButton: MultilineButton = {
        let imageIcon: UIImage = UIImage(systemName: "bag")?
            .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
            .withTintColor(UIColor.appAccent3, renderingMode: .alwaysOriginal) ?? UIImage()
        let button = MultilineButton(title: "Upgrade", image: imageIcon)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentStackView.addArrangedSubview(preferenceButton)
        contentStackView.addArrangedSubview(suggestionButton)
        contentStackView.addArrangedSubview(premiumButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
}

