//
//  TotalEquityView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/18/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class TotalEquityView: UIView {
    private let equityLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTAL BALANCE"
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        return label
    }()
    
    let equityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "$25,000.00"
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .black)
        return label
    }()
    
    let totalReturnLabel: UILabel = {
        let label = UILabel()
        label.text = "$0 • 0%"
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .black)
        return label
    }()
    
    private lazy var equityStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [equityLabel, equityValueLabel, totalReturnLabel])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.spacing = 5
        return sv
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(equityStackView)
        equityStackView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


