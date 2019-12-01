//
//  NotificationSetupVC.swift
//  Upful
//
//  Created by Yanik Simpson on 12/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSubscriptionView() {
        let notificationSetupVC = NotificationSetupViewController()
        self.display(contentController: notificationSetupVC, on: self.view)
    }
}

class NotificationSetupViewController: UIViewController {
    
    // MARK: - Views
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init() { (trait) -> UIColor in
            if trait.userInterfaceStyle == .light { return .white }
            if trait.userInterfaceStyle == .dark { return .systemGray }
            return .white
        }
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 16
        v.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return v
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContents()
    }
    
    // MARK: - View Set Up
    
    fileprivate func setupContents() {
        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
}
