//
//  StockDescriptionCell.swift
//  Upful
//
//  Created by Yanik Simpson on 2/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class StockDescriptionCell: UITableViewCell {
    
    // MARK: - Views
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n\n\n"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.addSeparator()
        return label
    }()
    
    lazy var employeeStackView: SectionedDetailsStackView = {
        let sv = SectionedDetailsStackView(description: "Employees")
        sv.valueLabel.text = ""
        return sv
    }()
    
    fileprivate lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionLabel, employeeStackView])
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
