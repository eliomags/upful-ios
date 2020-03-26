//
//  ResultsTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/18/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CompanyPreviewTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let companyTickerLabel: UILabel = {
        let l = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout).pointSize
        l.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        l.text = ""
        return l
    }()
    
    let companyNameLabel: UILabel = {
        let l = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1).pointSize
        l.font = UIFont.systemFont(ofSize: size, weight: .bold)
        l.textColor = .gray
        l.text = ""
        return l
    }()
    
    private lazy var companyDescriptionStackView: UIStackView = {
        let l = UIStackView(arrangedSubviews: [companyTickerLabel,companyNameLabel])
        l.axis = .vertical
        l.spacing = 1
        return l
    }()
    
    let marketcapStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.marketcap.explicit)
        sv.valueLabel.text = "$ -"
        return sv
    }()
    
    let pricetoearningsStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.pricetoearnings.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    
    let quoteView: StockQuoteView = {
        let v = StockQuoteView(priceLabelFontSize: 15, priceChangeLabelFontSize: 16, priceChangeLabelWidth: 70)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 100).isActive = true
        v.priceLabel.text = "$ -"
        v.percentChangeView.percentChangeLabel.text = "- %"
        v.setNegative()
        return v
    }()

    lazy var companyFundamentalsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [marketcapStackView, pricetoearningsStackView])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 3
        return sv
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        addSubview(quoteView)
        quoteView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quoteView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        
        addSubview(companyDescriptionStackView)
        companyDescriptionStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: quoteView.layoutMarginsGuide.leadingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 24))
        
        addSubview(companyFundamentalsStackView)
        companyFundamentalsStackView.anchor(
            top: companyDescriptionStackView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: quoteView.layoutMarginsGuide.leadingAnchor,
            padding: .init(top: 4, left: 32, bottom: 12, right: 16))
        
        addBottomSeparator()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        companyTickerLabel.text = ""
        companyNameLabel.text = ""
        marketcapStackView.valueLabel.text = "$ -"
        pricetoearningsStackView.valueLabel.text = "-"
        
        // TODO: - Add Reuse for stock quote data
    }
}

