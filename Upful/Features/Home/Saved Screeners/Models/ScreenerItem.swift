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
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    let title: String
    let description: String
    let urlComponents: [String]
    let manualScreenItems: [ManualScreenItem] /// used for edit navigation & result description
    let imageUrlString: String?
    
    init(title: String, description: String, urlComponents: [String],
         imageUrlString: String?, manualScreenItems: [ManualScreenItem]) {
        self.title = title
        self.description = description
        self.urlComponents = urlComponents
        self.manualScreenItems = manualScreenItems
        self.imageUrlString = imageUrlString
    }
}

extension Array where Element: SavedScreenerParameter {
    func configureURLComponents() -> [String] {
        var urlComponents: [String] = []
        self.forEach { (savedParam) in
            let criteria = SearchCriteria(rawValue: savedParam.criteria)!.rawValue
            let parameter = SearchParameter(rawValue: savedParam.parameter)!.rawValue
            urlComponents.append(criteria + "\(parameter)~\(savedParam.value)")
        }
        return urlComponents
    }
    
    func configureDescription() -> String {
        var str = ""
        for param in self {
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
    
    func mapToManualScreenItems() -> [ManualScreenItem] {
        let manualScreeningParameters = self.map { (param) -> ManualScreenItem in
            let criteria = SearchCriteria(rawValue: param.criteria)
            let parameter = SearchParameter(rawValue: param.parameter)
            return ManualScreenItem(criteria: criteria!, parameter: parameter!, value: param.value)
        }
        return manualScreeningParameters
    }
}


extension Array where Element == ManualScreenItem {
    var asURLComponents: [String] {
        var urlComponents: [String] = []
        self.forEach { (manualScreenItem) in
            let criteria = manualScreenItem.criteria.rawValue
            let parameter = manualScreenItem.parameter.rawValue
            urlComponents.append(criteria + "\(parameter)~\(manualScreenItem.value ?? 0)")
        }
        return urlComponents
    }

    var asDescription: String {
        var str = ""
        self.forEach { (manualScreenItem) in
            var description = ""
            description.append(manualScreenItem.criteria.explicit + " ")
            description.append(manualScreenItem.parameter.explicit + " ")
            switch manualScreenItem.criteria.parameterType {
            case .percentage:
                description.append("\(manualScreenItem.value?.convertToPercent() ?? "")%\n")
            case .number:
                description.append("$\(Int(manualScreenItem.value ?? 0).formatUsingAbbreviation())\n")
            case .ratio:
                description.append("\(manualScreenItem.value?.twoDecimal() ?? "")\n")
            default: break
            }
            str.append(description)
        }
        return str
    }
}
