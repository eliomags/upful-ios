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
    
    var title: String {
        return transaction.ticker + " \(transaction.numberOfShares) shares"
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        return dateFormatter.string(from: transaction.transactionDateAsDate)
    }
    var price: String {
        return "$\(transaction.tradePrice.roundToTwoDecimal())"
    }
    var transactionType: String {
        return transaction.type
    }
}

final class TransactionListCell: UITableViewCell {
    static let id = "TransactionListCellID"
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        let size = UIFont.preferredFont(forTextStyle: .caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        return label
    }()
    
    let transactionTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        return label
    }()
    let tradePriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        let size = UIFont.preferredFont(forTextStyle: .callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let descriptionStackView = makeSectionStackView(with: tickerLabel, descriptionLabel)
        let tradeInfoStackView = makeSectionStackView(with: tradePriceLabel, transactionTypeLabel)
        let stackView = UIStackView(arrangedSubviews: [descriptionStackView, tradeInfoStackView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeSectionStackView(with views: UIView...) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
}

final class TransactionHistoryViewController: UITableViewController {
    struct SectionedViewModel {
        let description: String
        var viewModels: [TransactionViewModel]
    }
    
    // SubModels
    var sectionedViewModels = [SectionedViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Initializer
    override init(style: UITableView.Style) {
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TransactionListCell.self, forCellReuseIdentifier: TransactionListCell.id)
        navigationItem.title = "Previous Trades"
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
    
    // MARK: TableView Delegate Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedViewModels[section].viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListCell.id, for: indexPath) as? TransactionListCell
        let viewModel = sectionedViewModels[indexPath.section].viewModels[indexPath.row]
        cell?.tickerLabel.text = viewModel.title
        cell?.tradePriceLabel.text = viewModel.price
        cell?.descriptionLabel.text = viewModel.dateString
        cell?.transactionTypeLabel.text = viewModel.transactionType
        
        return cell ?? TransactionListCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitle = sectionedViewModels[section].description
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = sectionedViewModels[indexPath.section].viewModels[indexPath.row]
        let stock = Stock(name: "", ticker: viewModel.transaction.ticker)
        let presenter = StockDetailsCoordinator(presenter: self, stockViewModel: .init(stock: stock))
        
        presenter.start()
    }
}
