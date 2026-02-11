//
//  StockAnalysisViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericCellImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 20).isActive = true
        widthAnchor.constraint(equalToConstant: 5).isActive = true
        layer.masksToBounds = true
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 2
    }
}

class MetricSelectionTableViewCell: UITableViewCell {
    
    static let reuseID = "GenericTableViewCell"
    
    let iconView: GenericCellImageView = {
        let iv = GenericCellImageView(frame: .zero)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.details3
        label.text = "No Data"
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = ThemeManager.collectionCellColor3()

        accessoryType = .disclosureIndicator
        addSubview(contentStackView)
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        if let accessoryView = accessoryView {
            contentStackView.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -8).isActive = true
        } else {
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}

