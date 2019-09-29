//
//  ActionableTableHeader.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class ActionableTableHeader: UIView {

    lazy var headerTextLabel: LargeSectionHeaderLabel = {
        let label = LargeSectionHeaderLabel(padding: 0)
        return label
    }()
    
    var viewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerTextLabel, viewDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var actionButton: SmallRoundButton = {
        let button = SmallRoundButton()
        button.setImage(#imageLiteral(resourceName: "icons8-plus-math-50 (1)"), for: .normal)
        button.backgroundColor = .appAccent2
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    private lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, actionButton])
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    
    // MARK: - Initializer Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .white
        addSubview(overallStackView)
        overallStackView.anchor(
            top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 8, right: 16))
        overallStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showButton(_ isHidden: Bool) {
        actionButton.isHidden = isHidden
        actionButton.setNeedsDisplay()
    }
    
    var buttonAction: (()->())?
    
    @objc fileprivate func handleTap(_ sender: UIButton) {
        buttonAction?()
    }
}
