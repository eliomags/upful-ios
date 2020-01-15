//
//  ScreenerPreviewCollectionVIewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 1/2/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ScreenerPreviewTableViewCell: SavedScreenerTableViewCell {
    
    // MARK: - Views

    private let screenerImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        v.widthAnchor.constraint(equalToConstant: 75).isActive = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 4
        return v
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [screenerImage, textStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func setupViews() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            screenerImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            screenerImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        titleLabel.text = ""
        screenerImage.image = UIImage(systemName: "magnifyingglass.circle.fill")?
                            .withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
    }
    
    func loadImage(urlString: String) {
        UIImage.loadImage(from: urlString, resize: 120) { (result) in
            switch result {
            case .success(let im):
                self.screenerImage.image = im
            case .failure(_):
                self.screenerImage.image = UIImage(systemName: "magnifyingglass.circle.fill")?
                                               .withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    private func showLoading() {
        titleLabel.backgroundColor = VersionManager.loadingLabelColor()
        descriptionLabel.backgroundColor = VersionManager.loadingLabelColor()
    }
    
    func showLoaded() {
        titleLabel.backgroundColor = .clear
        descriptionLabel.backgroundColor = .clear
    }
}
