//
//  Saveditem.swift
//  Upful
//
//  Created by Yanik Simpson on 11/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct Screener: Hashable {
    static func == (lhs: Screener, rhs: Screener) -> Bool {
        return lhs.savedScreener.title == rhs.savedScreener.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(savedScreener.title)
    }
    
    var savedScreener: SavedScreener
    var savedParameters: [SavedScreenerParameter]
    let title: String
    let description: String
    
    init(savedScreener: SavedScreener, savedParameters: [SavedScreenerParameter]) {
        self.savedScreener = savedScreener
        self.savedParameters = savedParameters
        self.title = savedScreener.title
        self.description = savedScreener.screenDescription ?? "No Description"
    }
    
    func configureDescription() -> String {
        var str = ""
        for param in savedParameters {
            var description = ""
            description.append(SearchCriteria(rawValue: param.criteria)!.explicit + " ")
            description.append(SearchParameter(rawValue: param.parameter)!.explicit + " ")
            switch SearchCriteria(rawValue: param.criteria)!.parameterType {
            case .percentage:
                description.append("\(param.value.convertToPercent())%\n")
            case .number:
                description.append("$\(Int(param.value).formatUsingAbbreviation())\n")
            case .ratio:
                description.append("\(param.value.twoDecimal())\n")
            default: break
            }
            str.append(description)
        }
        return str
    }
    
    func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        savedParameters.forEach { (savedParam) in
            let criteria = SearchCriteria(rawValue: savedParam.criteria)!.rawValue
            let parameter = SearchParameter(rawValue: savedParam.parameter)!.rawValue
            urlComponents.append(criteria + "\(parameter)~\(savedParam.value)")
        }
        return urlComponents
    }
}

