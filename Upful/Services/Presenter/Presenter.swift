//
//  Presenter.swift
//  Upful
//
//  Created by Yanik Simpson on 9/21/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

enum ActionPresenterTypes {
    case error
}

struct ViewPresenter {
    static let actionView = ActionView()

    static func displaySuccessActionView(in viewController: UIViewController) {
        let view = viewController.view
        actionView.descriptionLabel.text = "Saved successfully."
        actionView.backgroundColor = UIColor(red: 243/255, green: 175/255, blue: 35/255, alpha: 1)
        viewController.view.addSubview(actionView)
        actionView.anchor(top: nil, leading: view?.layoutMarginsGuide.leadingAnchor, bottom: view?.layoutMarginsGuide.bottomAnchor, trailing: view?.layoutMarginsGuide.trailingAnchor,
                          padding: .init(top: 0, left: 4, bottom: 16, right: 4))
    }
    
    static func displayErrorActionView(in viewController: UIViewController, message: String) {
        let view = viewController.view
        actionView.descriptionLabel.text = message
        actionView.backgroundColor = UIColor(red: 255/255, green: 37/255, blue: 34/255, alpha: 1)
        viewController.view.addSubview(actionView)
        actionView.anchor(top: nil, leading: view?.layoutMarginsGuide.leadingAnchor, bottom: view?.layoutMarginsGuide.bottomAnchor, trailing: view?.layoutMarginsGuide.trailingAnchor,
                          padding: .init(top: 0, left: 4, bottom: 16, right: 4))
    }
    
    static func displayDeletionActionView(in viewController: UIViewController) {
        let actionView = ActionView()
        actionView.backgroundColor = UIColor.negative
    }
}

