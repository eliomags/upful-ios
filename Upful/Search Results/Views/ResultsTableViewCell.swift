//
//  ResultsTableViewCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/18/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class StockDataView: UIView {
    
    let tickerLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let companyNameLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    lazy var nameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tickerLabel, companyNameLabel])
        sv.distribution = .fillEqually
        sv.axis = .vertical
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameStackView)
        nameStackView.fillSuperview()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ResultsTableViewCell: UITableViewCell {
    
    
    let stockDataView = StockDataView()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        self.addSubview(stockDataView)
        stockDataView.fillSuperview()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

