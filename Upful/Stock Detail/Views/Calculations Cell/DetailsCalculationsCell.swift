//
//  DetailsCalculationsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

fileprivate class RowStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 16
        distribution = .fillEqually
        alignment = .leading
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DetailsCalculationCell: UITableViewCell {
    // Valuation
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
    
    fileprivate lazy var valuationSV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [marketcapStackView, pricetoearningsStackView])
        return sv
    }()
    
    // Financial
    let dividendyieldStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.dividendyield.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    let payoutRationStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.divpayoutratio.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    fileprivate lazy var dividendSV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [dividendyieldStackView, payoutRationStackView])
        return sv
    }()
    
    // Growth
    let ebitgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.ebitgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    let revenuegrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.revenuegrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    fileprivate lazy var growthSV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [ebitgrowthStackView, revenuegrowthStackView])
        return sv
    }()
    
    
    lazy var calcSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            valuationSV,
            dividendSV,
            growthSV
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 3
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(calcSV)
        calcSV.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
    }
    
    
}








