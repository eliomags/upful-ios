//
//  StockDetailsViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import Charts

class StockDetailsViewController: UIViewController, ChartViewDelegate {

    private enum ReuseID {
        static let graphCell = "graphCell"
        static let calculationsCell = "calculationsCell"
        static let newsCell = "newsCell"
    }
    
    private var chartData: [String] = []
    private var calcData: [String] = []
    private var newsData: [Int] = [1,2,3,4]
    
    private var feedData: [[Any]] {
        return [chartData, calcData, newsData]
    }
    
    
    // MARK: - Dependencies
    
    let ticker: String
    let companyName: String
    
    
    // MARK: - Views
    
    lazy var detailsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(GraphTableViewCell.self, forCellReuseIdentifier: ReuseID.graphCell)
        tv.register(DetailsCalculationCell.self, forCellReuseIdentifier: ReuseID.calculationsCell)
        tv.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.tableHeaderView = UIView()
        return tv
    }()
    
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    
    // MARK: - View Setup
    
    private func setupViews() {
        view.addSubview(detailsTableView)
        detailsTableView.fillSuperview()
    }
    
    
    // MARK: - Private Functions
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "\(ticker)"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return feedData[section].count }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let graphCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.graphCell, for: indexPath) as? GraphTableViewCell else { return UITableViewCell() }
            graphCell.chartView.delegate = self
            return graphCell
        case 1:
            guard let calculationsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.calculationsCell, for: indexPath) as? DetailsCalculationCell else { return UITableViewCell() }
            return calculationsCell
        case 2:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath) as? NewsCell else { return UITableViewCell() }
            return newsCell
        default:
            return UITableViewCell()
        }        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0) :
            return (UIScreen.main.bounds.height / 2) - 50
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FormatedSectionHeaderLabel(padding: 16)
        header.backgroundColor = .white
        let headerText = ["FINANCIALS", "CALCULATIONS", "NEWS"]
        switch section {
        case 0: header.text = headerText[0]
        case 1: header.text = headerText[1]
        case 2: header.text = headerText[2]
        default: break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 70
        } else {
            return 25
        }
    }

}

private class FormatedSectionHeaderLabel: SectionHeaderLabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topRight, .topLeft], radius: 16)
    }
}
