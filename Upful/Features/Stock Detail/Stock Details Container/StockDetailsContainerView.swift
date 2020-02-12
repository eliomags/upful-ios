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
    
    let ticker: String
    let companyName: String
    var savedStocks: [SavedStock] = []
    
    // MARK: - Views
    
    override var menubarControllers: [UIViewController] {
        let controllers: [UIViewController] = [
            StockOverviewViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI()),
            StockAnalysisViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI())
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
    
    // MARK: - Initializer Methods
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
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
    }
    
    // MARK: - View Setup

    fileprivate func configureNavBar() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        let save = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItems = [save]
        VersionManager.navigationBarColor(in: navigationController)
        VersionManager.setNavigationBar(in: navigationController)
    }
    
    // MARK: - Core Data
    
    let savedStockDataManager = LocalStockLoader()

    @objc private func checkIfCurrentlySaved() {
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                let stockTickers = savedStocks.map({ $0.ticker })
                DispatchQueue.main.async {
                    self.saveButton.isSelected = stockTickers.contains(self.ticker)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    private func removeFavorite(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.removeFavoriteCompany(ticker, completion: nil)
    }
         
    private func saveCompany(button: UIButton) {
        button.isSelected = !button.isSelected
        savedStockDataManager.saveCompany(ticker: ticker, companyName: companyName)
        
        if button.isSelected {
            Vibration.light.vibrate()
            AnalyticsLogger.instance.reportEvents(event: .savedTicker(ticker: self.ticker))
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












