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
        return UIImage()
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
    
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: emptyImage)
        
        return imageView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = emptyHeaderText
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .details1
        label.text = emptyDescriptionText
        label.textColor = .gray
        return label
    }()
    
    var buttonLook: ButtonLook {
        return .bordered
    }
    
    lazy var emptyCellActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCellAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stackViewEmpty: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cellImageView, headerLabel, descriptionLabel, emptyCellActionButton])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()
    
    lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(stackViewEmpty)
        stackViewEmpty.centerInSuperview()
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(contentBackgroundView)
        contentBackgroundView.fillSuperview()

        emptyCellActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45).isActive = true
        emptyCellActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45).isActive = true

        configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var cellAction: (() ->())?
    

    fileprivate func configureButton() {
        switch self.buttonLook {
            
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
    
}


