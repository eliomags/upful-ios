//
//  SubscriptionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SubscriptionViewController: UITableViewController, SubscriptionFeatureDataSource {
    
    // MARK: - Data
    
    var subscriptionOfferings: [SubscriptionFeatureViewModel] = []
    var subscriptionData: [[SubscriptionItemViewModel]] = []
    
    
    // MARK: - Views
    
    lazy var subscriptionDetailsCollectionView: SubscriptionDetailsCollectionView = {
        let view = SubscriptionDetailsCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = self
        return view
    }()
    
    lazy var footerView: SubscriptionFooterView = {
        let view = SubscriptionFooterView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var cancelButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.95)
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        let cancelImageView = UIImageView(image: #imageLiteral(resourceName: "icons8-delete-15").withRenderingMode(.alwaysOriginal))
        cancelImageView.backgroundColor = .clear
        
        view.addSubview(cancelImageView)
        cancelImageView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 7, left: 7, bottom: 7, right: 7))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelTap)))
        return view
    }()
    
    
    // MARK: - Initializer FMethods
    
    override init(style: UITableView.Style) {
        super.init(style: .plain)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.zero
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.isScrollEnabled = false
        tableView.estimatedSectionHeaderHeight = 0
        setupNavBar()
        setupPresentation()
        setUpSubscritionData()
        setupSubscriptionFeatures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
        setupDefaultSelection()
    }
    
    
    // MARK: - Data Setup
    
    fileprivate func setupSubscriptionFeatures() {
        let features = [
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Unlimited Saving", description: "Save as many screeners and stocks as you want")),
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Unlimited Daily Screens", description: "Screen for as many stocks as you want each day")),
            SubscriptionFeatureViewModel(subscriptionFeature: SubscriptionFeature(title: "Notes Access", description: "Get access to notes"))
        ]
        self.subscriptionOfferings = features
    }
    
    fileprivate func setUpSubscritionData() {
        let subscriptions = [
            SubscriptionItem(subscriptionDuration: 1, monthlyPricing: SubscriptionItemViewModel.oneMonthPricing),
            SubscriptionItem(subscriptionDuration: 1, monthlyPricing: SubscriptionItemViewModel.oneMonthPricing),
            SubscriptionItem(subscriptionDuration: 6, monthlyPricing: 10.99),
            SubscriptionItem(subscriptionDuration: 12, monthlyPricing: 7.99)
        ]
        self.subscriptionData = subscriptions.map({ [SubscriptionItemViewModel(subscriptionItem: $0)] })
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    fileprivate func setupPresentation() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .appAccent2
        navigationController?.navigationBar.barTintColor = .appAccent2
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Upgrade"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    fileprivate func setupDefaultSelection() {
        tableView.selectRow(at: IndexPath(row: 0, section: 1), animated: true, scrollPosition: .bottom)
    }
    
    
    // MARK: - Actions
    
    @objc fileprivate func handleCancelTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TableView DataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .appAccent2
            display(contentController: subscriptionDetailsCollectionView, on: cell)
            return cell
            
        case 1,2,3:
            let cell = SubscriptionTableViewCell(style: .default, reuseIdentifier: nil)
            if section == 1 { cell.monthLabel.text = "month" }
            if section != 1 { cell.setSavingsViews() }
            cell.durationLabel.text = subscriptionData[indexPath.section][indexPath.row].subscriptionDuration
            cell.monthlyPricingLabel.text = subscriptionData[indexPath.section][indexPath.row].monthlyPricing
            cell.dueNowPricingLabel.text = subscriptionData[indexPath.section][indexPath.row].totalCost
            cell.savingsValueLabel.text = subscriptionData[indexPath.section][indexPath.row].savingPercentage
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section{
        case 0: return nil
        default: return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return tableView.frame.height / 4
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        if section == 1 { return 15 }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3 { return footerView }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 { return 250 }
        return 0
    }
}


