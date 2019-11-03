//
//  AddButton.swift
//  Upful
//
//  Created by Yanik Simpson on 10/2/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class AddButton: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 40)
    }

    let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.text = "ADD"
        return label
    }()
    
    private let addImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icons8-plus-math-50 (1)"))
        return imageView
    }()
    
    private lazy var imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.addSubview(addImageView)
        addImageView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 2, left: 2, bottom: 2, right: 2))
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageBackground, buttonLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    
    fileprivate func setupView() {
        backgroundColor = .appAccent3
        layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
