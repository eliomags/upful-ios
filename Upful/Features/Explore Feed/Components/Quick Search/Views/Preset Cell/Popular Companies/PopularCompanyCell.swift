//
//  PopularCompanyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PopularCompanyTableViewCell: UITableViewCell {
    private enum ReuseID: String {
        case companyCell
    }
    let analyticsMapper: AnalyticsLogger
    let popularCompanies: [PopularCompany]
    
    weak var delegate: HomeFeedNavigationDelegate?
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 12)
        layout.itemSize = CGSize(width: 170, height: 90)
        return layout
    }()
    
    lazy var popularCompanyCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(PopularCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.companyCell.rawValue)
        return cv
    }()

    
    init(popularCompanies: [PopularCompany], analyticsMapper: AnalyticsLogger = .init()) {
        self.popularCompanies = popularCompanies
        self.analyticsMapper = analyticsMapper
        super.init(style: .default, reuseIdentifier: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(popularCompanyCollectionView)
        popularCompanyCollectionView.fillSuperview()
    }
}

extension PopularCompanyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = popularCompanies[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.companyCell.rawValue, for: indexPath) as? PopularCompanyCollectionViewCell else { return UICollectionViewCell() }
        cell.configureLabels(company: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToDetails(popularCompany: popularCompanies[indexPath.item].header,
                                    companyName: popularCompanies[indexPath.item].details ?? "")
    }
    
}


class PopularCompanyCollectionViewCell: UICollectionViewCell {
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        return label
    }()

    lazy var companyDescriptionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tickerLabel, companyNameLabel])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 1
        return sv
    }()
    
    lazy var marketcapStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: "Market Cap")
        return sv
    }()
    
    lazy var peStackView: StockDetailStackView = {
        let sv = StockDetailStackView(description: "Price/Earnings")
        return sv
    }()
    
    lazy var stockDetailsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [marketcapStackView, peStackView])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        return sv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? highlightedAnimation() : unHighlightedAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.25
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(companyDescriptionStackView)
        companyDescriptionStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 12, left: 6, bottom: 0, right: 0))
        
        companyNameLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        
        addSubview(stockDetailsStackView)
        stockDetailsStackView.anchor(
            top: companyDescriptionStackView.bottomAnchor, leading: companyDescriptionStackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 8, right: 6))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureLabels(company: PopularCompany) {
        tickerLabel.text = company.header
        companyNameLabel.text = company.details
        marketcapStackView.valueLabel.text = "$\(company.marketcap?.formatUsingAbbreviation() ?? " -")"
        peStackView.valueLabel.text = company.priceToEarnings?.twoDecimal() ?? " -"
    }
    
    fileprivate func highlightedAnimation() {
        UIView.animate(withDuration: 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    fileprivate func unHighlightedAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
}













