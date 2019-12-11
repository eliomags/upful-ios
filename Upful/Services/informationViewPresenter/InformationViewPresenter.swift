//
//  Presenter.swift
//  Upful
//
//  Created by Yanik Simpson on 9/21/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

enum InformationViewType {
    case error
}

struct InformationViewPresenter {
    let actionView = InformationView()
    
    func genericViewDisplay(in viewController: UIViewController) {
        viewController.view.addSubview(actionView)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        actionView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        actionView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        actionView.widthAnchor.constraint(equalToConstant: 230).isActive = true
    }

    func showSaveSuccess(in viewController: UIViewController) {
        actionView.descriptionLabel.text = "Saved successfully"
        actionView.actionImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
        genericViewDisplay(in: viewController)
    }
    
    func showReportSuccess(in viewController: UIViewController) {
        actionView.descriptionLabel.text = "Report Sent"
        actionView.actionImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
        genericViewDisplay(in: viewController)
    }
    
    func displayUpdateActionView(in viewController: UIViewController) {
        actionView.descriptionLabel.text = "Report Sent"
        actionView.actionImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
        genericViewDisplay(in: viewController)
    }
    
    func displayErrorActionView(in viewController: UIViewController, message: String) {
        actionView.descriptionLabel.text = message
        actionView.actionImageView.image = UIImage(systemName: "magnifyingglass")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
         genericViewDisplay(in: viewController)
    }
    
    func displayDeletionActionView(in viewController: UIViewController) {
        genericViewDisplay(in: viewController)
    }
}

