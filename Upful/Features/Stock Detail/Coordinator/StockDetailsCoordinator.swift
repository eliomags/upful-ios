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
    private let stockNameDetails: StockNameDetails
    
    init(presenter: UIViewController, stockNameDetails: StockNameDetails) {
        self.presenter = presenter
        self.stockNameDetails = stockNameDetails
    }
    
    func start() {
        AnalyticsLogger.instance.reportEvents(event: .selectedStock(selectionType: .preference))
        RemoteStockManager.updateInterest(for: stockNameDetails.ticker, name: stockNameDetails.companyName)
        
        let detailsVC = StockDetailsContainerView(ticker: stockNameDetails.ticker, companyName: stockNameDetails.companyName)
        presenter.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
