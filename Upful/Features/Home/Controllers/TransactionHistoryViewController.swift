//
//  TransactionHistoryViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

struct TransactionViewModel {
    private let transaction: Transaction
    
    var transactionType: String {
        return transaction.type
    }
    
    var value: String {
        return "\(transaction.tradePrice)"
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        return dateFormatter.string(from: transaction.transactionDateAsDate)
    }
}

final class TransactionHistoryViewController: UITableViewController {
    var transactions: [Transaction] = LocalTransactionLedgerLoader().loadAllPersistedTransactions()
    
    override init(style: UITableView.Style) {
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
