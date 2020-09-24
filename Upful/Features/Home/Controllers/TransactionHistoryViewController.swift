//
//  TransactionHistoryViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

struct TransactionViewModel {
    let transaction: Transaction
    
    var description: String {
        let type = TransactionType(rawValue: transaction.type)!
        var action = ""
        if type == .buy { action = "\nBUY" }
        if type == .sell { action = "\nSELL" }
        return transaction.ticker + action + "\n\(transaction.numberOfShares) shares\n\(transaction.tradePrice)"
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        return dateFormatter.string(from: transaction.transactionDateAsDate)
    }
}

final class TransactionHistoryViewController: UITableViewController {
    struct SectionedViewModel {
        let description: String
        var viewModels: [TransactionViewModel]
    }
    var sectionedViewModels = [SectionedViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        navigationItem.title = "Historic Trades"
        configureViewModels()
    }
    
    func configureViewModels() {
        let now = Date().convertToEST()
        let thisMonth = now.getPreviousDate(days: 30)
        let transactions = LocalTransactionLedgerLoader().loadAllPersistedTransactions()
        let transactionViewModels = transactions.map{ TransactionViewModel(transaction: $0) }.reversed()
        var pastMonthTransactionViewModels = SectionedViewModel(description: "Past 30 days", viewModels: [])
        var otherTransactions = SectionedViewModel(description: "", viewModels: [])
        
        pastMonthTransactionViewModels.viewModels = transactionViewModels.filter({
            $0.transaction.transactionDateAsDate >= thisMonth})
        otherTransactions.viewModels = transactionViewModels.filter({
            $0.transaction.transactionDateAsDate <= thisMonth})
        
        sectionedViewModels.append(pastMonthTransactionViewModels)
        sectionedViewModels.append(otherTransactions)
    }
    
    // MARK: - TableView Delegate Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedViewModels[section].viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "transactionCell")
        let viewModel = sectionedViewModels[indexPath.section].viewModels[indexPath.row]
        cell.textLabel?.text = viewModel.description
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = viewModel.dateString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitle = sectionedViewModels[section].description
        return headerTitle
    }
}
