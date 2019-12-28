//
//  SentimentView.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class SentimentView: UIView {
    
    // MARK: - Initializer

    private let sentimentImageView: UIImageView = {
         let v = UIImageView()
         v.translatesAutoresizingMaskIntoConstraints = false
         v.heightAnchor.constraint(equalToConstant: 20).isActive = true
         v.widthAnchor.constraint(equalToConstant: 20).isActive = true
         return v
     }()
    
    let sentimentLabel: UILabel = {
         let l = UILabel()
         l.font = UIFont.preferredFont(forTextStyle: .footnote)
         l.text = "Positive"
         l.textColor = .appAccent3
         return l
     }()
     
     private lazy var sentimentStackView: UIStackView = {
         let sv = UIStackView(arrangedSubviews: [sentimentLabel])
         sv.translatesAutoresizingMaskIntoConstraints = false
         sv.spacing = 4
         sv.axis = .horizontal
         return sv
     }()
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        addSubview(sentimentStackView)
        sentimentStackView.fillSuperview(padding: .init(top: 2, left: 6, bottom: 2, right: 6))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    
    // MARK: - Methods
    
    func setSentiment(with sentiment: String) {
        if sentiment == "Positive" { setPositiveSentiment() }
        if sentiment == "Negative" { setNegativeSentiment() }
        if sentiment == "Neutral" { setNeutralSentiment() }
    }
    
    fileprivate func setPositiveSentiment() {
        sentimentLabel.textColor = .appAccent3
    }
    
    fileprivate func setNeutralSentiment() {
        sentimentLabel.textColor = .lightGray
    }
    
    fileprivate func setNegativeSentiment() {
        sentimentLabel.textColor = .systemRed
    }
}

