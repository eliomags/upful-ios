//
//  TradingBalanceTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 3/18/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class TradingBalanceView: UIView {
    
    // MARK: - Views
    
    let totalEquityView = TotalEquityView()
    let cashBalanceView = CashBalanceView()
    let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Updated, March 18, 2:19PM EST"
        label.translatesAutoresizingMaskIntoConstraints = false
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .light)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [totalEquityView, lastUpdatedLabel, cashBalanceView])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 200)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentStackView)
        contentStackView.anchor(top: layoutMarginsGuide.topAnchor,
                                leading: layoutMarginsGuide.leadingAnchor,
                                bottom: layoutMarginsGuide.bottomAnchor,
                                trailing: layoutMarginsGuide.trailingAnchor,
                                padding: .init(top: 16, left: 8, bottom: 24, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
