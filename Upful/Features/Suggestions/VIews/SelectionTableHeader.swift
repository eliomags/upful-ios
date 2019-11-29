//
//  SelectionTableHeader.swift
//  Upful
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SelectionTableHeader: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 44)
    }
    
    let label: UILabel = {
        let l = UILabel()
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return l
    }()
    
    let button: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("", for: .normal)
        b.setTitleColor(.appAccent3, for: .normal)
        let font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 17)
        b.titleLabel?.font = font
        b.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return b
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [label, button])
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonTapped: (() -> Void)?
    
    @objc fileprivate func handleButtonTap(_ sender: UIButton) {
        buttonTapped?()
    }
    
    
}


