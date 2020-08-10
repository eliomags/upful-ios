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
    
    enum Animation: Int, CaseIterable {
        case revealText = 0
        case increateFont
        case reduceFont
        case removeFont
        
        var duration: TimeInterval {
            switch self {
            case .revealText:
                return 0.65
            case .increateFont:
                return 0.1
            case .reduceFont:
                return 0.2
            case .removeFont:
                return 0.15
            }
        }
        
        static var totalDuration: Double {
            return Animation.allCases.map{ $0.duration }.reduce(0, +)
        }
        
        var relativeStartTime: TimeInterval {
            let previousAnimations = (0..<self.rawValue).compactMap{ Animation(rawValue: $0) }
            return previousAnimations.map{ $0.duration }.reduce(0, +) / Animation.totalDuration
        }
        var relativeDuration: TimeInterval {
            return self.duration / Animation.totalDuration
        }
        
        func animate(_ block: @escaping () -> Void) {
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration) {
                block()
            }
        }
    }
    
    func start(completion: @escaping () -> Void) {
        let totalDuration = Animation.totalDuration
        
        UIView.animateKeyframes(withDuration: totalDuration, delay: 0.6, options: .calculationModeCubic, animations: {
            Animation.revealText.animate {
                let horizontalScrollDistance = UIScreen.main.bounds.width
                self.textCoverView.transform = CGAffineTransform(translationX: horizontalScrollDistance, y: 0)
            }
            
            Animation.increateFont.animate {
                self.upfulTextLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            Animation.reduceFont.animate {
                self.upfulTextLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            }
            
            Animation.removeFont.animate {
                self.upfulTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.view.backgroundColor = .clear
            }
        }) { _ in
            self.remove()
            completion()
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
