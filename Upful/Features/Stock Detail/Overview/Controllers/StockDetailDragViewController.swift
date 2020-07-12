//
//  StockDetailDragViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockDetailDragViewController: UIViewController {
    
    let ticker: String
    
    private(set) var coordinator: Coordinator?
    
    private(set) var metricPreviewViewModels = [MetricPreviewViewModel]()

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
        let dragConfig = DragStateConfiguration(closedHeight: 112, partialHeight: 210, fullHeight: 450)
        let view = DragView(configuration: dragConfig)
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.tableView.backgroundColor = .tertiarySystemGroupedBackground
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
        dragView.tableView.register(MetricPreviewTableViewCell.self, forCellReuseIdentifier: MetricPreviewTableViewCell.reuseID)
        createViewModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViewModels() {
        metricPreviewViewModels = [
            MetricPreviewViewModel(ticker: ticker, searchCriteria: .pricetoearnings),
            MetricPreviewViewModel(ticker: ticker, searchCriteria: .ebitmargin)
        ]
        
        metricPreviewViewModels.forEach({
            $0.delegate = self
            $0.loadHistoricalData()
        })
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
            return metricPreviewViewModels.count
        case .full:
            return metricPreviewViewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricPreviewTableViewCell.reuseID, for: indexPath)
            as? MetricPreviewTableViewCell else { return UITableViewCell() }
        let metricViewModel = metricPreviewViewModels[indexPath.row]
        metricViewModel.configureCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .tertiarySystemGroupedBackground
        footer.addSubview(tradeButton)
        var topPadding: CGFloat = 0
        switch dragView.controller.currentPresentationState {
        case .closed:
            topPadding = 0
        case .partial, .full:
            topPadding = 8
        }
        tradeButton.anchor(top: footer.topAnchor, leading: nil, bottom: nil,
                           trailing: footer.layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: topPadding, left: 4, bottom: 8, right: 0))
        return footer
    }
}

extension StockDetailDragViewController: MetricPreviewViewModelDelegate {
    
    func didLoadCellData(cell: MetricPreviewTableViewCell?) {
        dragView.tableView.reloadData()
    }
}
