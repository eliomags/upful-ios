//
//  NotesEmptyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class GeneralEmptyCell: UITableViewCell {
    
    var emptyImage: UIImage {
        return UIImage()
    }
    
    var emptyDescription: String {
        return String()
    }
    
    var buttonText: String {
        return "Add"
    }
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: emptyImage)
        
        return imageView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = emptyDescription
        return label
    }()
    
    lazy var emptyCellActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setupShadow(intensity: .light, color: .black)
        button.addTarget(self, action: #selector(handleCellAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stackViewEmpty: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cellImageView, headerLabel,emptyCellActionButton])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(stackViewEmpty)
        stackViewEmpty.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                              padding: .init(top: 16, left: 16, bottom: 22, right: 16))
        emptyCellActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        emptyCellActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var cellAction: (() ->())?
    
    @objc fileprivate func handleCellAction(_ sender: UIButton) {
        cellAction?()
    }
    
}


