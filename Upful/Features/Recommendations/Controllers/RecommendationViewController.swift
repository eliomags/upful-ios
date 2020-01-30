//
//  RecommendationViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 1/30/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var cancelButton: CancelButton = {
        let view = CancelButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelTap)))
        return view
    }()
    
    private lazy var upfulImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "AppIcon"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8
        return v
    }()
    
    private let howLikelyLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        l.text = "How likely are you to recommend Upful to your friends, family or colleagues?"
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let likliehoodStackView: UIStackView = {
        let notlikelyLabel = UILabel()
        notlikelyLabel.text = "Not Likely"
        notlikelyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        notlikelyLabel.textAlignment = .left
        notlikelyLabel.textColor = .gray
        
        let verylikelyLabel = UILabel()
        verylikelyLabel.text = "Extremely Likely"
        verylikelyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        verylikelyLabel.textAlignment = .right
        verylikelyLabel.textColor = .gray
        
        let sv = UIStackView(arrangedSubviews: [notlikelyLabel, verylikelyLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var choiceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: (0...10).map { "\($0)" })
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sc.addTarget(self, action: #selector(handleRatingSeclection), for: .valueChanged)
        return sc
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Not Right Now", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupPresentation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupPresentation() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = upfulImageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    fileprivate func setupContentView() {
        view.addSubview(choiceSegmentedControl)
        choiceSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        choiceSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        
        view.addSubview(likliehoodStackView)
        likliehoodStackView.bottomAnchor.constraint(equalTo: choiceSegmentedControl.topAnchor, constant: -6).isActive = true
        likliehoodStackView.leadingAnchor.constraint(equalTo: choiceSegmentedControl.leadingAnchor, constant: 2).isActive = true
        likliehoodStackView.trailingAnchor.constraint(equalTo: choiceSegmentedControl.trailingAnchor, constant: -2).isActive = true
        
        view.addSubview(howLikelyLabel)
        howLikelyLabel.bottomAnchor.constraint(equalTo: likliehoodStackView.topAnchor, constant: -45).isActive = true
        howLikelyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        howLikelyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        view.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: choiceSegmentedControl.bottomAnchor, constant: 55).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: choiceSegmentedControl.leadingAnchor, constant: 2).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: choiceSegmentedControl.trailingAnchor, constant: -2).isActive = true
        
        view.addSubview(restoreButton)
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 12),
            restoreButton.leadingAnchor.constraint(equalTo: choiceSegmentedControl.leadingAnchor, constant: 2),
            restoreButton.trailingAnchor.constraint(equalTo: choiceSegmentedControl.trailingAnchor, constant: -2)
        ])
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleCancelTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRatingSeclection(_ sender: UISegmentedControl) {
        submitButton.isEnabled = true
        if submitButton.isEnabled { submitButton.backgroundColor = .appAccent3 }
    }
    
    @objc fileprivate func handleSubmitTap(_ sender: UIButton) {
        // TODO: - Send selected as analytics event
        
    }
}
