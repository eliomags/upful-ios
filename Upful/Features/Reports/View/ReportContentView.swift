//
//  ReportContentView.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ReportContentView: UIView {
    
    lazy var contentHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.text = "Description:"
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Description"
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                textView.textColor = .lightGray
                textView.backgroundColor = UIColor(white: 0.98, alpha: 1)
            }
            if traitCollection.userInterfaceStyle == .dark {
                textView.textColor = .white
            }
        } else {
            textView.textColor = .darkGray
            textView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        }
        textView.layer.cornerRadius = 4
        textView.layer.masksToBounds = true
        return textView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appAccent3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentHeaderLabel)
        contentHeaderLabel.anchor(
            top: layoutMarginsGuide.topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 22, left: 16, bottom: 0, right: 16))
        
        addSubview(textView)
        textView.anchor(
            top: contentHeaderLabel.bottomAnchor,
            leading: layoutMarginsGuide.leadingAnchor,
            bottom: nil,
            trailing: layoutMarginsGuide.trailingAnchor,
            padding: .init(top: 24, left: 8, bottom: 0, right: 8),
            size: .init(width: 0, height: (UIScreen.main.bounds.height/3) - 70))
        
        addSubview(submitButton)
        submitButton.anchor(
            top: textView.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 16, left: 32, bottom: 0, right: 32),
            size: .init(width: 0, height: 40))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

