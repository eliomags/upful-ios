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
    
    let normalImage: UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let im = UIImage(systemName: "heart.fill", withConfiguration: config)?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return im ?? UIImage()
    }()

    
    let selectedImage: UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let im = UIImage(systemName: "heart.fill", withConfiguration: config)?
            .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
        return im ?? UIImage()
    }()
    
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
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
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
