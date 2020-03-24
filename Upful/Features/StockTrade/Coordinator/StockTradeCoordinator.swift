//
//  StockTradeCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 3/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockTradeCoordinator: Coordinator {
    private let ticker: String
    var presenter: UIViewController
    
    init(_ presenter: UIViewController, ticker: String) {
        self.ticker = ticker
        self.presenter = presenter
    }
    
    func start() {
        let stockTradeVC = UINavigationController(rootViewController: StockTradeViewController(ticker: ticker))
        stockTradeVC.modalPresentationStyle = .fullScreen
        presenter.present(stockTradeVC, animated: true, completion: nil)
    }
}
