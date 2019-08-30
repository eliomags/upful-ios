//
//  GrowthSectionView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


final class GrowthSectionView: UIView {
    
    // Growth
    let ebitgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.ebitgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    let ebitdagrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.ebitdagrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    fileprivate lazy var row1SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [ebitgrowthStackView, ebitdagrowthStackView])
        return sv
    }()
    
    
    let revenuegrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.revenuegrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    let revenueqoqgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.revenueqoqgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    private lazy var row2SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [revenuegrowthStackView, revenueqoqgrowthStackView])
        return sv
    }()
    
    
    let epsgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.epsgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    let fcfgrowthStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.fcffgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    private lazy var row3SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [epsgrowthStackView, fcfgrowthStackView])
        return sv
    }()
    
    
    private lazy var valuationSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            row1SV,
            row2SV,
            row3SV,
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(valuationSV)
        valuationSV.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}























































