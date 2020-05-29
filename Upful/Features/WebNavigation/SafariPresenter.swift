//
//  WebViewCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import SafariServices

final class SafariPresenter: Coordinator {
    var presenter: UIViewController
    let urlString: String
    
    init(presenter: UIViewController, urlString: String) {
        self.presenter = presenter
        self.urlString = urlString
    }
    
    func start() {
        AnalyticsLogger.instance.reportEvents(event: .selectedNewsArticle)
        guard let url = URL(string: urlString) else { return }
        let newsWebVC = SFSafariViewController(url: url)
        presenter.present(newsWebVC, animated: true, completion: nil)
    }
}

