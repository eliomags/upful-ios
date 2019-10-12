//
//  PreferenceDataLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 10/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class PreferenceDataLoader {
    func load() -> [[PreferenceViewModel]] {
        let preferences = [
        createIndustryPreferences(),
        createGrowthPreferences(),
        createProfitabilityPreferences(),
        createDividendPreferences()
            ]
        
        return preferences.map({ $0.map({ PreferenceViewModel(preference: $0) })})
    }
    
    private func createIndustryPreferences() -> [Preference] {
        var industryPreferencesss = [Preference]()
        PreferenceID.allCases.forEach { (preference) in
            if preference.category() == PreferenceCategory.industry {
                if preference == .industryAny {
                    let newPreference = Preference(description: "Any", criteria: .industrycategory, parameter: .equal, value: preference.rawValue, id: preference)
                    industryPreferencesss.append(newPreference)
                } else {
                    let newPreference = Preference(description: preference.rawValue, criteria: .industrycategory, parameter: .equal, value: preference.rawValue, id: preference)
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
            Preference(description: "Negative", criteria: .revenuegrowth, parameter: SearchParameter.lt, value: "0.0", id: .growthNegative)
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
