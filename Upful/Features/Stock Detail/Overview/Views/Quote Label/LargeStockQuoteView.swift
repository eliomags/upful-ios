//
//  LargeStockQuoteView.swift
//  Upful
//
//  Created by Yanik Simpson on 2/24/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockQuoteView: UIView {
    
    // MARK: - Properties

    private let priceLabelFontSize: CGFloat
    private let priceChangeLabelFontSize: CGFloat
    private let priceChangeLabelWidth: CGFloat
    
    // MARK: - Views
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: priceLabelFontSize, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var percentChangeView: PercentChangeView = {
        let view = PercentChangeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.percentChangeLabel.font = UIFont.systemFont(ofSize: priceChangeLabelFontSize, weight: .semibold)
        return view
    }()

    lazy var quoteStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [priceLabel, percentChangeView])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .trailing
        sv.spacing = 12
        return sv
    }()
    
    // MARK: - Initializer
    
    init(priceLabelFontSize: CGFloat, priceChangeLabelFontSize: CGFloat, priceChangeLabelWidth: CGFloat) {
        self.priceLabelFontSize = priceLabelFontSize
        self.priceChangeLabelFontSize = priceChangeLabelFontSize
        self.priceChangeLabelWidth = priceChangeLabelWidth
        super.init(frame: .zero)
        addSubview(quoteStackView)
        quoteStackView.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup View
    
    func setPositive() {
        percentChangeView.showPositive()
    }
    func setNegative() {
        percentChangeView.showNegative()
    }
    func setNeutral() {
        percentChangeView.showNeutral()
    }
}
