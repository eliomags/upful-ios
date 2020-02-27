//
//  LargeStockQuoteView.swift
//  Upful
//
//  Created by Yanik Simpson on 2/24/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class LargeStockQuoteView: UIView {
    
    // MARK: - Views
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        return label
    }()

    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    lazy var quoteStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [priceLabel, priceChangeLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(quoteStackView)
        quoteStackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup

}

