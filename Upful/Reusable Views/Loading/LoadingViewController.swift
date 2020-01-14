//
//  LoadingViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 1/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.startAnimating()
        return activityView
    }()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingSpinner.heightAnchor.constraint(equalToConstant: 200),
            loadingSpinner.widthAnchor.constraint(equalToConstant: 200),
            loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
