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
        return #imageLiteral(resourceName: "icons8-create-30 (1)").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

class SortButton: GenericNavBarButton {
    
    override var image: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let im = UIImage(systemName: "ellipsis", withConfiguration: config)?
            .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
        return im
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appAccent3
        heightAnchor.constraint(equalToConstant: 27).isActive = true
        widthAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        setImage(#imageLiteral(resourceName: "icons8-heart-25 (2)").withRenderingMode(.alwaysOriginal), for: .normal)
        setImage(#imageLiteral(resourceName: "icons8-heart-25 (1)").withRenderingMode(.alwaysOriginal), for: .selected)
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
