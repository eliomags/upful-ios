//
//  PreferenceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol DataManager: class {
    associatedtype T
    associatedtype U
    var data: [U] { get set }
    func remove(_ item: T)
    func update(_ item: T)
    func save()
}


final class PreferenceDataManager: DataManager {
    // MARK: - Dependencies

    let dataLoader = PreferenceDataLoader()
    
    // MARK: - State
    
    enum PreferenceName {
        static let hasAddedPreferece = "hasAddedPreference"
        static let industryPreferences = "industryPreferences"
        static let metricPreferences = "preference"
    }
    
    var data: [[Preference]] = []
    var savedPreferences: Set<String> = []
    
    // MARK: - Initializer
    
    init() {
        data = dataLoader.load()
        savedPreferences = Set(retrieveSavedPreferences().map({ $0 }))
        print(savedPreferences)
    }
    
    // MARK: - API
    
    func update(_ preferenceType: PreferenceType) {
        self.savedPreferences.update(with: preferenceType.rawValue)
        print(savedPreferences)
    }
    
    func remove(_ preferenceType: PreferenceType) {
        self.savedPreferences = savedPreferences.filter({ $0 != preferenceType.rawValue })
    }
    
    func save() {
        let newPreferences: [String] = self.savedPreferences.map({ $0 })
        UserDefaults.standard.set(newPreferences, forKey: PreferenceName.metricPreferences)
        print(retrieveSavedPreferences())
    }
    
    // MARK: - Helpers
    
    func retrieveSavedPreferences() -> [String] {
        let items: [String] = UserDefaults.standard.stringArray(forKey: PreferenceName.metricPreferences) ?? []
        return items
//        let preferenceTypes: [PreferenceType] = items.compactMap({ (PreferenceType(rawValue: $0)) })
//        return preferenceTypes
    }
}


final class PreferenceDataLoader {
    func load() -> [[Preference]] {
        return
            [
            createIndustryPreferences(),
            createGrowthPreferences(),
            createProfitabilityPreferences(),
            createDividendPreferences()
            ]
    }
    
    private func createIndustryPreferences() -> [Preference] {
        var industryPreferencesss = [Preference]()
        PreferenceType.allCases.forEach { (preference) in
            if preference.category() == PreferenceCategory.industry {
                if preference == .industryAny {
                    let newPreference = Preference(description: "Any", criteria: .industrycategory, parameter: .lt, value: preference.rawValue, id: preference)
                    industryPreferencesss.append(newPreference)
                } else {
                    let newPreference = Preference(description: preference.rawValue, criteria: .industrycategory, parameter: .lt, value: preference.rawValue, id: preference)
                    industryPreferencesss.append(newPreference)
                }
            }
        }
        return industryPreferencesss
    }
    
    private func createGrowthPreferences() -> [Preference] {
        let growthPreferences: [Preference] =
        [
            Preference(description: "Any", criteria: .revenuegrowth, parameter: SearchParameter.gt, value: "0", id: .growthAny),
            Preference(description: "High", criteria: .revenuegrowth, parameter: SearchParameter.gt, value: "0.25", id: .growthHigh),
            Preference(description: "Medium", criteria: .revenuegrowth, parameter: SearchParameter.gt, value: "0.10", id: .growthMedium),
            Preference(description: "Low", criteria: .revenuegrowth, parameter: SearchParameter.gt, value: "0.10", id: .growthLow),
            Preference(description: "Negative", criteria: .revenuegrowth, parameter: SearchParameter.lt, value: "0.0", id: .profitabilityNegative)
        ]
        return growthPreferences
    }
    
    private func createProfitabilityPreferences() -> [Preference] {
        let profitabilityPreferences: [Preference] =
        [
            Preference(description: "Any", criteria: .ebitmargin, parameter: SearchParameter.gt, value: "0", id: .profitabilityAny),
            Preference(description: "High", criteria: .ebitmargin, parameter: SearchParameter.gt, value: "0.25", id: .profitabilityHigh),
            Preference(description: "Medium", criteria: .ebitmargin, parameter: SearchParameter.gt, value: "0.10", id: .profitabilityMedium),
            Preference(description: "Low", criteria: .ebitmargin, parameter: SearchParameter.gt, value: "0.10", id: .profitabilityLow),
            Preference(description: "Negative", criteria: .ebitmargin, parameter: SearchParameter.lt, value: "0.0", id: .profitabilityNegative)
        ]
        return profitabilityPreferences
    }
    
    private func createDividendPreferences() -> [Preference] {
        let dividendPreferences: [Preference] =
        [
            Preference(description: "Any", criteria: .dividendyield, parameter: SearchParameter.gt, value: "0", id: .dividendAny),
            Preference(description: "High", criteria: .dividendyield, parameter: SearchParameter.gt, value: "0.25", id: .dividendHigh),
            Preference(description: "Medium", criteria: .dividendyield, parameter: SearchParameter.gt, value: "0.10", id: .dividendMedium),
            Preference(description: "Low", criteria: .dividendyield, parameter: SearchParameter.gt, value: "0.10", id: .dividendLow),
            Preference(description: "None", criteria: .dividendyield, parameter: SearchParameter.gt, value: "0", id: .dividendNone)
        ]
        return dividendPreferences
    }
    
}
