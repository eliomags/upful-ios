//
//  SuggestionViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SuggestionViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var contentBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 16
        return v
    }()
    
    private let voteIcon: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy)
        let im = UIImage(systemName: "heart.fill", withConfiguration: config)?
            .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
        let l = UIImageView(image: im ?? UIImage())
        return l
    }()
    
    let voteCountLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        l.textAlignment = .center
        return l
    }()
    
    private lazy var countStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [voteIcon, voteCountLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 4
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(contentBackgroundView)
        contentBackgroundView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        setupCountViews()
        setupContentStackView()
        setupDoubleTapAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var doubleTappedAction: (() -> Void)?
    
    fileprivate func setupDoubleTapAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupCountViews() {
        contentBackgroundView.addSubview(countStackView)
        countStackView.anchor(
           top: nil,
           leading: nil,
           bottom: contentBackgroundView.bottomAnchor,
           trailing: contentBackgroundView.trailingAnchor,
           padding: .init(top: 16, left: 16, bottom: 8, right: 12))
    }
    
    fileprivate func setupContentStackView() {
        contentBackgroundView.addSubview(contentStackView)
        contentStackView.anchor(
            top: contentBackgroundView.topAnchor,
            leading: contentBackgroundView.leadingAnchor,
            bottom: countStackView.topAnchor,
            trailing: contentBackgroundView.trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: 8, right: 8))
    }
    
    // MARK: - Actions
    
    @objc fileprivate func doubleTapped() {
        doubleTappedAction?()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            Vibration.light.vibrate()
            self.voteIcon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.voteIcon.transform = .identity
           }
        }
    }

}

