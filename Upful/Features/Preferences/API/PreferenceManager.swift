//
//  PreferenceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class PreferenceDataManager: DataManager {
    // MARK: - Dependencies

    let dataLoader: PreferenceDataLoader
    
    // MARK: - State
    
    enum PreferenceName {
        static let hasAddedPreferece = "hasAddedPreference"
        static let industryPreferences = "industryPreferences"
        static let metricPreferences = "preference"
    }
    
    var data: [[PreferenceViewModel]] = []
    var savedPreferences: [String] = []
    
    // MARK: - Initializer
    
    init(dataLoader: PreferenceDataLoader = .init()) {
        self.dataLoader = dataLoader
        data = dataLoader.load()
        savedPreferences = retrieveSavedPreferences().map({ $0 })
    }
    
    // MARK: - API
    
    func update(_ preferenceType: PreferenceID) {
        self.savedPreferences.append(preferenceType.rawValue)
    }
    
    func remove(_ preferenceType: PreferenceID) {
        self.savedPreferences = savedPreferences.filter({ $0 != preferenceType.rawValue })
    }
    
    func save() {
        let newPreferences: [String] = self.savedPreferences.map({ $0 })
        UserDefaults.standard.set(newPreferences, forKey: PreferenceName.metricPreferences)
    }
    
    // MARK: - Helpers
            
    func getIndustriesForNetworking() -> [String] {
        let preferenceViewModelOptions = data.flatMap({ $0.map({ $0 })})
        let savedPreferenceIDs: [PreferenceID] = savedPreferences.compactMap({ PreferenceID(rawValue: $0) })
        var filteredSelections: [String] = []

        var savedIndustriesAsViewModels: [PreferenceViewModel] = []

        savedPreferenceIDs.forEach { (savedPreferenceID) in
            if savedPreferenceID.category() == .industry {
                let option = preferenceViewModelOptions.filter({ $0.id == savedPreferenceID })
                savedIndustriesAsViewModels.append(contentsOf: option)
            }
        }
        savedIndustriesAsViewModels.forEach { (viewModel) in
            filteredSelections.append(viewModel.criteria.rawValue + viewModel.parameter.rawValue + "~" + viewModel.value)
        }
        
        return filteredSelections
    }
    
    func getParametersForNetworking() -> [String] {
        let preferenceViewModelOptions = data.flatMap({ $0.map({ $0 })})
        let savedPreferenceIDs: [PreferenceID] = savedPreferences.compactMap({ PreferenceID(rawValue: $0) })
        var filteredSelections: [String] = []

        var savedPreferencesAsViewModels: [PreferenceViewModel] = []
        
        savedPreferenceIDs.forEach { (savedPreferenceID) in
            if savedPreferenceID.category() != .industry {
                let option = preferenceViewModelOptions.filter({ $0.id == savedPreferenceID })
                savedPreferencesAsViewModels.append(contentsOf: option)
            }
        }
        savedPreferencesAsViewModels.forEach { (viewModel) in
            filteredSelections.append(viewModel.criteria.rawValue + viewModel.parameter.rawValue + "~" + viewModel.value)
        }
        
        return filteredSelections
    }
    
    func retrieveSavedPreferences() -> [String] {
        let items: [String] = UserDefaults.standard.stringArray(forKey: PreferenceName.metricPreferences) ?? []
        return items
    }
    
    func retrieveSavedIDs() -> [PreferenceID] {
        return Array(savedPreferences.compactMap({ PreferenceID(rawValue: $0)! }))
    }
    
    func loadSavedPreferences() -> [PreferenceViewModel] {
        let allPreferences = data.flatMap({ $0 })
        var savedPreferences: [PreferenceViewModel] = []
        
        retrieveSavedIDs().forEach { (savedID) in
            allPreferences.forEach { (preference) in
                if preference.id == savedID {
                    savedPreferences.append(preference)
                }
            }
        }
        return savedPreferences
    }
    
}


