//
//  StockDetailsStackView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDetailStackView: UIStackView {
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = .details2
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = .details1
        label.text = "NA"
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
        fatalError("init(coder:) has not been implemented")
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
        fatalError("init(coder:) has not been implemented")
    }
    
}
