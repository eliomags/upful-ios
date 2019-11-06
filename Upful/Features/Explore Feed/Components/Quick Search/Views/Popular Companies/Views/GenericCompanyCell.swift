//
//  GenericCompanyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 11/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericCompanyCollectionViewCell: UICollectionViewCell {
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        return label
    }()

    lazy var companyDescriptionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tickerLabel, companyNameLabel])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 1
        return sv
    }()
    
    lazy var marketcapStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: "Market Cap")
        return sv
    }()
    
    lazy var peStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: "Price/Earnings")
        return sv
    }()
    
    lazy var stockDetailsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [marketcapStackView, peStackView])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        return sv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? highlightedAnimation() : unHighlightedAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = VersionManager.collectionCellColor2(in: self)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.25
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(companyDescriptionStackView)
        companyDescriptionStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 12, left: 6, bottom: 0, right: 0))
        
        companyNameLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        
        addSubview(stockDetailsStackView)
        stockDetailsStackView.anchor(
            top: companyDescriptionStackView.bottomAnchor, leading: companyDescriptionStackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 8, right: 6))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureLabels(company: PopularCompany) {
        tickerLabel.text = company.header
        companyNameLabel.text = company.details
        marketcapStackView.valueLabel.text = "$\(company.marketcap?.formatUsingAbbreviation() ?? " -")"
        peStackView.valueLabel.text = company.priceToEarnings?.twoDecimal() ?? " -"
    }
    
    
    func setLoadingLabels() {
        companyNameLabel.backgroundColor = VersionManager.loadingLabelColor(in: self)
        tickerLabel.backgroundColor = VersionManager.loadingLabelColor(in: self)
        marketcapStackView.valueLabel.backgroundColor = VersionManager.loadingLabelColor(in: self)
        peStackView.valueLabel.backgroundColor = VersionManager.loadingLabelColor(in: self)
    }
    
    func setLoadedLabels() {
        companyNameLabel.backgroundColor = .clear
        tickerLabel.backgroundColor = .clear
        marketcapStackView.valueLabel.backgroundColor = .clear
        peStackView.valueLabel.backgroundColor = .clear
    }
    
    
    fileprivate func highlightedAnimation() {
        UIView.animate(withDuration: 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    fileprivate func unHighlightedAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
}

















