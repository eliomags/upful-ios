//
//  SubscriptionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol PresentationControllerDelegate: UIViewController {
    func presentationControllerdDidDismiss()
}

class SubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    deinit {
        if !PermissionManager.shared.isPremium && presenterType == .screeningLimit {
            presentationDelegate?.showNotificationSetupView()
        }
    }
    
    // MARK: - Dependencies
        
    var headerText: String {
        var text = ""
        switch presenterType {
            
        case .savedStockLimit:
            text = "You've reached your limit for saved stocks.\nGet Premium to unlock unlimited access."
        case .savedScreenerLimit:
            text = "You've reached your limit for saved screeners.\nGet Premium to unlock unlimited access."
        case .screeningLimit:
            text = "You've reached your daily limit for stock screens.\nGet Premium to unlock unlimited access."
        case .settings:
            text = "Upgrade to Premium."
        }
        return text
    }
    
    let presenterType: SubscriptionPresenter.PresenterType
    
    lazy var viewModel: SubscriptionViewModel = {
        let vm = SubscriptionViewModel()
        return vm
    }()

    weak var presentationDelegate: PresentationControllerDelegate?

    // MARK: - Views
    
    lazy var tableHeader: PreferenceHeaderView = {
        let v = PreferenceHeaderView()
        v.headerLabel.text = ""
        v.descriptionText.textColor = .label
        v.descriptionText.text = headerText
        v.descriptionText.font = UIFont(name: "AvenirNext-Bold", size: 16)
        v.descriptionText.textAlignment = .center
        return v
    }()
    
    lazy var subscriptionDetailsCollectionView: SubscriptionDetailsCollectionView = {
        let view = SubscriptionDetailsCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = viewModel.suscriptionDataService
        return view
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableV = UITableView(frame: .zero, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.setTableHeaderView(headerView: tableHeader)
        return tableV
    }()
    
    lazy var footerView: SubscriptionFooterView = { [unowned self] in
        let view = SubscriptionFooterView()
        view.subscribeButton.addTarget(self, action: #selector(handleSubscribeTap), for: .touchUpInside)
        view.restoreButton.addTarget(self, action: #selector(handleRestoreTap), for: .touchUpInside)
        view.privacyButton.addTarget(self, action: #selector(handlePrivacyTap), for: .touchUpInside)
        view.termsOfUseButton.addTarget(self, action: #selector(handleTermsOfUseTap), for: .touchUpInside)
        return view
    }()
    
    @objc fileprivate func handlePrivacyTap(_ sender: UIButton) {
        if let url = URL(string: Constants.Legal.privacyPolicy) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc fileprivate func handleTermsOfUseTap(_ sender: UIButton) {
        if let url = URL(string: Constants.Legal.termsOfUse) {
            UIApplication.shared.open(url)
        }
    }
    
    lazy var cancelButton: CancelButton = { [unowned self] in
        let view = CancelButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelTap)))
        return view
    }()
    
    // MARK: - Initializer Functions
    
    init(presenterType: SubscriptionPresenter.PresenterType) {
        self.presenterType = presenterType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPresentation()
        observeStateChanges()
    }

    func observeStateChanges() {
        viewModel.stateChanged = { [weak self] (state) in
            guard let self = self else { return }
            
            switch state {
            case .loaded:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.setupDefaultSelection()
                }
            case .paymentError(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "An error has occured while performing the purchase. Please contact support.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
                        self?.dismiss(animated: true, completion: nil)
                    }))
                    switch error {
                    case .paymentCancelled:
                        return
                    case .unknown:
                        alert.message = "Unknown error. Please contact support"
                    case .clientInvalid:
                        alert.message = "Not allowed to make the payment"
                    case .paymentNotAllowed:
                        alert.message = "The device is not allowed to make the payment"
                    case .storeProductNotAvailable:
                        alert.message = "The product is not available in the current storefront"
                    default:
                        break
                        }
                    self.present(alert, animated: true)
                    }
            case .paymentSuccess:
                self.dismiss(animated: true, completion: {
//                    self.presentationDelegate?.presentationControllerdDidDismiss()
                })
            default:
                break
            }
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.backgroundColor = VersionManager.mainContainerBackground()
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.estimatedSectionHeaderHeight = 0
    }
    
    fileprivate func setupPresentation() {
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "Premium"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    fileprivate func setupDefaultSelection() {
        tableView.selectRow(at: IndexPath(row: 0, section: 1), animated: true, scrollPosition: .bottom)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleCancelTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSubscribeTap(_ sender: UIButton) {
        AnalyticsLogger.instance.reportEvents(event: .signUpAttempt)
        Vibration.light.vibrate()
        viewModel.buySelectedProduct()
    }
    
    @objc fileprivate func handleRestoreTap(_ sender: UIButton) {
        Vibration.light.vibrate()

        sender.isEnabled = false
        viewModel.restorePurchase(completion: { [weak self] (success) in
          if !success {
              let actionVC = UIAlertController(title: "Purchase Not Found", message: "No purchase to restore.", preferredStyle: .alert)
              actionVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                sender.isEnabled = true
              }))
            self?.present(actionVC, animated: true, completion: nil)
          }
          if success {
              let actionVC = UIAlertController(title: "Success", message: "Your purchase has succesfully been restored.", preferredStyle: .alert)
              actionVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                sender.isEnabled = true
              }))
              self?.present(actionVC, animated: true, completion: nil)
          }
      })
    }
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.state {
        case .loaded(_): return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .secondarySystemBackground
            display(contentController: subscriptionDetailsCollectionView, on: cell)
            return cell
            
        case 1:
            let cell = SubscriptionTableViewCell(style: .default, reuseIdentifier: nil)
            if section == 1 { cell.monthLabel.text = "month" }
            switch viewModel.state {
            case .loaded:
                cell.durationLabel.text = viewModel.productViewModels[indexPath.section][indexPath.row].subscriptionDuration
                cell.monthlyPricingLabel.text = viewModel.productViewModels[indexPath.section][indexPath.row].monthlyPricing
                cell.dueNowPricingLabel.text = viewModel.productViewModels[indexPath.section][indexPath.row].totalCost
                cell.savingsValueLabel.text = viewModel.productViewModels[indexPath.section][indexPath.row].savingPercentage
                return cell
                
            default:
                break
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section{
        case 0: return nil
        default: return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.productViewModels[indexPath.section][indexPath.row].product
        viewModel.setSelectedProduct(product)
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return (tableView.frame.height / 4) + 20
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        if section == 1 { return 15 }
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return footerView }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 { return 300 }
        return 0
    }
}


