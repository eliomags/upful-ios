//
//  ReportViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 10/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITextViewDelegate {
    // MARK: - Dependencies
    
    let headerTitle: String
    let reportInstructions: String
    let analyticsMapper: AnalyticsLogger
    
    weak var delegate: ReportDelegate?
    
    // MARK: - Views
    
    lazy var reportContentView: ReportContentView = {
        let view = ReportContentView()
        view.contentHeaderLabel.text = reportInstructions
        view.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        view.textView.delegate = self
        return view
    }()
        
    // MARK: - Initializer Methods
    
    init(title: String, reportInstructions: String, analyticsMapper: AnalyticsLogger) {
        self.headerTitle = title
        self.analyticsMapper = analyticsMapper
        self.reportInstructions = reportInstructions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(reportContentView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        reportContentView.fillSuperview()
        setupNavBar()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = headerTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSubmit() {
        submitReport(description: reportText, completion: {
            self.dismiss(animated: true) {
                InformationViewPresenter.displaySuccessActionView(in: self.delegate as! UIViewController)
            }
        })
    }
    
    // MARK: - Helpers
    
    func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.reportEvents(event: .suggestion(description: description))
        completion()
    }
    
    // MARK: - Delegate Methods
    
    var reportText = ""
    
    func textViewDidChange(_ textView: UITextView) {
        reportText = textView.text
    }
    
}

final class SuggestionViewController: ReportViewController{
    override func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.reportEvents(event: .suggestion(description: description))
        completion()
    }
}

final class IssueViewController: ReportViewController {
    override func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.reportEvents(event: .issue(description: description))
        completion()
    }
}

