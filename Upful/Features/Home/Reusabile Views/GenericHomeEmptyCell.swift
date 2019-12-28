//
//  NotesEmptyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GeneralEmptyCell: UITableViewCell {
    
    enum ButtonLook {
        case bordered
        case solid
    }
    
    var emptyImage: UIImage {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        let im = UIImage(systemName: "tray.fill", withConfiguration: largeConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            ?? UIImage()
        return im
    }
        
    var emptyHeaderText: String {
        return String()
    }
    
    var emptyDescriptionText: String {
        return String()
    }
    
    var buttonText: String {
        return String()
    }
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: emptyImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = emptyHeaderText
        label.textColor = .label
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = emptyDescriptionText
        label.textColor = .lightGray
        return label
    }()
    
    var buttonLook: ButtonLook {
        return .bordered
    }
    
    lazy var emptyCellActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCellAction), for: .touchUpInside)
        button.setupShadow(intensity: .medium, color: .darkGray)
        return button
    }()
    
    private let contentBackground: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 16
        v.heightAnchor.constraint(equalToConstant: 175).isActive = true
        v.backgroundColor = VersionManager.collectionCellColor()
        return v
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContentView()
        setupContentStackView()
        setupActionButton()
        configureButton()
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var cellAction: (() ->())?

    fileprivate func configureButton() {
        switch buttonLook {
        case .bordered:
            emptyCellActionButton.setTitleColor(.appAccent3, for: .normal)
            emptyCellActionButton.backgroundColor = .clear
            emptyCellActionButton.layer.borderWidth = 1.5
            emptyCellActionButton.layer.borderColor = UIColor.appAccent3.cgColor
        case .solid:
            emptyCellActionButton.setTitleColor(.white, for: .normal)
            emptyCellActionButton.backgroundColor = .appAccent3
        }
    }
    
    @objc fileprivate func handleCellAction(_ sender: UIButton) {
        cellAction?()
    }
    
    fileprivate func setupContentView() {
        addSubview(contentBackground)
        contentBackground.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true
        contentBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        contentBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
    }
    
    fileprivate func setupContentStackView() {
        contentBackground.addSubview(contentStackView)
        contentStackView.topAnchor.constraint(equalTo: contentBackground.topAnchor, constant: 12).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: contentBackground.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentBackground.trailingAnchor, constant: -16).isActive = true
    }
    
    fileprivate func setupImageView() {
        addSubview(cellImageView)
        cellImageView.bottomAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -50).isActive = true
        cellImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    fileprivate func setupActionButton() {
        contentBackground.addSubview(emptyCellActionButton)
        emptyCellActionButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 24).isActive = true
        emptyCellActionButton.centerXAnchor.constraint(equalTo: contentBackground.centerXAnchor).isActive = true
//        emptyCellActionButton.leadingAnchor.constraint(equalTo: contentBackground.leadingAnchor, constant: 16).isActive = true
//        emptyCellActionButton.trailingAnchor.constraint(equalTo: contentBackground.trailingAnchor, constant: -16).isActive = true
    }
}


