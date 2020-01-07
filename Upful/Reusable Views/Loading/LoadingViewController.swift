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
    
    lazy var loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.startAnimating()
        v.addSubview(activityView)
        activityView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 30, left: 30, bottom: 30, right: 30))
        v.layer.cornerRadius = 15
        v.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return v
    }()
    
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
}
