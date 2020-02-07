//
//  WebViewCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class WebViewCoordinator: Coordinator {
    var presenter: UIViewController
    let urlString: String
    
    init(presenter: UIViewController, urlString: String) {
        self.presenter = presenter
        self.urlString = urlString
    }
    
    func start() {
        AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)

        let newsWebVC = WebViewViewController(urlString: urlString)
        let navVC = UINavigationController(rootViewController: newsWebVC)
        presenter.present(navVC, animated: true, completion: nil)
    }
}

