//
//  StockDetailDragViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDetailDragViewController: UIViewController {
    
    let ticker: String
    
    private(set) var coordinator: Coordinator?

    // MARK: Views
    
    lazy var tradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TRADE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 44 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(handleTradeTap), for: .touchUpInside)
        return button
    }()
    
    lazy var dragView: DragView = {
        let dragConfig = DragStateConfiguration(closedHeight: 120, partialHeight: 350, fullHeight: 600)
        let view = DragView(configuration: dragConfig)
        view.backgroundColor = .secondarySystemGroupedBackground
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= -44 {
            dragView.controller.changeState(for: dragView.bounds.height-250)
        }
    }
    
    // MARK: Actions
        
    @objc fileprivate func handleTradeTap() {
        let presentingViewController = parent ?? self
        coordinator = StockTradeCoordinator(presentingViewController, ticker: ticker)
        coordinator?.start()
    }
}

extension StockDetailDragViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dragView.controller.currentPresentationState {
        case .closed:
            return 0
        case .partial:
            return 5
        case .full:
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = "Text"
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        footer.addSubview(tradeButton)
        tradeButton.anchor(top: footer.topAnchor, leading: nil, bottom: nil,
                           trailing: footer.layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: 8, left: 4, bottom: 8, right: 16))
        return footer
    }
}
