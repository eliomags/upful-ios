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
        view.addSubview(tableView)
        tableView.fillSuperview()
    }

    fileprivate func initializeFeedData() {
        let placeHolder: [HomeFeedItem] = []
        homeFeedItems.append(placeHolder)
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
}

extension HomeFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1: return 1
        case 2: return homeFeedItems[section].count
        default: return homeFeedItems[section].count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeFeedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
             case 0:
                let choiceCell = HomeFeedStateCell()
                // create delegate methods and use call backs
                // This will change the datasource to get the manual cell
                return choiceCell
        case 1:
            let companyCell = PopularCompanyTableViewCell(popularCompanies: homeFeedItems[indexPath.section])
            return companyCell
        case 2,3,4:
            guard let screenerData = homeFeedItems[indexPath.section][indexPath.row] as? PresetScreener else { return emptyCell }
            let screenerCell = PresetScreenerTableViewCell(company: screenerData)
            return screenerCell
            
        default: return emptyCell
        }
    }
}

extension HomeFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 50
        case 1: return 200
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderLabel(padding: 16)
        let labelText = [
            "",
            "Popular Companies",
            "Explore value stock screens",
            "Explore growth stock screens",
            "Explore dividend stock screens"
        ]
        header.text = labelText[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

struct TestData: Decodable {
    var name: String?
}






