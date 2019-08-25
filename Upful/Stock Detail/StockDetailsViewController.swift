//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDetailsViewController: UIViewController {
    
    // MARK: - Dependencies
    
     let ticker: String
    
    
    // MARK: - Views
    
    
    
    
    // MARK: - Initializer Methods
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    
    // MARK: - Private Functions
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.title = "Screen Results"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

