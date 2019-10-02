//
//  SavedScreenerCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SaveScreenerDelegate: class {
    var savedItems: [SavedItem] { get set }
    func editScreener(indexPath: IndexPath)
    func deleteScreener(indexPath: IndexPath)
}

class SavedScreenersCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    enum ReuseID {
        static let cell = "cell"
    }
    
    weak var dataSource: SaveScreenerDelegate?
    
    fileprivate func observeState() {
        if isLongPressEnabled {
            collectionView.addGestureRecognizer(tapGesture)
        }
        if !isLongPressEnabled {
            collectionView.removeGestureRecognizer(tapGesture)
        }
        collectionView.reloadData()
    }
    
    var isLongPressEnabled = false {
        didSet {
            observeState()
        }
    }
    
    
    // MARK: - Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(SavedScreenerCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.cell)
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.itemSize = CGSize(width: (UIScreen.main.bounds.width) - 30 , height: (UIScreen.main.bounds.height/6))
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumInteritemSpacing = 8
            flowlayout.minimumLineSpacing = 8
            flowlayout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 5)
        }
        setupGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isLongPressEnabled = false
    }
    
    
    // MARK: - Gesture Setup
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    fileprivate func setupGestures() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(exitTap))
        tapGesture.delegate = self
    }
    
    @objc fileprivate func longTap(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            isLongPressEnabled = true
            collectionView.endInteractiveMovement()
            collectionView.reloadData()
        default:
            isLongPressEnabled = false
            collectionView.cancelInteractiveMovement()
        }
    }
    
    var tapGesture: UITapGestureRecognizer!
    
    @objc fileprivate func exitTap(_ gesture: UITapGestureRecognizer) {
        if isLongPressEnabled {
            let location = gesture.location(in: collectionView)
            guard collectionView.indexPathForItem(at: location) == nil else { return }
           isLongPressEnabled = false
        }
    }
    
    
    // MARK: - CollectionView Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.savedItems.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.cell, for: indexPath) as? SavedScreenerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = dataSource?.savedItems[indexPath.item].savedScreener.title
        cell.descriptionLabel.text = dataSource?.savedItems[indexPath.item].configureDescription()
        cell.editSelected = { [weak self] in
            self?.dataSource?.editScreener(indexPath: indexPath)
        }
        cell.removeSelected = { [weak self] in
            self?.dataSource?.deleteScreener(indexPath: indexPath)
        }
        if isLongPressEnabled { cell.startAnimate() }
        if !isLongPressEnabled { cell.stopAnimate() }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlComponents = (dataSource?.savedItems[indexPath.item].configureURLComponents()) ?? []
        if urlComponents == []  { return }
        let resultsVC = ScreenResultsViewController(searchParameters: urlComponents, networkingAPI: IntrinioAPI())
        parent?.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class SavedScreenerCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    var removeButton: SmallRoundButton = {
        let button = SmallRoundButton()
        button.setImage(#imageLiteral(resourceName: "icons8-delete-15").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 27).isActive = true
        button.heightAnchor.constraint(equalToConstant: 27).isActive = true
        button.layer.cornerRadius = 27/2
        button.layer.masksToBounds = true
        button.isHidden = true
        button.backgroundColor = .negative
        return button
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(white: 0.90, alpha: 1)
        button.setTitleColor(.appAccent3, for: .normal)
        button.setTitle("EDIT", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        return button
    }()
    
    var editSelected: (()->())?
    var removeSelected: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupViews()
        setupActions()
        setupShadow(intensity: .light, color: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    fileprivate func setupViews() {
        addSubview(removeButton)
        removeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                            padding: .init(top: -1, left: 0, bottom: 0, right: -1))
        addSubview(editButton)
        editButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 12, right: 5), size: CGSize(width: 60, height: 26))
        
        addSubview(textStackView)
        textStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 8, left: 16, bottom: 2, right: 16))
        descriptionLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -4).isActive = true
        
        editButton.layer.cornerRadius = 13
        editButton.layer.masksToBounds = true
    }
    
    
    private func setupActions() {
        editButton.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(handleRemoveTap), for: .touchUpInside)
    }
    
    var isAnimate = false
    
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-0.2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        removeButton.isHidden = false
        isAnimate = true
    }

    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        removeButton.isHidden = true
        isAnimate = false
    }
    
    @objc private func handleRemoveTap(_ sender: UIButton) {
        removeSelected?()
    }
    
    @objc private func handleEditTap(_ sender: UIButton) {
        editSelected?()
    }
}


