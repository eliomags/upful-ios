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
    private let animation = Animator()
    private let actionView = InformationView()
    
    func genericViewDisplay(in viewController: UIViewController, completion: (() -> Void)? = nil) {
        viewController.view.addSubview(actionView)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: -50).isActive = true
        actionView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        actionView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        actionView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        animation.displayAnimation(view: actionView, completion: completion)
    }

    func showSaveSuccess(in viewController: UIViewController) {
        actionView.descriptionLabel.text = "Saved successfully"
        actionView.actionImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
        genericViewDisplay(in: viewController)
    }
    
    func showGenericSuccess(in viewController: UIViewController, description: String, completion: (() -> Void)?) {
        actionView.descriptionLabel.text = description
        actionView.actionImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal) ?? UIImage()
        genericViewDisplay(in: viewController, completion: completion)
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

