//
//  Animator.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class Animator {
    func displayAnimation(view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                view.transform = .identity
            }, completion: { (_) in
                self.removeView(view, completion: completion)
            })
        }
    }
    
    fileprivate func removeView(_ view: UIView, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0
            }, completion: { (_) in
                view.removeFromSuperview()
                completion?()
            })
        }
    }
}
