//
//  CustomRoundButton.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CustomRoundButton: UIView {
    
    // MARK: - Dependencies
    
    private let imageName: String
    

    var buttonColor: UIColor {
        return .appAccent3
    }
    
    var buttonImage: UIImage {
        let plusImage = UIImage(systemName: imageName)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        return plusImage?.resizeImage(20, opaque: false) ?? UIImage()
    }
    
    lazy var buttonImageView: UIImageView = {
        let view = UIImageView(image: self.buttonImage
            .withAlignmentRectInsets(UIEdgeInsets(top: -3.5, left: -3.5, bottom: -3.5, right: -3.5))
        )
        return view
    }()
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // MARK: - Initializer Methods
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(frame: .zero)
        setupView()
        setupButtonImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 50/2
    }
    
    // MARK: - View Setup
    
    private func setupView() {
        layer.masksToBounds = true
        backgroundColor = .appAccent3
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        setupShadow(intensity: .medium, color: .darkGray)
    }
    
    private func setupButtonImage() {
        addSubview(buttonImageView)
        buttonImageView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor,
                               padding: .init(top: 6, left: 6, bottom: 6, right: 6)
        )
    }
    
    // MARK: - Animations
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}


class SmallRoundButton: CustomButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .appAccent3
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

