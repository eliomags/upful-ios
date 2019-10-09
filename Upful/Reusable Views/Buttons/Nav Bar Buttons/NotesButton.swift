//
//  NotesButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class NotesButton: GenericNavBarButton {
    override var image: UIImage {
        return #imageLiteral(resourceName: "icons8-create-30").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

class SaveButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                 self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9 , y: 0.9) : .identity
            }
        }
    }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 33).isActive = true
        widthAnchor.constraint(equalToConstant: 33).isActive = true
        setImage(#imageLiteral(resourceName: "icons8-star-30 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        setImage(#imageLiteral(resourceName: "icons8-star-30 (2)").withRenderingMode(.alwaysOriginal), for: .selected)
        setTitle("", for: .normal)
        backgroundColor = .clear
        tintColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
}
