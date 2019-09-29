//
//  StockDetailsStackView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StateLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightText
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.text == "" { backgroundColor = UIColor.lightText}
//        if self.text != "" { backgroundColor = UIColor.clear }
    }
}

class StockDetailStackView: UIStackView {
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = .details1
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = ""
        return label
    }()
    
    
    init(description: String) {
        super.init(frame: .zero)
        descriptionLabel.text = "\(description):"
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(valueLabel)
        axis = .horizontal
        spacing = 5
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class SectionedDetailsStackView: StockDetailStackView {
    
    let spacerView = SpacerView()

    override init(description: String) {
        super.init(description: description)
        
        addSubview(spacerView)
        spacerView.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: 4, left: 8, bottom: 0, right: 8))
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
