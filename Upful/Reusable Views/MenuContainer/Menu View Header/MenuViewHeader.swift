//
//  MenuViewHeader.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol MenuBarViewDelegate: class {
    func selectedIndex(_ index: Int)
    func presentMenuBar()
    func hideMenuBar()
}

final class MenuBarView: UIView {
    weak var delegate: MenuBarViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 60)
    }
    
    let menuTitles: [String]
    
    private lazy var menuBarControl: MenuBarControl = {
        let sc = MenuBarControl(items: menuTitles)
        sc.addTarget(self, action: #selector(selectedControl), for: .valueChanged)
        return sc
    }()
    
    @objc fileprivate func selectedControl(_ sender: UISegmentedControl) {
        delegate?.selectedIndex(sender.selectedSegmentIndex)
    }
    
    var placementViewLeadingConstraint: CGFloat = 0 {
        didSet {
            let translationDistance = placementViewLeadingConstraint/CGFloat(menuBarControl.numberOfSegments)
            placementView.transform = CGAffineTransform(translationX: translationDistance, y: 0)
            
        }
    }
    
    lazy var placementView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1.25).isActive = true
        return v
    }()
    
    
    init(menuTitles: [String]) {
        self.menuTitles = menuTitles
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(placementView)
        addSubview(menuBarControl)

        placementView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        placementView.widthAnchor.constraint(equalTo: menuBarControl.widthAnchor, multiplier: 1/CGFloat(menuBarControl.numberOfSegments)).isActive = true
        placementView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        menuBarControl.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: placementView.topAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 5, right: 0)
        )
    }
    
    // MARK: - Animating the placement
    
    func setIndex(_ index: Int) {
        menuBarControl.selectedSegmentIndex = index
    }
}






















