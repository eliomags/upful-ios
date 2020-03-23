//
//  StockDetailsContainerView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/13/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDetailsContainerView: MenuContainerViewController, UIPopoverPresentationControllerDelegate, NoteVCDelegate {
    
    // MARK: - Dependencies
    
    let savedStockDataManager = LocalStockLoader()
    let stockViewModel: StockViewModel
    
    // MARK: - Views
    
    override var menubarControllers: [UIViewController] {
        let controllers: [UIViewController] = [
            StockOverviewViewController(ticker: stockViewModel.stock.ticker, companyName: stockViewModel.stock.name),
            StockAnalysisViewController(ticker: stockViewModel.stock.ticker, companyName: stockViewModel.stock.name)
        ]
        return controllers
    }
    
    lazy var notesButton: NotesButton = {
        let button = NotesButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenNotes)))
        return button
    }()
    
    lazy var saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        return button
    }()
    
    lazy var tradeButton: CustomRoundButton = {
        let button = CustomRoundButton(imageName: "arrow.up.arrow.down")
        button.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(handleTradeTap)))
        return button
    }()
    
    let tradingEngine = TradingEngine.shared
    
    @objc fileprivate func handleTradeTap() {
        tradingEngine.buy(transaction: TransactionViewModel(stock: stockViewModel.stock, numberOfShares: 5))
//        tradingEngine.sell(transaction: Transaction(stock: stockViewModel.stock, numberOfShares: 5))
    }
    
    // MARK: - Initializer Methods
    
    init(stockViewModel: StockViewModel) {
        self.stockViewModel = stockViewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = VersionManager.mainContainerBackground()
        configureNavBar()
        UserFeedbackPresenter.checkAndAskForReview(checkType: .importantAction, in: self)
        performSelector(inBackground: #selector(checkIfCurrentlySaved), with: nil)
        
        tradingEngine.loadLedgerTransactions { (result) in
            switch result {
            case .success(let ledgerTrans):
                print("Ledger Transactions")
                print(ledgerTrans.map { $0.ticker })
                print(ledgerTrans.map { $0.numberOfShares })
            case .failure(_):
                print("Failed to load")
            }
        }
        tradingEngine.loadLoggedTransactions { (result) in
            switch result {
            case .success(let ledgerTrans):
                print("Logged Transactions")
                print(ledgerTrans.map { $0.ticker })
                print(ledgerTrans.map { $0.numberOfShares })
            case .failure(_):
                print("Failed to load")
            }
        }
    }
    
    // MARK: - View Setup

    fileprivate func configureNavBar() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        let save = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItems = [save]
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
        
        view.addSubview(tradeButton)
        tradeButton.anchor(top: nil,
                           leading: nil,
                           bottom: view.layoutMarginsGuide.bottomAnchor,
                           trailing: view.layoutMarginsGuide.trailingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 16, right: 4))
    }
    
    // MARK: - Core Data
    
    @objc private func checkIfCurrentlySaved() {
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                let stockTickers = savedStocks.map({ $0.ticker })
                DispatchQueue.main.async {
                    self.saveButton.isSelected = stockTickers.contains(self.stockViewModel.stock.ticker)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    private func removeFavorite(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.removeFavoriteCompany(stockViewModel.stock.ticker, completion: nil)
    }
         
    private func saveCompany(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.saveCompany(ticker: stockViewModel.stock.ticker, companyName: stockViewModel.stock.name)
        
        if button.isSelected {
            Vibration.light.vibrate()
            AnalyticsLogger.instance.reportEvents(event: .savedTicker(ticker: self.stockViewModel.stock.ticker))
        }
    }
    
    @objc fileprivate func handleSaveTap(_ sender: UIButton) {
        if sender.isSelected {
            self.removeFavorite(button: sender)
            return
        }

        PermissionManager.shared.getSaveStockPermission { [weak self] (permissionGranted) in
            guard let self = self else { return }
            if !permissionGranted {
                let presenter = SubscriptionPresenter(type: .savedStockLimit)
                presenter.present(in: self)
            }
            if permissionGranted { self.saveCompany(button: sender) }
        }
    }
    
    // MARK: - UIPopOverPresentationDelegate Methods
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overCurrentContext
    }
    
    // MARK: - Delegate Methods
    
    func displaySuccessNote() {
        InformationViewPresenter().showSaveSuccess(in: self)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleLearnMoreTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.amazon.com/gp/product/0060555661/ref=as_li_tl?ie=UTF8&tag=simpsony-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=0060555661&linkId=a0d1469b9cc7763a5f4f89b8c2ab12ba") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc fileprivate func handleOpenNotes( _ sender: UIBarButtonItem) {
        let notesVC = NotesViewController(delegate: self)
        let navVC = UINavigationController(rootViewController: notesVC)
        notesVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 400)
        notesVC.modalPresentationStyle = .popover
        notesVC.popoverPresentationController?.delegate = self
        present(navVC, animated: true, completion: nil)
    }
}

extension StockDetailsContainerView: SubscriptionViewControllerDelegate {
    func presentationControllerdDidDismissWithoutSignup() {}
    
    func userDidSignUp() {}    
}
