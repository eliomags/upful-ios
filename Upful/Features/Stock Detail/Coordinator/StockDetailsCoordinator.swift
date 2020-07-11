//
//  StockDetailsCoordinator.swift
//  Upful
//
//  Created by Yanik Simpson on 2/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockDetailsCoordinator: Coordinator {
    typealias StockNameDetails = (ticker: String, companyName: String)
    var presenter: UIViewController
    private let stockViewModel: StockViewModel
    
    init(presenter: UIViewController, stockViewModel: StockViewModel) {
        self.presenter = presenter
        self.stockViewModel = stockViewModel
    }
    
    func start() {
        RemoteStockManager.updateInterest(for: stockViewModel.stock.ticker, name: stockViewModel.stock.name)
        
        let detailsVC = UINavigationController(rootViewController:
            StockOverviewViewController(ticker: stockViewModel.stock.ticker, companyName: stockViewModel.stock.name))
        detailsVC.modalPresentationStyle = .fullScreen
        presenter.present(detailsVC, animated: true, completion: nil)
    }
}
