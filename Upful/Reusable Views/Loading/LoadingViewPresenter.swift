//
//  LoadingViewPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 1/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

struct LoadingViewPresenter {
    private static let loadingView = LoadingViewController()
    
    static func show(in viewcontroller: UIViewController) {
        
        viewcontroller.add(loadingView)
    }
    
    static func remove() {
        loadingView.remove()
    }
}
