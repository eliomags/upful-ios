//
//  SavedScreenerCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SaveScreenerDelegate: class {
    var savedScreeners: [Screener] { get set }
    func editScreener(indexPath: IndexPath)
    func deleteScreener(indexPath: IndexPath)
}

protocol ActionHeaderDelegate: class {
    func observeSavedScreenerState(isEditing: Bool)
}

class SavedScreenersCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    deinit {
        print("Deinitialized", self)
    }
    
    enum ReuseID {
        static let cell = "cell"
    }
    
    weak var dataSource: SaveScreenerDelegate?
    weak var delegate: ActionHeaderDelegate?
    
    // MARK: - State
    
    var isLongPressEnabled = false {
        didSet {
            observeState()
        }
    }
    
    fileprivate func observeState() {
        collectionView.reloadData()
        delegate?.observeSavedScreenerState(isEditing: isLongPressEnabled)
    }
    
    
    // MARK: - Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(SavedScreenerCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.cell)
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.bounds.width
            let paddingConstant: CGFloat = 30
            flowlayout.itemSize = CGSize(width: width - paddingConstant, height: 100)
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumInteritemSpacing = 0
            flowlayout.minimumLineSpacing = 8
            flowlayout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 15)
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
        longPressGesture.minimumPressDuration = 0.8
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc fileprivate func longTap(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            Vibration.selection.vibrate()
            isLongPressEnabled = true
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
            collectionView.reloadData()
        default:
            isLongPressEnabled = false
            collectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - CollectionView Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.savedScreeners.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.cell, for: indexPath) as? SavedScreenerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = dataSource?.savedScreeners[indexPath.item].savedScreener.title
        cell.descriptionLabel.text = dataSource?.savedScreeners[indexPath.item].configureDescription()
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
        PermissionManager.shared.verifyScreenerNavigationPermission { (shouldNavigate) in
            if shouldNavigate {
                let urlComponents = (dataSource?.savedScreeners[indexPath.item].configureURLComponents()) ?? []
                if urlComponents == []  { return }
                let resultsVC = ScreenResultsViewController(searchParameters: urlComponents, networkingAPI: IntrinioAPI())
                AnalyticsLogger.instance.reportEvents(event: .screenForStocks(screenType: .saved))
                parent?.navigationController?.pushViewController(resultsVC, animated: true)
            } else {
                let presenter = SubscriptionPresenter(type: .screeningLimit)
                presenter.present(in: self)
            }
        }
    }
    
}

extension SavedScreenersCollectionViewController: PresentationControllerDelegate {
    func presentationControllerdDidDismiss() {
        showNotificationSetupView()
    }
}

class SavedScreenerCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.3: 0.2) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.94, y: 0.94): CGAffineTransform.identity
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
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
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                button.backgroundColor = UIColor(white: 0.05, alpha: 0.9)
            }
            if traitCollection.userInterfaceStyle == .light {
                button.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
            }
        } else {
            button.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        }
        button.setTitleColor(.appAccent3, for: .normal)
        button.setTitle("EDIT", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 27).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    var editSelected: (()->())?
    var removeSelected: (()->())?
    
    
    // MARK: - Initializer Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = VersionManager.collectionCellColor()
        layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupViews()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupViews() {
        addSubview(removeButton)
        removeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                            padding: .init(top: -1, left: 0, bottom: 0, right: -1))
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
        addSubview(textStackView)
        textStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: editButton.leadingAnchor,
                             padding: .init(top: 12, left: 16, bottom: 2, right: 6))
        
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


