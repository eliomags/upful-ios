//
//  SearchResultsCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class SearchResultsCoordinator: Coordinator {
    var presenter: UIViewController
    private let searchParameters: [String]
    
    init(presenter: UIViewController, searchParameters: [String]) {
        self.presenter = presenter
        self.searchParameters = searchParameters
    }
    
    func start() {
        let resultsVC = ScreenResultsViewController(searchParameters: searchParameters)
        presenter.navigationController?.pushViewController(resultsVC, animated: true)
    }
}

