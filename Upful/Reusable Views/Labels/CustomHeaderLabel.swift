//
//  CustomHeaderLabel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    var padding: Int
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: CGFloat(padding), dy: 0))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 30)
    }
    
    init(padding: Int) {
        self.padding = padding
        super.init(frame: .zero)
        font = .sectionHeader
    }
    
    override init(frame: CGRect) {
        self.padding = 16
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.padding = 16
        super.init(coder: aDecoder)
    }
}

class SmallSectionHeaderLabel: HeaderLabel {
    override init(padding: Int) {
        super.init(frame: .zero)
        self.padding = padding
        font = UIFont.systemFont(ofSize: 11, weight: .regular)
        textColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.padding = 16
    }
}

class LargeSectionHeaderLabel: HeaderLabel {
        override init(padding: Int) {
        super.init(frame: .zero)
        self.padding = padding
        font = .sectionHeader
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.padding = 16
    }
}

