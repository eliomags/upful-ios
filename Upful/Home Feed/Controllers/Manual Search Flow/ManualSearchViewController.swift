//
//  ManualSearchViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ManualSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManualSearchDelegate {
    
    var manualScreenItems: [ManualScreener] = [] {
        didSet {
            manualSearchSearchTableView.reloadData()
        }
    }

    
    // MARK:- Views
    
    lazy var header: ManualSearchHeaderView = {
        let v = ManualSearchHeaderView()
        return v
    }()
    
    class CustomRoundButton: UIButton {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 55, height: 55)
        }
    }
    
    let addCriteriaButton: CustomRoundButton = {
        let b = CustomRoundButton(type: .system)
        b.setBackgroundImage(#imageLiteral(resourceName: "icons8-plus-math-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = b.intrinsicContentSize.height / 2
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleAddCriteria), for: .touchUpInside)
        b.setupShadow(intensity: .medium, color: .black)
        return b
    }()
    
    class CustomButton: UIButton {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 40)
        }
    }
    
    lazy var searchButton: CustomButton = {
        let b = CustomButton(type: .system)
        b.setTitle("SEARCH", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .negative
        b.layer.masksToBounds = true
        b.layer.cornerRadius = b.bounds.height / 2
        b.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        b.setupShadow(intensity: .light, color: .black)
        return b
    }()
    
    lazy var manualSearchSearchTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .backgroundColor
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var footer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.addSubview(searchButton)
        searchButton.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 48, left: 16, bottom: 8, right: 10))
        return v
    }()
    
    
    // MARK:- Initializer Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(manualSearchSearchTableView)
        manualSearchSearchTableView.fillSuperview()
        
        view.addSubview(addCriteriaButton)
        addCriteriaButton.anchor(
            top: nil, leading: nil, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 30, right: 22))
        
        animateButton()
    }
    
    
    // MARK:- Views
    
    fileprivate func animateButton() {
        // Check user defaults if person has completed
        // If hasNavigatedToManualScreen == false
        UIView.animate(withDuration: 0.5, animations: {
            self.addCriteriaButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.addCriteriaButton.transform = .identity
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.addCriteriaButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }) { (_) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.addCriteriaButton.transform = .identity
                    })
                }
            })
        }
        // Person has completed so add to user defaults
        // hasNavigatedToManualScreen, true
    }


    // MARK:- Actions
    
    @objc fileprivate func handleAddCriteria(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = .identity
            }, completion: { (_) in
                let searchCriteriaVC = SearchCriteriaTableViewController(style: .grouped)
                searchCriteriaVC.delegate = self
                self.navigationController?.pushViewController(searchCriteriaVC, animated: true)
            })
        }
    }
    
    @objc fileprivate func handleSearch(_ sender: UIButton) {
        if manualScreenItems.isEmpty {
            presentAlert()
            return
        }
        for item in manualScreenItems {
            if item.parameter == .none {
                presentAlert()
                return
            }
        }
        
        let screenerResultsVC = ScreenResultsViewController(searchParameters: configureURLComponents())
        navigationController?.pushViewController(screenerResultsVC, animated: true)
    }
    
    fileprivate func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        manualScreenItems.forEach { (manualScreenerItem) in
            urlComponents.append(manualScreenerItem.criteria.rawValue + "\(manualScreenerItem.parameter.rawValue)~\(manualScreenerItem.value ?? 0)")
        }
        return urlComponents
    }
    
    fileprivate func presentAlert() {
        let alert = UIAlertController(title: "Search Failed", message: "Please add a search parameter to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK:- Delegate Methods
    
    func addSearchCriteria(criteria: ManualScreener) {
        manualScreenItems.append(criteria)
    }
    
    func addSearchParameter(parameterItem: ParameterItem, indexPath: IndexPath) {
        manualScreenItems[indexPath.item].parameter = parameterItem.parameter
        manualScreenItems[indexPath.item].value = parameterItem.value
    }
    
    
    // MARK:- Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return manualScreenItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = manualScreenItems[indexPath.item].criteria.explicit
        
        if manualScreenItems[indexPath.item].parameter != .none {
            if manualScreenItems[indexPath.item].criteria.parameterType == .percentage {
                cell.detailTextLabel?.text = manualScreenItems[indexPath.item].parameter.explicit + " " + "\(manualScreenItems[indexPath.item].value!.convertToPercent())%"
            }
            if manualScreenItems[indexPath.item].criteria.parameterType == .ratio {
                cell.detailTextLabel?.text = manualScreenItems[indexPath.item].parameter.explicit + " " + String(Int(manualScreenItems[indexPath.item].value ?? 0))
            }
        } else {
            cell.detailTextLabel?.text = manualScreenItems[indexPath.item].parameter.explicit
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchParamsVC = ManualSearchParametersTableViewController(selectedIndexPath: indexPath, screenerItem: manualScreenItems[indexPath.item])
        searchParamsVC.delegate = self

        self.navigationController?.pushViewController(searchParamsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            self.manualScreenItems.remove(at: indexPath.row)
        }
        delete.backgroundColor = .lightGray
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return footer
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








