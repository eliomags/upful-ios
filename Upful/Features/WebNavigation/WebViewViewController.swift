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

    lazy var dismissButton: CancelButton = {
        let b = CancelButton()
        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissTap)))
        return b
    }()
    
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
        LoadingViewPresenter.show(in: self)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupNavBar() {
        navigationItem.title = headerText
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
    
    fileprivate func setUpWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleDismissTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - Delegate Methods
    
    func displaySuccessNote() {
        InformationViewPresenter().showSaveSuccess(in: self)
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingViewPresenter.remove()
    }
}











