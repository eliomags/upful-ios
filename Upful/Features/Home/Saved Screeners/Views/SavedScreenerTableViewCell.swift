//
//  SavedScreenerTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SavedScreenerTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "\n"
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.text = "\n\n"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 8
        stackView.isBaselineRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addBottomSeparator()
        let isLoading = (titleLabel.text?.isEmpty ?? true) && (descriptionLabel.text?.isEmpty ?? true)
        isLoading ? setLoading() : setLoaded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = "\n"
        titleLabel.text = "\n\n"
    }
    
    // MARK: - View Setup
    
    func setupViews() {
        addSubview(textStackView)
        textStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                             padding: .init(top: 12, left: 16, bottom: 8, right: 16))
    }
    
    fileprivate func setLoading() {
        descriptionLabel.backgroundColor = VersionManager.loadingLabelColor()
        titleLabel.backgroundColor = VersionManager.loadingLabelColor()
    }
    
    fileprivate func setLoaded() {
        descriptionLabel.backgroundColor = .clear
        titleLabel.backgroundColor = .clear
    }
}


