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
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-star-30 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-star-30 (2)").withRenderingMode(.alwaysOriginal), for: .selected)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
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
        ticker = ""
        companyName = ""
        super.init(coder: aDecoder)
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
    }
    
    
    // MARK: - UIPopOverPresentationDelegate Methods
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overCurrentContext
    }
    
    
    // MARK: - Delegate Methods
    
    func displaySuccessNote() {
        ViewPresenter.displaySuccessActionView(in: self)
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
        let notes = UIBarButtonItem(title: "Notes", style: .done, target: self, action: #selector(handleOpenNotes))
        let save = UIBarButtonItem(customView: saveButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [save, notes]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
    }

}














