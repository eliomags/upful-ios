//
//  ActionableTableHeader.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ActionableTableHeader: UITableViewHeaderFooterView {

    lazy var headerTextLabel: LargeSectionHeaderLabel = {
        let label = LargeSectionHeaderLabel(padding: 0)
        return label
    }()
    
    var viewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerTextLabel, viewDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var addButton: AddButton = {
        let button = AddButton()
        button.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(handleTap))))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.alpha = 1
        button.isHidden = true
        button.setTitleColor(.appAccent3, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitle("DONE", for: .normal)
        button.layer.cornerRadius = 35/2
        button.layer.borderColor = UIColor.appAccent3.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.addTarget(self, action: #selector(handleDoneTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, addButton, doneButton])
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    var buttonAction: (()->())?
    var editButtonAction: (()->())?
    
    // MARK: - Initializer Method
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(textStackView)
        addSubview(addButton)
        addSubview(doneButton)

        textStackView.anchor(
            top: nil, leading: leadingAnchor, bottom: nil, trailing: doneButton.leadingAnchor,
            padding: .init(top: 0, left: 16, bottom: 8, right: 8))
        textStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addButton.anchor(
            top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 8, right: 16))
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        doneButton.anchor(
            top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 8, right: 16))
        doneButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func showButton(_ isHidden: Bool) {
        addButton.isHidden = isHidden
        addButton.setNeedsDisplay()
    }
    
    @objc fileprivate func handleTap(_ sender: UIView) {
        buttonAction?()
    }
    
    @objc fileprivate func handleDoneTap(_ sender: UIButton) {
        editButtonAction?()
    }
        
    private func showDoneButton() {
        doneButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.5)
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.5)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveLinear, animations: {
                self.addButton.isHidden = true
                self.doneButton.isHidden = false
                self.doneButton.transform = .identity
            })
        }
    }
    
    private func revertToDefault() {
        UIView.animate(withDuration: 0.2, animations: {
            self.doneButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.5)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveLinear, animations: {
                self.doneButton.isHidden = true
                self.addButton.isHidden = false
                self.addButton.transform = .identity
            })
        }
    }
    
    func animateButton(isStateChanged: Bool) {
        if isStateChanged {
            showDoneButton()
        }
        if !isStateChanged {
            revertToDefault()
        }
    }
}
