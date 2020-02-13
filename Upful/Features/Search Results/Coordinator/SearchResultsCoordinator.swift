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
    private let navigationTitle: String
    private let screenerDescription: String
    private let headerbackgroundColor: UIColor
    
    init(presenter: UIViewController,
         searchParameters: [String],
         title: String,
         screenerDescription: String,
         headerbackgroundColor: UIColor) {
        self.presenter = presenter
        self.searchParameters = searchParameters
        self.navigationTitle = title
        self.screenerDescription = screenerDescription
        self.headerbackgroundColor = headerbackgroundColor
    }
    
    func start() {
        let resultsVC = ScreenResultsViewController(searchParameters: searchParameters)
        resultsVC.resultsDescriptionHeaderLabel.titleLabel.text = navigationTitle
        resultsVC.resultsDescriptionHeaderLabel.descriptionLabel.text = screenerDescription
        resultsVC.resultsDescriptionHeaderLabel.imageViewBackground.backgroundColor = headerbackgroundColor
        presenter.navigationController?.pushViewController(resultsVC, animated: true)
    }
}

