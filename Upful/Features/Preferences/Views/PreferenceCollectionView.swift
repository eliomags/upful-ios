//
//  PreferenceCollectionView.swift
//  Upful
//
//  Created by Yanik Simpson on 10/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericPreferenceCollectionViewController: UIViewController {
    // MARK: - Dependencies
    
    var preferences: [Preference]
    
    // MARK: - Views
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(PreferenceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.dataSource = self
        view.delegate = self
        view.allowsSelection = true
        return view
    }()
    
    var preferenceSelected: ((PreferenceType) -> Void)?
    var preferenceDeSelected: ((PreferenceType) -> Void)?
    
    // MARK: - Initializer Methods
    
    init(preferences: [Preference]) {
        self.preferences = preferences
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.preferences = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Helper
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

extension GenericPreferenceCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PreferenceCollectionViewCell
        cell?.label.text = preferences[indexPath.item].description
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        preferenceSelected?(preferences[indexPath.row].id)
        Vibration.selection.vibrate()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        preferenceDeSelected?(preferences[indexPath.row].id)
    }
    
}

class DecentSizedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 0)
    }
    
}


class PreferenceCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
                self.label.textColor = self.isSelected ? UIColor.white : UIColor.black
                self.backgroundColor = self.isSelected ? UIColor.appAccent3 : UIColor.clear
                self.layer.borderColor = self.isSelected ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
            })
        }
    }
    
    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(label)
        label.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        sizeToFit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 1.25
        if !isSelected {
            layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
}

