//
//  StockDetailsContainerView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDetailsContainerView: MenuContainerViewController {
    let ticker: String
    let companyName: String
    
    override var menubarControllers: [MenuBarDisplayable] {
        let controllers: [MenuBarDisplayable] = [
            
            StockDetailsViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI(), analyticsLogger: AnalyticsLogger()),
            StockDetailsViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI(), analyticsLogger: AnalyticsLogger())
        ]
        controllers.forEach { (controller) in
            controller.delegate = self
        }
        
        return controllers
    }
    
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .groupTableViewBackground
        AppStoreReviewHelper.checkAndAskForReview(checkType: .importantAction)
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.title = "\(ticker)"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
    }
    
    
}














