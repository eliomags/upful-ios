//
//  HomeViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CompanyViewModel {
    static let facebook = PopularCompany(details: "Facebook Inc", header: "FB")
    static let netflix = PopularCompany(details: "Netflix Inc", header: "NFLX")
    static let apple = PopularCompany(details: "Apple Inc", header: "AAPL")
    static let amazon = PopularCompany(details: "Amazon.com Inc", header: "AMZN")
    static let google = PopularCompany(details: "Alphabet Inc", header: "GOOGL")
    static let twitter = PopularCompany(details: "Twitter Inc", header: "TWTR")
    static let microsoft = PopularCompany(details: "Microsoft Corp", header: "MSFT")
    static let mongoDB = PopularCompany(details: "MongoDB Inc", header: "MDB")
    
    static func configureCompanyList() -> [PopularCompany] {
        return [facebook, netflix, apple, amazon, google, twitter, microsoft, mongoDB]
    }
}

class PresetFeedDataLoader {
    private let value1: PresetScreener = PresetScreener(
                                                header: "Value stocks 1",
                                                details: "Price to Earnings < 20\nPrice to Book < 6\nEBIT Margin > 5%",
                                                screenType: .value, identifier: .value1)
    private let value2: PresetScreener = PresetScreener(
                                                header: "Value stocks 2",
                                                details: "Price to Earnings < 20\nPrice to Book < 10\nEBIT Margin > 10%\n1 Year Revenue Growth > 5%",
                                                screenType: .value, identifier: .value2)
    private let value3: PresetScreener = PresetScreener(
                                                header: "Value stocks 3",
                                                details: "Price to Earnings < 30\nFree Cash Flow Growth > 10%\nEBIT Margin > 40%",
                                                screenType: .value, identifier: .value3)
    
    private let growth1: PresetScreener = PresetScreener(
                                                header: "Growth stocks 1",
                                                details: "1 Year EPS Growth > 10%\n1 Year Invested Capital Growth > 5%",
                                                screenType: .growth, identifier: .growth1)
    private let growth2: PresetScreener = PresetScreener(
                                                header: "Growth stocks 2",
                                                details: "1 Year Revenue Growth > 10%\nPrice to Revenue < 15",
                                                screenType: .growth, identifier: .growth2)
    private let growth3: PresetScreener = PresetScreener(
                                                header: "Growth stocks 3",
                                                details: "1 Year EPS Growth > 35%\nPrice to Revenue < 10",
                                                screenType: .growth, identifier: .growth3)
    
    private let dividend1: PresetScreener = PresetScreener(
                                                header: "Dividend stocks 1",
                                                details: "Dividend Yield > 2%\nPayout Ratio < 60%",
                                                screenType: .dividend, identifier: .dividend1)
    private let dividend2: PresetScreener = PresetScreener(
                                                header: "Dividend stocks 2",
                                                details: "Dividend Yield > 0%\nRevenue Growth > 10%\nPrice to Revenue < 15",
                                                screenType: .dividend, identifier: .dividend2)
    private let dividend3: PresetScreener = PresetScreener(
                                                header: "Dividend stocks 3",
                                                details: "Dividend Yield > 1%\nPayout Ratio < 50%\nEPS Growth > 10%",
                                                screenType: .dividend, identifier: .dividend3)
    
    
    func configureCompanyList() -> [PopularCompany] {
        
        return CompanyViewModel.configureCompanyList()
    }
    
    func configureValueData() -> [PresetScreenerViewModel] {
        let value1VM = PresetScreenerViewModel(presetScreener: value1)
        let value2VM = PresetScreenerViewModel(presetScreener: value2)
        let value3VM = PresetScreenerViewModel(presetScreener: value3)
        
        return [value1VM, value2VM, value3VM]
    }
    
    func configureGrowthData() -> [PresetScreenerViewModel] {
        let growth1VM = PresetScreenerViewModel(presetScreener: growth1)
        let growth2VM = PresetScreenerViewModel(presetScreener: growth2)
        let growth3VM = PresetScreenerViewModel(presetScreener: growth3)
        
        return [growth1VM, growth2VM, growth3VM]
    }
    
    func configureDividendData() -> [PresetScreenerViewModel] {
        let dividend1VM = PresetScreenerViewModel(presetScreener: dividend1)
        let dividend2VM = PresetScreenerViewModel(presetScreener: dividend2)
        let dividend3VM = PresetScreenerViewModel(presetScreener: dividend3)
        
        return [dividend1VM, dividend2VM, dividend3VM]
    }
}













