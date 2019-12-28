//
//  StockNews.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct StockNewsData: Decodable {
    let data: [StockNews]
}

struct StockNews: Decodable {
    let newsUrl: String
    let imageUrl: String
    let title: String
    let text: String
    let sourceName: String
    let date: String
    let sentiment: String
    let tickers: [String]
    
    enum CodingKeys: String, CodingKey {
        case newsUrl = "news_url"
        case imageUrl = "image_url"
        case title, text
        case sourceName = "source_name"
        case date, sentiment, tickers
    }
}
