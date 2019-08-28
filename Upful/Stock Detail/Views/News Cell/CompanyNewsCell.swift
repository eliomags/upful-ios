//
//  CompanyNewsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 8/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class CompanyNewsCell: UITableViewCell {
    
    enum ReuseID {
        static let newsCell = "newsCell"
    }
    
    lazy var newsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .white
        tv.register(NewsCell.self, forCellReuseIdentifier: ReuseID.newsCell)
        let fv = UIView()
        fv.backgroundColor = .clear
        tv.tableFooterView = fv
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(newsTableView)
        newsTableView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight, .bottomLeft], radius: 16)
    }
    
}

extension CompanyNewsCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.newsCell, for: indexPath) as? NewsCell
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hv = UIView()
        hv.backgroundColor = .clear
        return hv
    }
}

fileprivate class NewsCell: UITableViewCell {
    
    let headerLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = UIFont.details1
        l.text = "Should Roku’s Fast Growth Worry Netflix and Peers?"
        return l
    }()
    
    let detailLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = UIFont.details2
        l.text = "Roku (ROKU), a competitor with Netflix, is growing at a fantastic rate. The company saw 59% year-over-year growth in revenues in the second quarter."
        return l
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, detailLabel])
        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        addSubview(labelStackView)
        labelStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                              padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}






















