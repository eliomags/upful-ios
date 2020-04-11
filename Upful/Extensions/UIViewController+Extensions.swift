//
//  UIViewController+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

// MARK: - Adding Child View Controller

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            child.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}


// MARK: - Dismissing Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
        view.endEditing(true)
    }
}


extension UIViewController {
    func display(contentController content: UIViewController, on view: UIView) {
        self.addChild(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.topAnchor.constraint(equalTo: view.topAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        content.didMove(toParent: self)
    }
}
