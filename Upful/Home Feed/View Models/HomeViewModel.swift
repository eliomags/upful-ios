//
//  HomeViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class CompanyViewModel {
    static var facebook = PopularCompany(details: "Facebook, Inc.", header: "FB")
    static var netflix = PopularCompany(details: "Netflix", header: "NFLX")
    static var apple = PopularCompany(details: "Apple", header: "AAPL")
    static var amazon = PopularCompany(details: "Amazon.com", header: "AMZN")
    static var google = PopularCompany(details: "Alphabet Inc.", header: "GOOGL")
    static var twitter = PopularCompany(details: "Twitter", header: "TWTR")
    static var microsoft = PopularCompany(details: "Microsoft Corporation", header: "MSFT")
    static var mongoDB = PopularCompany(details: "MongoDB Inc.", header: "MDB")
    
    static func configureCompanyList() -> [PopularCompany] {
        return [facebook, netflix, apple, amazon, google, twitter, microsoft, mongoDB]
    }
}


class PresetScreenverViewModel {
    var value1: PresetScreener = PresetScreener(header: "VALUE 1",
                                                details: "Price to Earnings < 20\nPrice to Book < 6\nEBIT Margin > 5%",
                                                screenType: .value, identifier: .value1)
    var value2: PresetScreener = PresetScreener(header: "VALUE 2",
                                                details: "Price to Earnings < 20\nPrice to Book < 10\nEBIT Margin > 10%\n1 Year Revenue Growth > 5%",
                                                screenType: .value, identifier: .value2)
    var value3: PresetScreener = PresetScreener(header: "VALUE 3",
                                                details: "Price to Earnings < 30\nFree Cash Flow Growth > 10%\nEBIT Margin > 40%",
                                                screenType: .value, identifier: .value3)
    
    func configureValueData() -> [PresetScreener] {
        value1.createURLComponent(criteria: .name, parameter: .gt, 0)
        value1.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 20)
        value1.createURLComponent(criteria: .pricetobook, parameter: .lt, 6)
        value1.createURLComponent(criteria: .ebitmargin, parameter: .gt, 0.05)

        value2.createURLComponent(criteria: .name, parameter: .gt, 0)
        value2.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 25)
        value2.createURLComponent(criteria: .pricetobook, parameter: .lt, 10)
        value2.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.05)
        value2.createURLComponent(criteria: .ebitmargin, parameter: .gt, 0.10)
        
        value3.createURLComponent(criteria: .name, parameter: .gt, 0)
        value3.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 30)
        value3.createURLComponent(criteria: .fcffgrowth, parameter: .gt, 0.10)
        value3.createURLComponent(criteria: .ebitmargin, parameter: .lt, 0.4)

        return [value1,value2,value3]
    }
    
    var growth1: PresetScreener = PresetScreener(header: "GROWTH 1",
                                                 details: "1 Year EPS Growth > 10%\n1 Year Invested Capital Growth > 5%",
                                                 screenType: .growth, identifier: .growth1)
    var growth2: PresetScreener = PresetScreener(header: "GROWTH 2",
                                                 details: "1 Year Revenue Growth > 10%\nPrice to Revenue < 15",
                                                 screenType: .growth, identifier: .growth2)
    var growth3: PresetScreener = PresetScreener(header: "GROWTH 3",
                                                 details: "1 Year EPS Growth > 35%\nPrice to Revenue < 10",
                                                 screenType: .growth, identifier: .growth3)

    func configureGrowthData() -> [PresetScreener] {
        growth1.createURLComponent(criteria: .name, parameter: .gt, 0)
        growth1.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.1)
        growth1.createURLComponent(criteria: .investedcapitalgrowth, parameter: .gt, 0.05)
        
        growth2.createURLComponent(criteria: .name, parameter: .gt, 0)
        growth2.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.1)
        growth2.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 15)

        growth3.createURLComponent(criteria: .name, parameter: .gt, 0)
        growth3.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.35)
        growth3.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 10)
        
        return [growth1,growth2,growth3]
    }
    
    var dividend1: PresetScreener = PresetScreener(header: "DIVIDEND 1",
                                                 details: "Dividend Yield > 2%\nPayout Ratio < 60%",
                                                 screenType: .dividend, identifier: .dividend1)
    var dividend2: PresetScreener = PresetScreener(header: "DIVIDEND 2",
                                                   details: "Dividend Yield > 0%\nRevenue Growth > 10%\nPrice to Revenue < 15",
                                                 screenType: .dividend, identifier: .dividend2)
    var dividend3: PresetScreener = PresetScreener(header: "DIVIDEND 3",
                                                   details: "Dividend Yield > 1%\nPayout Ratio < 50%\nEPS Growth > 10%",
                                                 screenType: .dividend, identifier: .dividend3)
    
    func configureDividendData() -> [PresetScreener] {
        dividend1.createURLComponent(criteria: .name, parameter: .gt, 0)
        dividend1.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.02)
        dividend1.createURLComponent(criteria: .divpayoutratio, parameter: .lt, 0.60)
        
        dividend2.createURLComponent(criteria: .name, parameter: .gt, 0)
        dividend2.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.00)
        dividend2.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.1)
        dividend2.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 15)
        
        dividend3.createURLComponent(criteria: .name, parameter: .gt, 0)
        dividend3.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.01)
        dividend3.createURLComponent(criteria: .divpayoutratio, parameter: .lt, 0.50)
        dividend3.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.1)
        
        return [dividend1, dividend2, dividend3]
    }

}













