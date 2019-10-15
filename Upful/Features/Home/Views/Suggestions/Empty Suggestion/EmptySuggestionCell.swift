//
//  EmptySuggestionCell.swift
//  Upful
//
//  Created by Yanik Simpson on 10/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class EmptyStockSuggestionCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? animateHighlighted() : animateUnHighlighted()
        }
    }
    
    fileprivate func animateHighlighted() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    fileprivate func animateUnHighlighted() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "No Stocks Found."
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No stocks found based on your preferences. Adjust your preferences to get more results."
        label.font = .details1
        label.textColor = .gray
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [headerLabel, descriptionLabel])
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 6
        return stackview
    }()
    
    lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        view.addSubview(contentStackView)
        contentStackView.centerInSuperview()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(contentBackgroundView)
        contentBackgroundView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


