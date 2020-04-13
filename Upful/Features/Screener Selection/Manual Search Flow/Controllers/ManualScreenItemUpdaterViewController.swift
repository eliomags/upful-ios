//
//  ManualScreenItemUpdaterViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class NewManualScreenerItemUpdateViewController: UIViewController {
    
    // MARK: - Properties
    
    private var screenerItem: ManualScreenItem
    private let selectedIndexPath: IndexPath
    private var selectedParameter: SearchParameter = .gt
    private lazy var selectedValue: Float = Float(screenerItem.criteria.valueBounds.max / 2)

    weak var delegate: ManualScreenItemUpdaterDelegate?
    
    // MARK: - Views
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "\(screenerItem.criteria.explicit) \(selectedParameter.explicit)"
        label.textAlignment = .center
        let size = UIFont.preferredFont(
            forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var parameterControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [SearchParameter.gt.explicit, SearchParameter.lt.explicit])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.widthAnchor.constraint(equalToConstant: 100).isActive = true
        control.addTarget(self, action: #selector(handleParameterChange), for: .valueChanged)
        return control
    }()
    
    private lazy var valueSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(screenerItem.criteria.valueBounds.min)
        slider.maximumValue = Float(screenerItem.criteria.valueBounds.max)
        slider.addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var dismissButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return b
    }()
    
    private lazy var acceptButton: UIButton = {
        let b = UIButton(type: .system)
        b.layer.cornerRadius = 8
        b.layer.masksToBounds = false
        b.setTitle("Set", for: .normal)
        b.backgroundColor = .appAccent3
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(handleSet), for: .touchUpInside)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return b
    }()
    
    private lazy var dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancel)))
        return view
    }()
    
    // MARK: StackViews
    
    private lazy var controlStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [parameterControl, valueSlider])
        sv.spacing = 24
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dismissButton, acceptButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionLabel, controlStackView, buttonStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 32
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializer
    
    init(selectedIndexPath: IndexPath, screenerItem: ManualScreenItem) {
        self.screenerItem = screenerItem
        self.selectedIndexPath = selectedIndexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeValues()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -24),
        ])
        
        view.addSubview(dismissView)
        NSLayoutConstraint.activate([
            dismissView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }

    fileprivate func updateDescriptionLabel() {
        var configuredSelectedValue = ""

        switch self.screenerItem.criteria.parameterType {
        case .number:
            configuredSelectedValue = "$" + Int(selectedValue).formatUsingAbbreviation()
            
        case .percentage:
            configuredSelectedValue = "$" + Double(selectedValue).convertToPercent() + "%"
            
        case .ratio:
            configuredSelectedValue = String(Int(selectedValue))

        default:
            assert(false, "Only  Number, Ratio and Percentage options allowed")
        }
        descriptionLabel.text = "\(screenerItem.criteria.explicit) \(selectedParameter.explicit) \(configuredSelectedValue)"
    }
    
    fileprivate func initializeValues() {
        let initialValue = Float((screenerItem.criteria.valueBounds.max) / 2)
        valueSlider.value = initialValue
        selectedValue = initialValue
        
        updateDescriptionLabel()
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleParameterChange(segmentControl: UISegmentedControl) {
        let searchParameter = [SearchParameter.gt, SearchParameter.lt][segmentControl.selectedSegmentIndex]
        selectedParameter = searchParameter
        
        updateDescriptionLabel()
    }
    
    @objc fileprivate func handleValueChange(slider: UISlider) {
        let step: Float

        switch screenerItem.criteria.parameterType {
        case .number:
            step = 100_000_000
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue

        case .ratio:
            step = 5
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue

        case .percentage:
            step = (screenerItem.criteria == .dividendyield) ? 0.005 : 0.05
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue

        default:
            assert(false, "Only  Number, Ratio and Percentage options allowed")
        }
        selectedValue = slider.value
        
        updateDescriptionLabel()
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSet() {
        screenerItem.value = Double(selectedValue)
        screenerItem.parameter = selectedParameter
        
        Vibration.medium.vibrate()
        
        let viewModel = ManualScreenItemViewModel(manualScreenItem: screenerItem)
        delegate?.didUpdate(manualScreenItemViewModel: viewModel, at: selectedIndexPath)
        
        self.dismiss(animated: true, completion: nil)
    }
}
