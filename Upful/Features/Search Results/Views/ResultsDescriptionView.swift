//
//  ResultsDescriptionView.swift
//  Upful
//
//  Created by Yanik Simpson on 2/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ResultsDescriptionView: UIView {
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 165)
    }
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Some Title"
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Some Description"
        l.textColor = .gray
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.numberOfLines = 4
        return l
    }()
    
    fileprivate lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isBaselineRelativeArrangement = true
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fill
        return sv
    }()
    
    fileprivate lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = VersionManager.collectionCellColor()
        v.addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 22, left: 22, bottom: 16, right: 22))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 6
        v.setupShadow(intensity: .light, color: .black)
        return v
    }()
    
    // MARK: - Initialier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDescriptionViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
        
    fileprivate func setupDescriptionViews() {
        // TODO: Add ImageView
        
        addSubview(contentView)
        contentView.fillSuperview(padding: .init(top: 20, left: 16, bottom: 8, right: 16))
    }
}
