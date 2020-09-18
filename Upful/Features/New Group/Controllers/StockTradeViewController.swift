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
    
    lazy var holdingsLoadCompletion: CompletionHandler<[Holding]> = {
        var handler = CompletionHandler<[Holding]>()
        handler.subscribe { [weak self] holdings in
            if let holdings = holdings {
                self?.currentHoldings = holdings
                self?.handleHoldingsLoadCompletion(holdings)
            }
        }
        return handler
    }()
    
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
    
    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy", for: .normal)
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .bold)
        button.backgroundColor = .appAccent3
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleBuyTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var sellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sell", for: .normal)
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .bold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSellTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var tradeButtonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyButton, sellButton])
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()
    
    // MARK: Share Count View

    private let numberOfSharesLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "Shares:"
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
//        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
//        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return sv
    }()
    
    // MARK: Estimate View
    
    private let estimateLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.text = "Trade Estimate:"
        return label
    }()
    
    let estimateValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.text = "$ -"
        return label
    }()
    
    lazy var estimateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [estimateLabel, estimateValueLabel])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tradingEngine.loadHandlerObservers.insert(holdingsLoadCompletion)
        tradingEngine.loadHoldings()
        loadRecentPrice()
        
        numberOfSharesTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            view.addSubview(tradeButtonStackView)
            tradeButtonStackView.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor,
                                        bottom: view.layoutMarginsGuide.bottomAnchor,
                                        trailing: view.layoutMarginsGuide.trailingAnchor,
                                        padding: .init(top: 0, left: 16, bottom: keyboardHeight + 4, right: 16))
        }
    }
    
    var currentHoldings: [Holding] = []
    
    @objc fileprivate func handleSellTap() {
        guard let transaction = transaction,
            let numberOfShares = numberOfShares else {
            return
        }
        
        transaction.numberOfShares = Int32(numberOfShares)

        buyButton.isEnabled = false
        sellButton.isEnabled = false
        
        if transaction.numberOfShares == 0 {
            buyButton.isEnabled = true
            sellButton.isEnabled = true
            return
        }
            
        if let currentHolding = currentHoldings.first(where: { $0.ticker == ticker }) {
            
            if numberOfShares <= currentHolding.totalShareCount {
                self.tradingEngine.sell(transaction: transaction, completion: { [weak self] in
                    
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        InformationViewPresenter().showGenericSuccess(in: self, description: "Sold Successfully", completion: { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            } else {
                self.presentAlert("Error", "You can't sell what you don't have.", OKhandler: {
                    self.buyButton.isEnabled = true
                    self.sellButton.isEnabled = true
                })
            }
        } else {
            self.presentAlert("Error", "You can't sell what you don't have.", OKhandler: {
                self.buyButton.isEnabled = true
                self.sellButton.isEnabled = true
            })
        }
    }
    
    @objc fileprivate func handleBuyTap() {
        guard let transaction = transaction,
            let numberOfShares = numberOfShares else {
            return
        }
        transaction.numberOfShares = Int32(numberOfShares)

        buyButton.isEnabled = false
        sellButton.isEnabled = false

        if transaction.numberOfShares == 0 {
            buyButton.isEnabled = true
            sellButton.isEnabled = true
            return
        }
        
        transaction.numberOfShares = Int32(numberOfShares)
        tradingEngine.buy(transaction: transaction, completion: { [weak self] didComplete in
            didComplete ? self?.handleBuySuccess() : self?.handleBuyFailure()
        })
    }
    
    // MARK: - Methods
    
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
    
    // MARK: - Helper Methods
    
    fileprivate func presentAlert(_ title: String, _ description: String, OKhandler: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                OKhandler?()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func handleHoldingsLoadCompletion(_ holdings: [Holding]) {
        if let currentHolding = holdings.first(where: { $0.ticker == ticker }) {
            
            header.descriptionText.text = "You currently own \(currentHolding.totalShareCount.withCommas()) shares of \(ticker).\nYour cash balance is $\(tradingEngine.balanceManager.currentCashBalance.withCommas())"
        } else {
            header.descriptionText.text = "You do not own any shares of \(ticker).\nYour cash balance is $\(tradingEngine.balanceManager.currentCashBalance.withCommas())"
        }
    }
    
    fileprivate func handlePriceLoadCompletion(_ quote: StockQuote) {
        marketPrice = quote.latestPrice
        transaction = TransactionAdapter(ticker: ticker, shares: Int32(numberOfShares ?? 0),
                                        tradePrice: quote.latestPrice)
        DispatchQueue.main.async {
            self.quoteValueLabel.text = "$\(self.marketPrice?.withCommas() ?? " -")"
        }
    }
    
    fileprivate func handleBuyFailure() {
        presentAlert("Error", "You don't have enough cash to purchase \(numberOfShares!) shares of \(ticker).",
            OKhandler: {
                self.buyButton.isEnabled = true
                self.sellButton.isEnabled = true
        })
    }
    
    fileprivate func handleBuySuccess() {
        DispatchQueue.main.async {
            Vibration.success.vibrate()
            InformationViewPresenter().showGenericSuccess(in: self, description: "Purchased Succesfully",
                                                          completion: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
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
            shareCountStackView.fillSuperview(padding: .init(top: 16, left: 32, bottom: 16, right: 32))
        }
        if indexPath.row == 1 {
            cell.addSubview(quoteStackView)
            quoteStackView.fillSuperview(padding: .init(top: 16, left: 32, bottom: 16, right: 32))
        }
        if indexPath.row == 2 {
            cell.addSubview(estimateStackView)
            estimateStackView.fillSuperview(padding: .init(top: 16, left: 32, bottom: 16, right: 32))
            
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
