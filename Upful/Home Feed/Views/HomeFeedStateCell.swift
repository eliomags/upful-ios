//
//  HomeFeedStateCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

private class FeedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleColor(.darkText, for: .normal)
        backgroundColor = .clear
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeFeedStateCell: UITableViewCell {
    
    private let quickSearchButton: FeedButton = {
        let b = FeedButton()
        b.setTitle("Quick Search", for: .normal)
        return b
    }()
    
    private let manualSearchButton: FeedButton = {
        let b = FeedButton()
        b.setTitle("Manual Search", for: .normal)
        return b
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [quickSearchButton, manualSearchButton])
        sv.alignment = .center
        sv.spacing = 20
        return sv
    }()
    
    private lazy var placementView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 3).isActive = true
        v.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return v
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        setupViews()
        setupActions()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        addSubview(buttonStackView)
        buttonStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 5, right: 32)
        )
        
        addSubview(placementView)
        placementView.centerXAnchor.constraint(equalTo: quickSearchButton.centerXAnchor).isActive = true
        placementView.topAnchor.constraint(equalTo: quickSearchButton.bottomAnchor).isActive = true
    }
    
    fileprivate func setupActions() {
        quickSearchButton.addTarget(self, action: #selector(quickSearchTap), for: .touchUpInside)
        manualSearchButton.addTarget(self, action: #selector(manualSearchTap), for: .touchUpInside)
    }
    
    fileprivate func animatePlacementManual() {
        let centerDistance = quickSearchButton.center.x - manualSearchButton.center.x
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.placementView.transform = CGAffineTransform(translationX: -centerDistance, y: 0)
        }) { (_) in
        }
    }
    
    fileprivate func animatePlacementQuick() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.placementView.transform = .identity
        }) { (_) in
        }
    }
    
    @objc fileprivate func quickSearchTap(_ sender: UIButton) {
        animatePlacementQuick()
    }
    
    @objc fileprivate func manualSearchTap(_ sender: UIButton) {
        animatePlacementManual()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
