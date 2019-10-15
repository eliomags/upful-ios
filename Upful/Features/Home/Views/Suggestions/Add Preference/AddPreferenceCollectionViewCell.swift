//
//  AddPreferenceCollectionViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 10/14/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class AddPreferenceCollectionViewCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? highlightAnimation() : unhightlightAnimation()
        }
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Set up your preferences to start getting recommendations."
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .appAccent
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
   
    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 30, left: 12, bottom: 30, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func highlightAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func unhightlightAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
}



