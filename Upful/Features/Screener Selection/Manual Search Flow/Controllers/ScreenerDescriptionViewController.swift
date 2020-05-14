//
//  ScreenerDescriptionViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 5/9/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ScreenerDescriptionViewController: UIViewController {
    
    // MARK: Properties
    
    var titleString: String?
    var descriptionString: String?
    var equation: String?
    
    // MARK: Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleString
        label.textAlignment = .center
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var equationLabel: UILabel = {
        let label = UILabel()
        label.text = equation
        label.numberOfLines = 0
        label.textAlignment = .center
        let size = UIFont.preferredFont(forTextStyle: .caption2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = descriptionString
        let size = UIFont.preferredFont(forTextStyle: .callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [equationLabel, descriptionLabel])
        sv.spacing = 12
        sv.axis = .vertical
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleDismiss)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1, animations: {
            self.configureContentView()
        })
    }
    
    fileprivate func configureContentView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -24),
        ])
        
        contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8)
        ])
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -24)
        ])
        
        contentView.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: 24),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -16),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 12),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -12),
        ])
    }
    
    // MARK: Actions
    
    @objc fileprivate func handleDismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
