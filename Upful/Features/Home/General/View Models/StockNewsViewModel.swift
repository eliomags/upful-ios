//
//  StockNewsViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct StockNewsViewModel: Hashable {
    let newsUrl: String
    let imageUrl: String
    let title: String
    let sourceName: String
    let sentiment: String
    
    private(set) var date: String = ""
    private(set) var imageData: Data?

    init(stockNews: StockNews) {
        self.newsUrl = stockNews.newsUrl
        self.imageUrl = stockNews.imageUrl
        self.title = stockNews.title
        self.sourceName = stockNews.sourceName
        self.sentiment = stockNews.sentiment
        self.date = self.convert(date: stockNews.date)
    }
    
    fileprivate func convert(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US")
        let newDate = formatter.date(from: date)
        
        let component = Calendar.current.dateComponents([.day], from: newDate ?? Date(), to: Date())
        
        let dayDifference = component.day ?? 0
        switch dayDifference {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return "\(dayDifference)D Ago"
        }
    }
}

