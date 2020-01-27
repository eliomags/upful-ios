//
//  GenericNewsCell.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericNewsCell: UITableViewCell {
    
    var stockNews: StockNewsViewModel? {
        didSet {
            guard let stockNews = stockNews else { return }
            setLoaded()
            titleLabel.text = stockNews.title
            sourceLabel.text = stockNews.sourceName
            dateLabel.text = stockNews.date
            sentimentView.sentimentLabel.text = stockNews.sentiment
            sentimentView.setSentiment(with: stockNews.sentiment)
            setImage()
        }
    }
    
    // MARK: - Views
    
    // MARK: Detail View
    let sourceLabel: UILabel = {
        let l = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        l.font = UIFont.systemFont(ofSize: font.pointSize, weight: .heavy)
        l.text = ""
        l.numberOfLines = 0
        return l
    }()
    let dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .caption2)
        l.text = ""
        l.numberOfLines = 0
        return l
    }()
    lazy var detailStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sourceLabel, dateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 3
        return sv
    }()
    
    // MARK: Text View
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.text = "\n"
        l.numberOfLines = 0
        return l
    }()
        
    lazy var textContextStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    let articleImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray2
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 4
        return v
    }()
    
    // MARK: Sentiment View
    
    let sentimentView: SentimentView = {
        let v = SentimentView()
        return v
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setLoading()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "\n"
        sourceLabel.text = ""
        dateLabel.text = ""
    }
    
    // MARK: - Fileprivate Methods
    
    func setImage() {
        guard let stocknews = stockNews else { return }
        UIImage.loadImage(from: stocknews.imageUrl, resize: 120) { (result) in
            switch result {
            case .success(let image):
                self.articleImageView.image = image
                self.articleImageView.backgroundColor = .clear
            case .failure(_):
                break
            }
        }
    }
    fileprivate func setLoading() {
        sourceLabel.backgroundColor = VersionManager.loadingLabelColor()
        dateLabel.backgroundColor = VersionManager.loadingLabelColor()
        articleImageView.backgroundColor = VersionManager.loadingLabelColor()
        titleLabel.backgroundColor = VersionManager.loadingLabelColor()
        sourceLabel.backgroundColor = VersionManager.loadingLabelColor()
        dateLabel.backgroundColor = VersionManager.loadingLabelColor()
    }
    
    fileprivate func setLoaded() {
        sourceLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
        titleLabel.backgroundColor = .clear
        sourceLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
    }
}
