//
//  ViewSuggestionsVC.swift
//  Upful
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ViewSuggestionsVC: UIViewController {
    
    // MARK: - Dependencies
    
    var suggestionDataLoader: SuggestionsLoaderProtocol? = SuggestionDataLoader()
    
    // MARK: - State
    
    var suggestions: [Suggestion] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Views
    
    lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = VersionManager.mainContainerBackground()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        loadSuggestions()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Suggestions"
    }
    
    // MARK: - Private Functions
    
    fileprivate func loadSuggestions() {
        suggestionDataLoader?.load { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.suggestions = data
   
            case .failure(_):
                break
            }
        }
    }
    
    func incrementSuggestion(indexPath: IndexPath) {
        suggestions[indexPath.item].votes += 1
    }
    
  
}

extension ViewSuggestionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let suggestion = suggestions[indexPath.item]
        cell.textLabel?.text = suggestion.title
        cell.detailTextLabel?.text = suggestion.description
        return cell
    }
}

extension ViewSuggestionsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        incrementSuggestion(indexPath: indexPath)
    }
}








