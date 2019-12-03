//
//  GenericNavBarButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericNavBarButton: UIView {
    
    // MARK: - Sizing
    
    let padding: CGFloat = 4
    var size: CGFloat {
        return 33
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "icons8-create-30").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    
    // MARK: - Views
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(image: image)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(imageView)
        imageView.centerInSuperview()
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
        
        addSubview(contentView)
        contentView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = size/2
        layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.85 , y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
}

