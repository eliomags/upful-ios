//
//  PresetScreener.swift
//  Upful
//
//  Created by Yanik Simpson on 8/18/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

enum PresetScreenType: String {
    case value,growth,dividend
}

enum ScreenerIdentifier: String{
    case value1, value2, value3
    case growth1, growth2, growth3
    case dividend1, dividend2, dividend3
}

struct PresetScreener: FeedItem {
    var header: String
    var details: String?
    let screenType: PresetScreenType
    var urlComponents: [String] = []
    var identifier: ScreenerIdentifier
    
    init(header: String, details: String, screenType: PresetScreenType, identifier: ScreenerIdentifier) {
        self.header = header
        self.details = details
        self.screenType = screenType
        self.identifier = identifier
    }
    
    mutating func createURLComponent(criteria: SearchCriteria, parameter: SearchParameter, _ value: Double) {
        self.urlComponents.append(criteria.rawValue + "\(parameter.rawValue)~\(value)")
    }
}


















