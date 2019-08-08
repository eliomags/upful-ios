//
//  HomeFeedStateCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol HomeFeedStateDelegate: class {
    func configureQuickSearch()
    func configureManualSearch()
}

private class FeedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleColor(.darkText, for: .normal)
        backgroundColor = .clear
        titleLabel?.font = .sectionHeader
    }    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeFeedStateView: UIView {
    
    weak var delegate: HomeFeedStateDelegate?
    
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
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }()
    
    private lazy var placementView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3779938412)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        v.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
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
        })
        delegate?.configureManualSearch()
    }
    
    fileprivate func animatePlacementQuick() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.placementView.transform = .identity
        })
        delegate?.configureQuickSearch()
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









