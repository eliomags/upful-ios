//
//  HomeViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct CompanyViewModel {
    static let facebook = PopularCompany(details: "Facebook, Inc.", header: "FB")
    static let netflix = PopularCompany(details: "Netflix", header: "NFLX")
    static let apple = PopularCompany(details: "Apple", header: "AAPL")
    static let amazon = PopularCompany(details: "Amazon.com", header: "AMZN")
    static let google = PopularCompany(details: "Alphabet Inc.", header: "GOOGL")
    static let twitter = PopularCompany(details: "Twitter", header: "TWTR")
    static let microsoft = PopularCompany(details: "Microsoft Corporation", header: "MSFT")
    static let mongoDB = PopularCompany(details: "MongoDB Inc.", header: "MDB")
    
    static func configureCompanyList() -> [PopularCompany] {
        return [facebook, netflix, apple, amazon, google, twitter, microsoft, mongoDB]
    }
}

struct PresetScreenverViewModel {
    static let value1 = PresetScreener(header: "Value 1", details: "Value 1 Details", url: "", backgroundImage: "value 1 image")
    static let value2 = PresetScreener(header: "Value 2", details: "Value 2 Details", url: "", backgroundImage: "value 2 image")
    static let value3 = PresetScreener(header: "Value 3", details: "Value 3 Details", url: "", backgroundImage: "value 1 image")
    static let value4 = PresetScreener(header: "Value 4", details: "Value 4 Details", url: "", backgroundImage: "value 2 image")
    
    static let growth1 = PresetScreener(header: "Growth 1", details: "Growth 1 Details", url: "", backgroundImage: "Growth 1 image")
    static let growth2 = PresetScreener(header: "Growth 2", details: "Growth 2 Details", url: "", backgroundImage: "Growth 2 image")
    static let growth3 = PresetScreener(header: "Growth 3", details: "Growth 3 Details", url: "", backgroundImage: "Growth 1 image")
    static let growth4 = PresetScreener(header: "Growth 4", details: "Growth 4 Details", url: "", backgroundImage: "Growth 2 image")
    
    static let dividend1 = PresetScreener(header: "Dividend 1", details: "Dividend 1 Details", url: "", backgroundImage: "Dividend 1 image")
    static let dividend2 = PresetScreener(header: "Dividend 2", details: "Dividend 2 Details", url: "", backgroundImage: "Dividend 2 image")
    static let dividend3 = PresetScreener(header: "Dividend 3", details: "Dividend 3 Details", url: "", backgroundImage: "Dividend 1 image")
    static let dividend4 = PresetScreener(header: "Dividend 4", details: "Dividend 4 Details", url: "", backgroundImage: "Dividend 2 image")
    
    
    static func configureValueData() -> [PresetScreener] {
        return [value1, value2, value3, value4]
    }
    
    static func configureGrowthData() -> [PresetScreener] {
        return [growth1, growth2, growth3, growth4]
    }
    
    static func configureDividendData() -> [PresetScreener] {
        return [dividend1, dividend2, dividend3, dividend4]
    }
}













