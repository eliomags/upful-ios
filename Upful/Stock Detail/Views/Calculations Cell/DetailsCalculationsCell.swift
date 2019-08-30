//
//  DetailsCalculationsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class DetailsCalculationCell: UITableViewCell {
    
    // Valuation
    fileprivate let valuationView = ValuationSectionView()
    fileprivate let financialView = FinancialSectionView()
    fileprivate let growthView = GrowthSectionView()
    
    lazy var calcSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            valuationView,
            financialView,
            growthView
            ])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
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
//        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
    }
    
    
    func setValuationData() {

    }
    
    func setFinancialData() {
        
    }
    
    func setGrowthData() {
        
    }
    
}








