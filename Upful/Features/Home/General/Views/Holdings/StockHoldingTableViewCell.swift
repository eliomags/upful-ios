//
//  StockHoldingTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 3/20/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockHoldingTableViewCell: UITableViewCell {

    // MARK: - Intiailizer

    let tickerLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let numberOfSharesLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tickerLabel, numberOfSharesLabel])
        sv.axis = .vertical
        sv.spacing = 6
        return sv
    }()
    
    
    let currentPriceLabel: UILabel = {
       let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let averagePriceLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceDescriptionLabel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [currentPriceLabel, averagePriceLabel])
        sv.axis = .vertical
        sv.spacing = 6
        return sv
    }()
    
    
    let dollarChangeLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let percentChangeView: PercentChangeView = {
        let view = PercentChangeView()
        return view
    }()
    
    private lazy var priceChangeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [percentChangeView, dollarChangeLabel])
        sv.axis = .vertical
        sv.spacing = 6
        return sv
    }()
    
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionStackView, priceDescriptionLabel, priceChangeStackView])
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.spacing = 6
        return sv
    }()
    
    // MARK: - Intiailizer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(contentStackView)
        contentStackView.anchor(top: layoutMarginsGuide.topAnchor,
                                leading: layoutMarginsGuide.leadingAnchor,
                                bottom: layoutMarginsGuide.bottomAnchor,
                                trailing: layoutMarginsGuide.trailingAnchor)
        addBottomSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tickerLabel.text = ""
        numberOfSharesLabel.text = ""
        currentPriceLabel.text = ""
        averagePriceLabel.text = ""
        dollarChangeLabel.text = ""
        percentChangeView.percentChangeLabel.text = ""
        percentChangeView.showNeutral()
    }
}
