//
//  NotificationSetupVC.swift
//  Upful
//
//  Created by Yanik Simpson on 12/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NotificationSetupViewController: UIViewController {
    
    // MARK: - Views
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = VersionManager.collectionCellColor()
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 16
        v.heightAnchor.constraint(equalToConstant: 175).isActive = true
        return v
    }()
    
    private let headerLabel: UILabel = {
        let l = UILabel()
        l.text = "Push Notifications"
        l.textAlignment = .center
        l.textColor = .label
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.numberOfLines = 0
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Would you like to be notified whenever your stock screening limit resets?"
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var dismissButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Not Right Now", for: .normal)
        b.addTarget(self, action: #selector(handDismiss), for: .touchUpInside)
        b.setTitleColor(.label, for: .normal)
        return b
    }()
    
    private lazy var acceptButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Yes, Please", for: .normal)
        b.backgroundColor = .appAccent3
        b.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        b.layer.masksToBounds = false
        b.layer.cornerRadius = 8
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        b.setTitleColor(.white, for: .normal)
        return b
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dismissButton, acceptButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContents()
        layoutButtons()
        layoutTextDescription()
    }
    
    // MARK: - View Set Up
    
    fileprivate func setupContents() {
        view.backgroundColor =
            UIColor.init() { (trait) -> UIColor in
               if trait.userInterfaceStyle == .dark {
                    self.containerView.setupShadow(intensity: .light, color: VersionManager.collectionCellColor())
               }
               if trait.userInterfaceStyle == .light {
                   self.containerView.setupShadow(intensity: .light, color: .label)
               }
               return UIColor(white: 0.1, alpha: 0.4)
           }
       
        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    fileprivate func layoutButtons() {
        containerView.addSubview(buttonStackView)
        buttonStackView.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        buttonStackView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        buttonStackView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor, constant: -16).isActive = true
    }
    
    fileprivate func layoutTextDescription() {
        view.addSubview(headerLabel)
        headerLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 12, left: 16, bottom: 16, right: 16))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(
            top: headerLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: buttonStackView.topAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 4, left: 16, bottom: 16, right: 16))
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handDismiss(_ sender: UIButton) {
        remove()
    }
    
    @objc fileprivate func handleAccept(_ sender: UIButton) {
        remove()
        PermissionManager.shared.setupScreeningNotification()
    }
}

