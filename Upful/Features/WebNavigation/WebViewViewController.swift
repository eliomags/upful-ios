//
//  WebViewViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, NoteVCDelegate {
    
    // MARK: - Dependencies
    
    let urlString: String
    
    var headerText: String {
        return "News"
    }
    
    
    // MARK: - Views
    
    var webView: WKWebView!

    
    // MARK: - Inititializer Methods
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        setUpWebView()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let url = URL(string: urlString)
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationItem.title = headerText
        let notesButton = UIBarButtonItem(title: "Notes", style: .done, target: self, action: #selector(handleNotesTap))
        navigationItem.rightBarButtonItem = notesButton
    }
    
    fileprivate func setUpWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    
    @objc fileprivate func handleNotesTap(_ sender: UIButton) {
        let notesVC = NotesViewController(delegate: self)
        let navVC = UINavigationController(rootViewController: notesVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Delegate Methods
    
    func displaySuccessNote() {
        InformationViewPresenter.showSaveSuccess(in: self)
    }
    
}









