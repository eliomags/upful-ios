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
    
    
    override var menubarControllers: [MenuBarDisplayable] {
        let controllers: [MenuBarDisplayable] = [
            StockOverviewViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI(), analyticsLogger: AnalyticsLogger()),
            StockAnalysisViewController(ticker: ticker, companyName: companyName, networkingAPI: IntrinioAPI(), analyticsLogger: AnalyticsLogger())
        ]
        controllers.forEach { (controller) in
            controller.delegate = self
        }
        return controllers
    }
    
    lazy var notesButton: NotesButton = {
        let button = NotesButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenNotes)))
        return button
    }()
    
    lazy var saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(saveCompany), for: .touchUpInside)
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
        collectionView.backgroundColor = .groupTableViewBackground
        
        AppStoreReviewHelper.checkAndAskForReview(checkType: .importantAction)
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        performSelector(inBackground: #selector(loadSavedStocks), with: nil)
    }
    
    
    // MARK: - Core Data
    
    @objc private func loadSavedStocks() {
        let request = SavedStock.createfetchRequest()
        do {
            savedStocks = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            for savedStock in savedStocks {
                if savedStock.ticker == ticker {
                    DispatchQueue.main.async { self.saveButton.isSelected = true }
                    break
                } else {
                    DispatchQueue.main.async { self.saveButton.isSelected = false }
                }
            }
        } catch {
            print("Fetch failed", error.localizedDescription)
        }
    }
    
    private func removeFavorite() {
        let fetchRequest = SavedStock.createfetchRequest()
        let context = PersistenceService.shared.persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", ticker)
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc fileprivate func saveCompany(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let savedStock = SavedStock(context: PersistenceService.shared.persistentContainer.viewContext)
        savedStock.notes = ""
        savedStock.ticker = self.ticker
        savedStock.companyName = self.companyName
        if !sender.isSelected { removeFavorite() }
        PersistenceService.shared.saveContext()
        if sender.isSelected {
            Vibration.light.vibrate()
            AnalyticsLogger.reportEvents(event: .savedTicker(ticker: self.ticker))
        }
    }
    
    
    // MARK: - UIPopOverPresentationDelegate Methods
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overCurrentContext
    }
    
    
    // MARK: - Delegate Methods
    
    func displaySuccessNote() {
        InformationViewPresenter.displaySuccessActionView(in: self)
    }
    
    
    // MARK: - Actions
    
    @objc fileprivate func handleOpenNotes( _ sender: UIBarButtonItem) {
        let notesVC = NotesViewController(delegate: self)
        let navVC = UINavigationController(rootViewController: notesVC)
        notesVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 400)
        notesVC.modalPresentationStyle = .popover
        notesVC.popoverPresentationController?.delegate = self
        present(navVC, animated: true, completion: nil)
    }

    fileprivate func configureNavBar() {
        navigationItem.title = "\(ticker)"
        let notes = UIBarButtonItem(customView: notesButton)
        let save = UIBarButtonItem(customView: saveButton)
        let spacer = UIBarButtonItem(customView: UIView())
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [save,spacer,spacer, notes]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
    }

}














