//
//  MultilineButton.swift
//  Upful
//
//  Created by Yanik Simpson on 3/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class MultilineButton: UIView {
    
    // MARK: - Properties
    
    let image: UIImage
    let title: String
    var buttonBackgroundColor = UIColor.clear
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 55, height: 55)
    }
    
    // MARK: - Views
    
    private lazy var buttonImageView: UIImageView = {
        let view = UIImageView(image: image)
        return view
    }()
    
    private lazy var imageViewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = buttonBackgroundColor
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 35).isActive = true
        v.widthAnchor.constraint(equalToConstant: 35).isActive = true
        v.addSubview(buttonImageView)
        buttonImageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        v.layer.cornerRadius = 35/2
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageViewBackground, titleLabel])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.spacing = 4
        return sv
    }()
    
    // MARK: - Initializer
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
        super.init(frame: .zero)
        addSubview(contentStackView)
        contentStackView.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
