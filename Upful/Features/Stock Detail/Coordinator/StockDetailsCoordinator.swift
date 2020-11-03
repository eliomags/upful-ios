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
        RemoteStockManager.updateInterest(for: stockViewModel.stock.ticker.uppercased(), name: stockViewModel.stock.name)
        
        let detailsVC = StockOverviewViewController(ticker: stockViewModel.stock.ticker,
                                                    companyName: stockViewModel.stock.name)
        presenter.navigationController?.pushViewController(detailsVC, animated: true)
        presenter.setTabBarVisible(visible: false, animated: true)
        UserFeedbackPresenter.checkAndAskForReview(checkType: .importantAction, in: detailsVC)
    }
}

extension UIViewController {
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (isTabBarVisible == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration: TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                self.tabBarController?.tabBar.isHidden = !visible
                return
            }
        }
    }
    
    var isTabBarVisible: Bool {
        return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
    }
}
