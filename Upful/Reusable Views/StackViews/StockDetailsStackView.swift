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
        label.font = .details1
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
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
    
    override init(description: String) {
        super.init(description: description)
        addSeparator()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UIView {
    func addSeparator() {
        let spacerView = SpacerView()
        
        addSubview(spacerView)
        spacerView.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: 4, left: 8, bottom: 0, right: 8))
    }
}
