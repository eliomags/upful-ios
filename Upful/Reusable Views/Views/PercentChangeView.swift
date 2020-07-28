//
//  PercentChangeView.swift
//  Upful
//
//  Created by Yanik Simpson on 3/24/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class PercentChangeView: UIView {
    private let imageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage()
        return im
    }()
    private lazy var imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.fillSuperview(padding: .init(top: 2, left: 2, bottom: 2, right: 2))
        return view
    }()
    let percentChangeLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageBackground, percentChangeLabel])
        sv.axis = .horizontal
        sv.spacing = 3
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentStackView)
        contentStackView.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNegative() {
        imageView.image = UIImage(systemName: "arrow.down")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    }
    func showPositive() {
        imageView.image = UIImage(systemName: "arrow.up")?
            .withTintColor(.appAccent4, renderingMode: .alwaysOriginal)
    }
    func showNeutral() {
        imageView.image = UIImage()
    }
}
