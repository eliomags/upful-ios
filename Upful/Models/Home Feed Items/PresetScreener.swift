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
    var details: String
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


extension PresetScreener {
    var screenImage: UIImage {
        switch identifier {
        case .value1:
            return #imageLiteral(resourceName: "value5").withRenderingMode(.alwaysOriginal)
        case .value2:
            return #imageLiteral(resourceName: "value1.png").withRenderingMode(.alwaysOriginal)
        case .value3:
            return #imageLiteral(resourceName: "value4.png").withRenderingMode(.alwaysOriginal)
            
        case .dividend1:
            return #imageLiteral(resourceName: "dividend2").withRenderingMode(.alwaysOriginal)
        case .dividend2:
            return #imageLiteral(resourceName: "dividend3").withRenderingMode(.alwaysOriginal)
        case .dividend3:
            return #imageLiteral(resourceName: "dividend1").withRenderingMode(.alwaysOriginal)
            
        case .growth1:
            return #imageLiteral(resourceName: "grwoth1").withRenderingMode(.alwaysOriginal)
        case .growth2:
            return #imageLiteral(resourceName: "value2").withRenderingMode(.alwaysOriginal)
        case .growth3:
            return #imageLiteral(resourceName: "growth2").withRenderingMode(.alwaysOriginal)
        }
    }
}


















