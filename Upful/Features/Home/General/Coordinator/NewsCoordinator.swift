//
//  HomeGeneralCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class NewsCoordinator: Coordinator {

    var presenter: UIViewController
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func start() {
        let newsVC = NewsViewController()
        presenter.navigationController?.pushViewController(newsVC, animated: true)
    }
}

