//
//  DetailsCalculationsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

final class DetailsCalculationCell: UITableViewCell {
    
    private let valuationView = ValuationSectionView()
    private let financialView = FinancialSectionView()
    private let growthView = GrowthSectionView()
    
    lazy var calcSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            valuationView,
            financialView,
            growthView
            ])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 15
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(calcSV)
        calcSV.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 8, left: 24, bottom: 16, right: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
    }
    
    func setupCell(with financials: [StandardizedFinancial]) {
        setFinancialData(financials: financials)
        setGrowthData(financials: financials)
    }
    
    func setupWithLookUp(lookUp: [SearchCriteria: Double]) {
        let keys = lookUp.keys
        keys.forEach { (key) in
            if key == .marketcap {
                valuationView.marketcapStackView.valueLabel.text = "$" + Int(lookUp[key] ?? 0).formatUsingAbbreviation()
            }
            if key == .pricetoearnings {
                valuationView.pricetoearningsStackView.valueLabel.text = lookUp[key]?.twoDecimal()
            }
            if key == .pricetobook {
                valuationView.pricetobookStackView.valueLabel.text = lookUp[key]?.twoDecimal()
            }
            if key == .pricetorevenue {
                valuationView.pricetosalesStackView.valueLabel.text = lookUp[key]?.twoDecimal()
            }
        }
    }
    
    private func setFinancialData(financials: [StandardizedFinancial]) {
        financials.forEach { (financial) in
            if (financial.dataTag?.tag)! == SearchCriteria.dividendyield.rawValue {
                financialView.dividendyieldStackView.valueLabel.text = "\(financial.value?.convertToPercent() ?? "")%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.divpayoutratio.rawValue {
                financialView.payoutRatioStackView.valueLabel.text = "\((financial.value ?? 0 / 100).convertToPercent())%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.grossmargin.rawValue {
                financialView.grossmarginStackView.valueLabel.text = (financial.value?.convertToPercent() ?? "") + "%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.ebitmargin.rawValue {
                financialView.ebitmarginStackView.valueLabel.text = (financial.value?.convertToPercent() ?? "") + "%"
                return
            }
        }
    }
    
    private func setGrowthData(financials: [StandardizedFinancial]) {
        financials.forEach { (financial) in
            if (financial.dataTag?.tag)! == SearchCriteria.ebitgrowth.rawValue {
                growthView.ebitgrowthStackView.valueLabel.text = "\(financial.value?.convertToPercent() ?? "")%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.ebitdagrowth.rawValue {
                growthView.ebitdagrowthStackView.valueLabel.text = "\(financial.value?.convertToPercent() ?? "")%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.revenuegrowth.rawValue {
                growthView.revenuegrowthStackView.valueLabel.text = "\(financial.value?.convertToPercent() ?? "")%"
                return
            }
            if (financial.dataTag?.tag)! == SearchCriteria.epsgrowth.rawValue {
                growthView.epsgrowthStackView.valueLabel.text = "\(financial.value?.convertToPercent() ?? "")%"
                return
            }
        }
    }
    
}








