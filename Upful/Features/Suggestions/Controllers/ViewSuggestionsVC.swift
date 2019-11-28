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
        tv.register(SuggestionViewCell.self, forCellReuseIdentifier: "suggestionCell")
        tv.separatorStyle = .none
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
        tableView.reloadData()
    }
    
}

extension ViewSuggestionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath) as? SuggestionViewCell else { return UITableViewCell() }
        let suggestion = suggestions[indexPath.item]
        cell.titleLabel.text = suggestion.title
        cell.descriptionLabel.text = suggestion.description
        cell.voteCountLabel.text = "\(suggestion.votes)"
        return cell
    }
}

extension ViewSuggestionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        incrementSuggestion(indexPath: indexPath)
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            selectedCell?.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
               selectedCell?.transform = .identity
           }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
}








