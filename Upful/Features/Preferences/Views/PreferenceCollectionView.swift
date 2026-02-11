//
//  PreferenceCollectionView.swift
//  Upful
//
//  Created by Yanik Simpson on 10/8/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class IndustryPreferenceCollectionViewController: GenericPreferenceCollectionViewController {
    
    override init(preferences: [PreferenceViewModel], savedPreferenceIds: [PreferenceID]) {
        super.init(preferences: preferences, savedPreferenceIds: savedPreferenceIds)
        collectionView.allowsMultipleSelection = true
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 4
            layout.minimumInteritemSpacing = 2
            layout.scrollDirection = .vertical
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPreference = preferences[indexPath.row].id
        
        if selectedPreference == .industryAny {
            for row in 1..<preferences.count {
                preferenceDeSelected?(preferences[row].id)
                collectionView.deselectItem(at: IndexPath(row: row, section: 0), animated: false)
            }
            savedPreferenceCount -= 1
        }
        
        if !(selectedPreference == .industryAny) {
            collectionView.deselectItem(at: IndexPath(row: 0, section: 0), animated: false)
            preferenceDeSelected?(preferences[0].id)
        }
        
        preferenceSelected?(selectedPreference)
        savedPreferenceCount += 1
        Vibration.selection.vibrate()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        savedPreferenceCount -= 1
        preferenceDeSelected?(preferences[indexPath.row].id)
        
        if savedPreferenceCount == 0 {
            collectionView.selectItem(at: [0,0], animated: true, scrollPosition: .centeredVertically)
            preferenceSelected?(.industryAny)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedPreference = preferences[indexPath.row].id
        if selectedPreference == .industryAny {
            savedPreferenceCount = 0
            return true
        }
        return !(savedPreferenceCount == maxNumberOfPreferences)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return !(preferences[indexPath.row].id == .industryAny)
    }
}

class GenericPreferenceCollectionViewController: UIViewController {
    // MARK: - Dependencies
    
    let preferences: [PreferenceViewModel]
    let savedPreferenceIds: [PreferenceID]
    
    // MARK: - State
    
    let maxNumberOfPreferences = 3
    var savedPreferenceCount = 0

    
    // MARK: - Views
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(PreferenceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.isScrollEnabled = false
        view.dataSource = self
        view.delegate = self
        view.allowsSelection = true
        return view
    }()
    
    var contentHeight: CGFloat = 0 {
        didSet {
            contentUpdated?(contentHeight)
        }
    }
    
    var contentUpdated: ((CGFloat) -> Void)?
    
    var preferenceSelected: ((PreferenceID) -> Void)?
    var preferenceDeSelected: ((PreferenceID) -> Void)?
    
    // MARK: - Initializer Methods
    
    init(preferences: [PreferenceViewModel], savedPreferenceIds: [PreferenceID]) {
        self.preferences = preferences
        self.savedPreferenceIds = savedPreferenceIds
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not set")
    }
    
    // MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setSavedCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    
    // MARK: - Helpers
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func setSavedCell() {
        savedPreferenceIds.forEach { (id) in
            let index = preferences.firstIndex(where: { $0.id == id })
            if let index = index {
                savedPreferenceCount += 1
                collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .bottom)
                if id == .industryAny { savedPreferenceCount = 0 }
                return
            }
        }
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
        let datasource = preferences[indexPath.item]
        cell?.label.text = datasource.description
        cell?.setPreferenceIcon(datasource.icon)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPreference = preferences[indexPath.row].id
        preferenceSelected?(selectedPreference)
        Vibration.selection.vibrate()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        savedPreferenceCount -= 1
        preferenceDeSelected?(preferences[indexPath.row].id)
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
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.addSubview(iconImage)
        iconImage.fillSuperview()
        view.heightAnchor.constraint(equalToConstant: 18).isActive = true
        view.widthAnchor.constraint(equalToConstant: 18).isActive = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageBackgroundView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        return stackView
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
                self.layer.borderColor = self.isSelected ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
                
                if #available(iOS 13.0, *) {
                    self.label.textColor = .label
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.backgroundColor = self.isSelected ? UIColor.appAccent3 : .secondarySystemBackground
                    }
                    if self.traitCollection.userInterfaceStyle == .light {
                        self.backgroundColor = self.isSelected ? UIColor.appAccent3 : ThemeManager.collectionCellColor()
                        
                        self.label.textColor = self.isSelected ? UIColor.white : UIColor.black
                    }
                } else {
                    self.backgroundColor = self.isSelected ? UIColor.appAccent3 : UIColor(white: 0.99, alpha: 1)
                    self.label.textColor = self.isSelected ? UIColor.white : UIColor.black
                }
                
            })
        }
    }
    
    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ThemeManager.collectionCellColor()
        
        addSubview(contentStackView)
        contentStackView.anchor(
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
    
    
    func setPreferenceIcon(_ icon: UIImage?) {
        if let icon = icon {
            self.iconImage.image = icon
            self.imageBackgroundView.isHidden = false
        }
    }
    
}

