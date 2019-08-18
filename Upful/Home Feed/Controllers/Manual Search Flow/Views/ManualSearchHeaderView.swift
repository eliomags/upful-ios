//
//  ManualSearchHeaderView.swift
//  Upful
//
//  Created by Yanik Simpson on 8/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


protocol ManualSearchHeaderViewDelegate: class {
    func navigateToSearchCriteria()
}

class ManualSearchHeaderView: UIView {
    
    weak var delegate: ManualSearchHeaderViewDelegate?
    
    let header: SectionHeaderLabel = {
        let l = SectionHeaderLabel(padding: 16)
        l.text = "ADD SEARCH PARAMETERS"
        return l
    }()
    
    class CustomButton: UIButton {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 35, height: 35)
        }
    }
    
    let addCriteriaButton: CustomButton = {
        let b = CustomButton(type: .system)
        b.setBackgroundImage(#imageLiteral(resourceName: "icons8-plus-math-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        b.backgroundColor = .positive
        b.layer.cornerRadius = b.intrinsicContentSize.height / 2
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleAddCriteria), for: .touchUpInside)
        b.setupShadow(intensity: .light, color: .black)
        return b
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [header, addCriteriaButton])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 16, left: 8, bottom: 4, right: 20))
    }
    
    @objc fileprivate func handleAddCriteria(_ sender: UIButton) {
        delegate?.navigateToSearchCriteria()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


