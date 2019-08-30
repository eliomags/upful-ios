//
//  CalculationsViews.swift
//  Upful
//
//  Created by Yanik Simpson on 8/29/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit



class RowStackView: UIStackView {
    let spacerView = SpacerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 16
        distribution = .fillEqually
        alignment = .leading
        
        addSubview(spacerView)
        spacerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                          padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    // Add view of 2px wide
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ValuationSectionView: UIView {
    
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
    private lazy var row1SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [marketcapStackView, pricetoearningsStackView])
        return sv
    }()
    
    let evtofcfStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.evtofcff.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    let evtoebitStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.evtoebit.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    private lazy var row2SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [evtofcfStackView, evtoebitStackView])
        return sv
    }()
    
    
    let bookValuePerShareStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.bookvaluepershare.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    let pricetosalesStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: SearchCriteria.pricetorevenue.explicit)
        sv.valueLabel.text = "-"
        return sv
    }()
    private lazy var row3SV: RowStackView = {
        let sv = RowStackView(arrangedSubviews: [bookValuePerShareStackView, pricetosalesStackView])
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
















