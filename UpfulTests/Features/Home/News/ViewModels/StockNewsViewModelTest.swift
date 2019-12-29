//
//  StockNewsViewModelTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockNewsViewModelTest: XCTestCase {

    var sut: StockNewsViewModel!
    
    
    func testTodayConversion() {
        sut = makeSUTToday()
        XCTAssertEqual(sut!.date, "Today")
    }
    
    func testYesterdayConversion() {
        sut = makeSUTYesterday()
        XCTAssertEqual(sut!.date, "Yesterday")
    }
    
    func test2DaysAgoConversion() {
        sut = makeSUT2DaysAgo()
        XCTAssertEqual(sut!.date, "2D Ago")
    }
     
    
    
    // MARK: - Helpers
    
    fileprivate func makeSUTToday() -> StockNewsViewModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let date = formatter.string(from: Date())
        
        return StockNewsViewModel(stockNews: StockNews(newsUrl: "", imageUrl: "", title: "", text: "", sourceName: "", date: date, sentiment: ""))
    }
    
    fileprivate func makeSUTYesterday() -> StockNewsViewModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let convertingDate = Date().dayBefore
        let date = formatter.string(from: convertingDate)
        
        return StockNewsViewModel(stockNews: StockNews(newsUrl: "", imageUrl: "", title: "", text: "", sourceName: "", date: date, sentiment: ""))
    }
    
    fileprivate func makeSUT2DaysAgo() -> StockNewsViewModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let convertingDate = Date().getPreviousDate(days: 2)
        let date = formatter.string(from: convertingDate)
        
        return StockNewsViewModel(stockNews: StockNews(newsUrl: "", imageUrl: "", title: "", text: "", sourceName: "", date: date, sentiment: ""))
    }
}
