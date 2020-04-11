//
//  ManualScreenItemUpdaterViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

protocol ManualScreenItemUpdaterDelegate: class {
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath)
}

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
        label.text = "\(screenerItem.criteria.explicit) \(selectedParameter.explicit) $500M"
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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
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
            step = (screenerItem.criteria == .dividendyield) ? 0.01 : 0.05
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
        
        let viewModel = ManualScreenItemViewModel(manualScreenItem: screenerItem)
        delegate?.didUpdate(manualScreenItemViewModel: viewModel, at: selectedIndexPath)
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ARCHIVE

class ManualScreenItemUpdaterViewController: UITableViewController {
    
    // MARK:- Dependencies
    
    private(set) var screenerItem: ManualScreenItem
    let selectedIndexPath: IndexPath
    var manualSearchParameterItems: [ParameterItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ManualScreenItemUpdaterDelegate?
    
    // MARK:- Initializer
    
    init(selectedIndexPath: IndexPath, screenerItem: ManualScreenItem) {
        self.screenerItem = screenerItem
        self.selectedIndexPath = selectedIndexPath
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VersionManager.mainContainerBackground()
        initializeData()
    }
    
    // MARK:- Data Initialization
    
    fileprivate func configureRatioData() {
        [3.0, 5, 10, 15, 20, 25, 30, 40, 50, 60, 80, 100].forEach { (value) in
            SearchParameter.allCases.forEach { (param) in
                if param != .none && param != .contains {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            }
        }
    }
    
    fileprivate func configurePercentageData() {
        [0.0, 0.01, 0.03, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.60, 0.80].forEach { (value) in
            SearchParameter.allCases.forEach { (param) in
                if param != .none && param != .contains  {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            }
        }
    }
    
    fileprivate func configureMarketCapData() {
        [50_000_000_000.0, 10_000_000_000, 3_000_000_000,1_000_000_000, 500_000_000, 100_000_000].forEach { (value) in
            SearchParameter.allCases.forEach({ (param) in
                if param != .none && param != .contains  {
                    manualSearchParameterItems.append(ParameterItem(parameter: param, value: value))
                }
            })
        }
    }
    
    fileprivate func initializeData() {
        switch screenerItem.criteria.parameterType {
        case .ratio:
            configureRatioData()
        case .percentage:
            configurePercentageData()
        case .number:
            configureMarketCapData()
        case .other:
            break
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualSearchParameterItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let displayData = manualSearchParameterItems[indexPath.item]
        cell.textLabel?.font = .details1
        
        if displayData.parameter != .none {
            if screenerItem.criteria.parameterType == .percentage {
                cell.textLabel?.text = displayData.parameter.explicit + " " + "\(displayData.value.convertToPercent())%"
            }
            if screenerItem.criteria.parameterType == .ratio {
                cell.textLabel?.text = displayData.parameter.explicit + " " + String(Int(displayData.value))
            }
            if screenerItem.criteria.parameterType == .number {
                cell.textLabel?.text = displayData.parameter.explicit + " $" + Int(displayData.value).formatUsingAbbreviation()
            }
        } else {
            cell.textLabel?.text = displayData.parameter.explicit
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedParameterItem = manualSearchParameterItems[indexPath.item]
        
        screenerItem.value = selectedParameterItem.value
        screenerItem.parameter = selectedParameterItem.parameter
        
        let viewModel = ManualScreenItemViewModel(manualScreenItem: screenerItem)
        delegate?.didUpdate(manualScreenItemViewModel: viewModel, at: selectedIndexPath)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
