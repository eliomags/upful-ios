//
//  PercentChangeView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/24/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class PercentChangeView: UIView {
    let percentChangeLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(percentChangeLabel)
        percentChangeLabel.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNegative() {
        percentChangeLabel.textColor = .systemRed
    }
    func showPositive() {
        percentChangeLabel.textColor = .systemGreen
    }
    func showNeutral() {
        percentChangeLabel.textColor = .systemGray
    }
}
