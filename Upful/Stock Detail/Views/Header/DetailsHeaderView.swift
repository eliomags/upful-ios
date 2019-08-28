//
//  DetailsHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class DetailsHeaderView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: superview?.frame.width ?? UIScreen.main.bounds.width,
                      height: 70)
    }
    
    let tickerLabel: UILabel = {
        let l = UILabel()
        l.text = "TWTR"
        l.backgroundColor = .yellow
        l.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return l
    }()
    
    let companyNameLabel: UILabel = {
        let l = UILabel()
        l.text = "Twitter Inc."
        l.backgroundColor = .blue
        l.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return l
    }()
    
    lazy var headerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tickerLabel, companyNameLabel])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 4
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(headerStackView)
        headerStackView.fillSuperview()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setLabels(ticker: String, companyName: String) {
        tickerLabel.text = ticker
        companyNameLabel.text = companyName
    }
 
}





