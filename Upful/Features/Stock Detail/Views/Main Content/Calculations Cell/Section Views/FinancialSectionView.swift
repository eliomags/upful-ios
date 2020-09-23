//
//  FinancialSectionView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class FinancialSectionView: UIView {
    
    let dividendyieldStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.dividendyield.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    let payoutRatioStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.divpayoutratio.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    
    fileprivate lazy var row1SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [dividendyieldStackView, payoutRatioStackView])
        return sv
    }()
    
    
    let debttoequityStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.debttoequity.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    let investedcapitalStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.investedcapitalgrowth.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    private lazy var row2SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [debttoequityStackView, investedcapitalStackView])
        return sv
    }()
    
    
    let grossmarginStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.grossmargin.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    let ebitmarginStackView: StockDetailStackView = {
        let sv = SectionedDetailsStackView(description: SearchCriteria.ebitmargin.explicit)
        sv.valueLabel.text = "-%"
        return sv
    }()
    private lazy var row3SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [grossmarginStackView, ebitmarginStackView])
        return sv
    }()
    
    
    private lazy var valuationSV: UIStackView = {
        let sv = SectionStackView(arrangedSubviews: [
            row1SV,
//            row2SV,
            row3SV,
            ])
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







































