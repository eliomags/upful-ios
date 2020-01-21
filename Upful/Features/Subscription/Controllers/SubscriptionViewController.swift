//
//  SubscriptionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SubscriptionViewControllerDelegate: UIViewController {
    func presentationControllerdDidDismissWithoutSignup()
    func userDidSignUp()
}

class SubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    deinit {
        if !PermissionManager.shared.isPremium && presenterType == .screeningLimit {
            delegate?.showNotificationSetupView()
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
        case .fiveYearDataInterest:
            break
        }
        return text
    }
    
    let presenterType: SubscriptionPresenter.PresenterType
    weak var delegate: SubscriptionViewControllerDelegate?

    lazy var logicController: SubscriptionLogicController = {
        let vm = SubscriptionLogicController()
        return vm
    }()

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
    
    private let newHeader = SubscriptionHeaderView()
    
    lazy var tableView: UITableView = {
        let tableV = UITableView(frame: .zero, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.setTableHeaderView(headerView: newHeader)
        return tableV
    }()
    
    lazy var footerView: SubscriptionFooterView = {
        let view = SubscriptionFooterView()
        view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.9)
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
    
    lazy var cancelButton: CancelButton = {
        let view = CancelButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelTap)))
        return view
    }()
    
    // MARK: - Initializer Functions
    
    init(presenterType: SubscriptionPresenter.PresenterType) {
        self.presenterType = presenterType
        AnalyticsLogger.instance.reportEvents(event: .signUpForPremiumPresented(trigger: presenterType.rawValue))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupPresentation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeStateChanges()
    }

    func observeStateChanges() {
        logicController.stateChanged = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loading:
                break
            case .loaded:
                self.tableView.reloadData()
                self.setupDefaultSelection()
            case .paymentError(let error):
                let alert = UIAlertController(title: "Error",
                                              message: "An error has occured while performing the purchase. Please contact support.",
                                              preferredStyle: .alert)
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
                    
            case .paymentSuccess:
                self.dismiss(animated: true, completion: {
//                    if PermissionManager.shared.isPremium {
                        self.delegate?.userDidSignUp()
//                    }
                })
            default:
                break
            }
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor,
                         bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.addSubview(footerView)
        footerView.anchor(top: nil, leading: view.leadingAnchor,
                          bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.backgroundColor = VersionManager.mainContainerBackground()
        tableView.backgroundColor = VersionManager.mainContainerBackground()
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
    
    fileprivate func setupPresentation() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Premium"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    fileprivate func setupDefaultSelection() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleCancelTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSubscribeTap(_ sender: UIButton) {
        AnalyticsLogger.instance.reportEvents(event: .signUpAttempt)
        Vibration.light.vibrate()
        logicController.buySelectedProduct()
    }
    
    @objc fileprivate func handleRestoreTap(_ sender: UIButton) {
        Vibration.light.vibrate()
        
        sender.isEnabled = false
        logicController.restorePurchase(completion: { [weak self] (success) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch logicController.state {
        case .loaded(_):
            return logicController.productViewModels.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SubscriptionTableViewCell(style: .default, reuseIdentifier: nil)
        switch logicController.state {
        case .loaded:
            cell.monthlyPricingLabel.text = logicController.productViewModels[indexPath.row].monthlyPricing
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = logicController.productViewModels[indexPath.row].product
        logicController.setSelectedProduct(product)
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TableSectionHeaderView()
        headerView.headerTextLabel.text = "Options"
        headerView.addButton.setTitle("", for: .normal)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 250
    }
}


