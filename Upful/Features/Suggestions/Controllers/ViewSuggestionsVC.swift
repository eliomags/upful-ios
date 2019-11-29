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
    
    enum State {
        case pending
        case loading
        case loaded
        case error
    }
    
    var state: State = .pending {
        didSet {
            showActivitySpinner(state == .loading)
            self.tableView.reloadData()
        }
    }
    
    var suggestions: [Suggestion] = []

    // MARK: - Views
    
    lazy var loadingView: UIView = {
        let v = UIView()
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.startAnimating()
        v.addSubview(activityView)
        activityView.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor,
                            padding: .init(top: 30, left: 30, bottom: 30, right: 30))
        v.layer.cornerRadius = 15
        v.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return v
    }()

    lazy var tableHeader: PreferenceHeaderView = {
        let v = PreferenceHeaderView()
        v.headerLabel.text = ""
        v.descriptionText.text = "Double tap any suggestion to show your interest. You can vote as many times as you wish."
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return v
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = VersionManager.mainContainerBackground()
        tv.register(SuggestionViewCell.self, forCellReuseIdentifier: "suggestionCell")
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.setTableHeaderView(headerView: tableHeader)
        return tv
    }()
    
    lazy var addSuggestionButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitle("Add Suggestion", for: .normal)
        button.backgroundColor = .appAccent3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(navigateToAddPreference), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSuggestionsButton()
        setupTableView()
        loadSuggestions()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupSuggestionsButton() {
        view.addSubview(addSuggestionButton)
        addSuggestionButton.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 16, right: 16),
            size: .init(width: 0, height: 40))
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(
            top: view.layoutMarginsGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: addSuggestionButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    fileprivate func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Suggestions"
    }
    
    func showActivitySpinner(_ shouldShowSpinner: Bool) {
        if shouldShowSpinner {
            view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        if !shouldShowSpinner {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Private Functions
    
    fileprivate func loadSuggestions() {
        state = .loading
        suggestionDataLoader?.load { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.suggestions = data
                self.state = .loaded
                
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func incrementSuggestion(indexPath: IndexPath) {
        suggestions[indexPath.item].votes += 1
        tableView.reloadData()
        let id = suggestions[indexPath.item].id
        suggestionDataLoader?.updateVote(document: id)
    }
    
    @objc fileprivate func navigateToAddPreference() {
        let presenter = ReportPresenter(reportType: .suggestion)
        presenter.present(in: self)
    }

    deinit {
        suggestionDataLoader?.commitVotes()
    }
}

extension ViewSuggestionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let loaded = state == .loaded
        if state == .error {
            tableView.setEmptyView(state: .emptyState(title: "Error Getting Suggestions.", message: ""))
        } else {
            tableView.restore()
        }
        return loaded ? suggestions.count: 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let loaded = state == .loaded
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath) as? SuggestionViewCell else { return UITableViewCell() }
        let suggestion = suggestions[indexPath.item]
        cell.titleLabel.text = suggestion.title
        cell.descriptionLabel.text = suggestion.description
        cell.voteCountLabel.text = "\(suggestion.votes)"
        cell.doubleTappedAction = { [weak self] in
            guard let self = self else { return }
            self.incrementSuggestion(indexPath: indexPath)
        }
        return loaded ? cell: UITableViewCell()
    }
}

extension ViewSuggestionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}




