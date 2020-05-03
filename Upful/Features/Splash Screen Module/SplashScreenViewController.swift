//
//  SplashScreenViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/30/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class SplashScreenController {
    
    static func presentSplashScreen(in viewController: UIViewController, completion: @escaping () -> Void) {
        let splashViewController = SplashScreenViewController()
        viewController.add(splashViewController)
        
        splashViewController.start(completion: completion)
    }
}

class SplashScreenViewController: UIViewController {
  
    private let upfulTextLabel: UILabel = {
        let label = UILabel()
        label.text = "UPFUL"
        label.textColor = .label
        let size = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        label.font = UIFont.init(name: "AvenirNext-Heavy", size: size)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        configureLabelPosition()
    }
    
    func start(completion: @escaping () -> Void) {
        let horizontalScrollDistance = UIScreen.main.bounds.width
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            UIView.animate(withDuration: 0.65, animations: {
                self.textCoverView.transform = CGAffineTransform(translationX: horizontalScrollDistance, y: 0)
            }) { (_) in
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.upfulTextLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (_) in
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.upfulTextLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    }) { (_) in
                        
                        let completionTime = 0.3
                        UIView.animate(withDuration: completionTime, animations: {
                            self.upfulTextLabel.text = nil
                            self.view.backgroundColor = .clear
                        }) { _ in
                            
                            self.remove()
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    private func configureLabelPosition() {
        let screen = UIScreen.main.bounds
        view.widthAnchor.constraint(equalToConstant: screen.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: screen.height).isActive = true
        
        view.addSubview(upfulTextLabel)
        upfulTextLabel.translatesAutoresizingMaskIntoConstraints = false
        upfulTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        upfulTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        
        upfulTextLabel.addSubview(textCoverView)
        textCoverView.topAnchor.constraint(equalTo: upfulTextLabel.topAnchor).isActive = true
        textCoverView.bottomAnchor.constraint(equalTo: upfulTextLabel.bottomAnchor).isActive = true
        textCoverView.leadingAnchor.constraint(equalTo: upfulTextLabel.leadingAnchor).isActive = true
        textCoverView.trailingAnchor.constraint(equalTo: upfulTextLabel.trailingAnchor).isActive = true
    }
}
