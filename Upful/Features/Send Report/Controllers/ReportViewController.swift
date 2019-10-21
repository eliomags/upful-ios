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
    
    weak var delegate: ReportDelegate?
    
    // MARK: - Views
    
    lazy var reportContentView: ReportContentView = {
        let view = ReportContentView()
        view.contentHeaderLabel.text = reportInstructions
        view.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        view.textView.delegate = self
        view.textView.text = "Add description"
        view.textView.textColor = .lightGray
        return view
    }()
    
    lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancel)))
        return button
    }()
        
    // MARK: - Initializer Methods
    
    init(title: String, reportInstructions: String) {
        self.headerTitle = title
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
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
                self.delegate?.showSuccess()
            }
        })
    }
    
    // MARK: - Helpers
    
    func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.instance.reportEvents(event: .suggestion(description: description))
        completion()
    }
    
    // MARK: - Delegate Methods
    
    var reportText = ""
    
    func textViewDidChange(_ textView: UITextView) {
        reportText = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = "Add description"
        }
    }
    
}

final class SuggestionViewController: ReportViewController{
    override func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.instance.reportEvents(event: .suggestion(description: description))
        completion()
    }
}

final class IssueViewController: ReportViewController {
    override func submitReport(description: String, completion: (() -> ())) {
        AnalyticsLogger.instance.reportEvents(event: .issue(description: description))
        completion()
    }
}

