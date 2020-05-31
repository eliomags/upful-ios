//
//  HoldingBreakdownHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 4/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class HoldingBreakdownHeaderView: TableSectionHeaderView {
    
    // MARK: - Initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setButtonView()
        headerTextLabel.text = "Equity Breakdown"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    func setButtonView() {
        NSLayoutConstraint.deactivate([
            addButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        addButton.layer.cornerRadius = 44/2
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = VersionManager.collectionCellColor()

        addButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .selected)
        
        let openImage = UIImage(systemName: "chevron.up")?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        let closeImage = UIImage(systemName: "chevron.up")?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        
        addButton.setImage(openImage, for: .normal)
        addButton.setImage(closeImage, for: .selected)
    }
    
    // MARK: - Animations
    func toggleButtonState() {
        if addButton.isSelected {
            UIView.animate(withDuration: 0.25) {
                self.addButton.imageView?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.addButton.imageView?.transform = .identity
            }
        }
    }
    
    // MARK: - Actions
    @objc override func handleTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        buttonAction?()
        toggleButtonState()
    }
}
