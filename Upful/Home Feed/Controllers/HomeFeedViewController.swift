//
//  ViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class HomeFeedViewController: UIViewController {

    // MARK:- Dependencies
    
    var homeFeedItems: [[HomeFeedItem]] = []  {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK:- Views
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        return tv
    }()
    
    lazy var stateView: HomeFeedStateView = {
        let v = HomeFeedStateView()
        v.delegate = self
        return v
    }()
    
    
    // MARK:- Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavBar()
        setupTableView()
        initializeFeedData()
    }
    
    // MARK:- View Setup
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(stateView)
        stateView.anchor(
            top: view.layoutMarginsGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 40))
        view.addSubview(tableView)
        tableView.anchor(
            top: stateView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor)
    }

    fileprivate func initializeFeedData() {
        homeFeedItems.append(CompanyViewModel.configureCompanyList())
        homeFeedItems.append(PresetScreenverViewModel.configureValueData())
        homeFeedItems.append(PresetScreenverViewModel.configureGrowthData())
        homeFeedItems.append(PresetScreenverViewModel.configureDividendData())
    }
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    fileprivate func configureNetworkingData() {
        NetworkService.shared.getScreenRequest(url: "", t: TestData.self) { (result) in
            switch result {
            case .success(let fetchedData):
                print(fetchedData)
            case .failure(let error):
                switch error {
                case .failedNetworking:
                    print("Failed Networking")
                case .noData:
                    print("No Data to parse")
                case .parsingError:
                    print("Error Parsing Data")
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
        let translationDistance = stateView.bounds.height
        if position > 0 {
            UIView.animate(withDuration: 0.2) {
                self.stateView.transform = .identity
                self.tableView.transform = .identity
            }
        }
        if position < 0 {
            UIView.animate(withDuration: 0.2) {
                self.stateView.transform = CGAffineTransform(translationX: 0, y: -translationDistance)
                self.tableView.transform = CGAffineTransform(translationX: 0, y: -translationDistance)
            }
        }
    }
}

extension HomeFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default: return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeFeedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 0:
            let companyCell = PopularCompanyTableViewCell(popularCompanies: homeFeedItems[indexPath.section])
            return companyCell
        case 1,2,3:
            guard let screenerData = homeFeedItems[indexPath.section] as? [PresetScreener] else { return emptyCell }
            let screenerCell = PresetScreenerTableViewCell(searches: screenerData)
            return screenerCell
        default:
            return emptyCell
        }
    }
}

extension HomeFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 200
        case 1,2,3: return 275
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderLabel(padding: 16)
        let labelText = [
            "Popular Companies",
            "Explore value stock screens",
            "Explore growth stock screens",
            "Explore dividend stock screens"
        ]
        header.text = labelText[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

struct TestData: Decodable {
    var name: String?
}

extension HomeFeedViewController: HomeFeedStateDelegate {
    func configureQuickSearch() {
        print("Setting up Quick Search")
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func configureManualSearch() {
        print("Setting up Manual Search")
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}




