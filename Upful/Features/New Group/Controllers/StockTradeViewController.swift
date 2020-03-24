//
//  StockTradeViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 3/19/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockTradeViewController: UITableViewController {
    
    // MARK: - Dependencies

    private let ticker: String
    private let tradingEngine = TradingEngine.shared
    private let quoteLoader: QuoteLoader = StockPriceLoader()
    
    // MARK: - Properties
    
    private(set) var numberOfShares: Int?
    private(set) var marketPrice: Double?
    private(set) var transaction: Transaction?
    
    private var estimate: Double?
    
    // MARK: - Views
    
    private lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelTap)))
        return button
    }()
    
    private lazy var header: PreferenceHeaderView = {
        let header = PreferenceHeaderView()
        header.headerLabel.text = "TRADE \(ticker)"
        header.descriptionText.text = ""
        return header
    }()
    
    // MARK: Share Count View

    private let numberOfSharesLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "Number of Shares:"
        return label
    }()
    
    let numberOfSharesTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "0"
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        tf.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        tf.textAlignment = .right
        tf.addTarget(self, action: #selector(handleNumberOfSharesChange), for: .editingChanged)
        return tf
    }()
    
    lazy var shareCountStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [numberOfSharesLabel, numberOfSharesTextField])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return sv
    }()
    
    // MARK: Quote View
    
    private let quoteDescriptionLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "Last Price:"
        return label
    }()
    
    let quoteValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "$ -"
        return label
    }()
    
    lazy var quoteStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [quoteDescriptionLabel, quoteValueLabel])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return sv
    }()
    
    // MARK: Estimate View
    
    private let estimateLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "Trade Estimate:"
        return label
    }()
    
    let estimateValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "$ -"
        return label
    }()
    
    lazy var estimateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [estimateLabel, estimateValueLabel])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return sv
    }()
    
    
    // MARK: - Initializer
    
    init(ticker: String) {
        self.ticker = ticker
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        tableView.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfCurrentlyOwned()
        loadRecentPrice()
        
        numberOfSharesTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleNumberOfSharesChange(_ textField: UITextField) {
        if let shares = Int(textField.text ?? "null") {
            numberOfShares = shares
            estimate = (marketPrice ?? 0) * Double(numberOfShares ?? 0)
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        }
    }
    
    @objc fileprivate func handleCancelTap() {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     when trade tapped,
         fetch most current price,
             if fail, present alert saying failed to make purchase
             if success, construct a TransactionAdapter to pass through TradingEngine
     */
    
    // MARK: - Methods
    
    fileprivate func checkIfCurrentlyOwned() {
        tradingEngine.loadHoldings { [weak self] (holdings, err) in
            guard let self = self else { return }
            if let _ = err {
                self.presentAlert("Error", "Failed to load your holdings.") {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            if let currentHolding = holdings.first(where: { $0.ticker == self.ticker }) {
                self.header.descriptionText.text = "You currently own \(currentHolding.totalShareCount.withCommas()) shares of \(self.ticker).\nYour cash balance is $\(self.tradingEngine.balanceManager.currentCashBalance.withCommas())"
            } else {
                self.header.descriptionText.text = "You do not own any shares of \(self.ticker).\nYour cash balance is $\(self.tradingEngine.balanceManager.currentCashBalance.withCommas())"
            }
        }
    }
    
    fileprivate func loadRecentPrice() {
        quoteLoader.load(for: ticker) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let quote):
                self.handlePriceLoadCompletion(quote)
            case .failure(_):
                self.presentAlert("Error Loading Quote.", "") {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func presentAlert(_ title: String, _ description: String, handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            handler?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    fileprivate func handlePriceLoadCompletion(_ quote: StockQuote) {
        marketPrice = quote.latestPrice
        transaction = TransactionAdapter(ticker: ticker, shares: Int32(numberOfShares ?? 0),
                                        tradePrice: quote.latestPrice)
        DispatchQueue.main.async {
            self.quoteValueLabel.text = "$\(self.marketPrice?.withCommas() ?? " -")"
        }
    }
}

extension StockTradeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if indexPath.row == 0 {
            cell.addSubview(shareCountStackView)
            shareCountStackView.fillSuperview(padding: .init(top: 8, left: 32, bottom: 8, right: 32))
        }
        if indexPath.row == 1 {
            cell.addSubview(quoteStackView)
            quoteStackView.fillSuperview(padding: .init(top: 8, left: 32, bottom: 8, right: 32))
        }
        if indexPath.row == 2 {
            cell.addSubview(estimateStackView)
            estimateStackView.fillSuperview(padding: .init(top: 8, left: 32, bottom: 8, right: 32))
            
            estimateValueLabel.text = "$\(estimate?.withCommas() ?? " -")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

