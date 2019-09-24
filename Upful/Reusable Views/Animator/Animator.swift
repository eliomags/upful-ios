//
//  Animator.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol Animatable: UIView {}

class Animator {
    func displayAnimation(view: Animatable) {
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                view.transform = .identity
            }, completion: { (_) in
                self.removeView(view)
            })
        }
    }
    
    func removeView(_ view: Animatable) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.4, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            }, completion: { (_) in
                view.removeFromSuperview()
            })
        }
    }
}
