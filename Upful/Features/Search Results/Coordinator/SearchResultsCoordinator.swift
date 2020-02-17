//
//  SearchResultsCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class SearchResultsCoordinator {
    var presenter: UIViewController
    private let searchParameters: [String]
    private let navigationTitle: String
    private let screenerDescription: String
    private let headerbackgroundColor: UIColor
    private let headerSymbol: UIImage?
    private let id: String
    
    let screener: ScreenerViewModel?
    
    init(presenter: UIViewController,
         searchParameters: [String],
         title: String,
         screenerDescription: String,
         headerbackgroundColor: UIColor,
         id: String,
         headerSymbol: UIImage? = nil) {
        self.presenter = presenter
        self.searchParameters = searchParameters
        self.navigationTitle = title
        self.screenerDescription = screenerDescription
        self.headerbackgroundColor = headerbackgroundColor
        self.id = id
        self.headerSymbol = headerSymbol
        self.screener = ScreenerViewModel(title: title, description: screenerDescription,
                                          searchParameters: searchParameters,
                                          interest: 0, documentID: id, colorMap: ["red": 3, "green": 156, "blue": 161, "alpha": 1],
                                          symbol: "pencil")
    }
    
    init(presenter: UIViewController, screenerViewModel: ScreenerViewModel) {
        self.presenter = presenter
        self.searchParameters = screenerViewModel.searchParameters
        self.navigationTitle = screenerViewModel.title
        self.screenerDescription = screenerViewModel.description
        self.headerbackgroundColor = screenerViewModel.getColor()
        self.id = screenerViewModel.documentID ?? ""
        self.headerSymbol = screenerViewModel.getSymbol()
        
        self.screener = screenerViewModel
    }
    
    init(presenter: UIViewController, screener: Screener) {
        self.presenter = presenter
        self.searchParameters = screener.urlComponents
        self.navigationTitle = screener.title
        self.screenerDescription = screener.description
        self.headerbackgroundColor = screener.getColorMap()
        self.id = screener.id
        self.headerSymbol = screener.getSymbol()
        
        self.screener = ScreenerViewModel(
            title: screener.title, description: screener.description,
            searchParameters: screener.urlComponents, interest: 0,
            documentID: screener.id, colorMap: screener.makeColorDictionary(),
            symbol: screener.symbol ?? "pencil")
    }
}

extension SearchResultsCoordinator: Coordinator {
    func start() {
        let resultsVC = ScreenResultsViewController(searchParameters: searchParameters)
        resultsVC.resultsDescriptionHeaderLabel.titleLabel.text = navigationTitle
        resultsVC.resultsDescriptionHeaderLabel.descriptionLabel.text = screenerDescription
        resultsVC.resultsDescriptionHeaderLabel.imageViewBackground.backgroundColor = headerbackgroundColor
        resultsVC.screener = self.screener
        if let headerSymbol = headerSymbol {
            resultsVC.resultsDescriptionHeaderLabel.imageView.image = headerSymbol
        }
        presenter.navigationController?.pushViewController(resultsVC, animated: true)
    }
}

