//
//  CashBalanceView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/18/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class CashBalanceView: UIView {
    
    // MARK: - Views
    
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.text = "CASH BALANCE:"
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let cashValueLabel: UILabel = {
        let label = UILabel()
        label.text = "$25,000"
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var cashStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cashLabel, cashValueLabel])
        sv.axis = .horizontal
        sv.spacing = 6
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(cashStackView)
        cashStackView.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 12))
        view.backgroundColor = UIColor.appAccent2.withAlphaComponent(0.5)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentBackgroundView)
        contentBackgroundView.fillSuperview()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
