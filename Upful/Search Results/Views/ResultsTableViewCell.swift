//
//  ResultsTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/18/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class ResultsTableViewCell: UITableViewCell {
    
    let companyTickerLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        return l
    }()
    let companyNameLabel: UILabel = {
        let l = UILabel()
        l.font = .details2
        return l
    }()
    lazy var companyDescriptionStackView: UIStackView = {
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
    
    let dividendyieldStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.dividendyield.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    let ebitgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.ebitgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    lazy var companyFundamentalsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [marketcapStackView, pricetoearningsStackView,
                                                dividendyieldStackView, ebitgrowthStackView])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 3
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        addSubview(companyDescriptionStackView)
        companyDescriptionStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 16))
        
        addSubview(companyFundamentalsStackView)
        companyFundamentalsStackView.anchor(
            top: companyDescriptionStackView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 12, right: 32))
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

