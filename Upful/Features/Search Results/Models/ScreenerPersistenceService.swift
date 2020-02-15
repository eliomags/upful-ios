//
//  ScreenerPersistenceService.swift
//  Upful
//
//  Created by Yanik Simpson on 2/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

protocol ScreenerPersister {
    
}

class ScreenerPersistenceService {
    func save(title: String, description: String, components: [String]) {
        
    }
    
    // add SavedScreener property
    func mapValueComponents(from searchCriteria: String) {
        let arr = Array(searchCriteria)
        var i = 0
        var j = 0
        var criteria = String()
        var parameter = String()
        var value: Double? = 0
        
        while j < arr.count {
            if arr[j] == "~" {
                if criteria.isEmpty {
                    criteria.append(contentsOf: arr[i...(j-1)])
                    i = j + 1
                } else if parameter.isEmpty {
                    parameter.append(contentsOf: arr[i...(j-1)])
                    i = j + 1
                }
            }
            if j == arr.count - 1 {
                value = Double(String(arr[i...j]))
            }
            j += 1
        }
        print(criteria)
        print(parameter)
        if let value = value {
            print(value)
        } else {
            mapStringComponents(from: searchCriteria)
        }
    }
    
    func mapStringComponents(from searchCriteria: String) {
        let arr = Array(searchCriteria)
        var i = 0
        var j = 0
        var criteria = String()
        var parameter = String()
        var value = String()
        
        while j < arr.count {
            if arr[j] == "~" {
                if criteria.isEmpty {
                    criteria.append(contentsOf: arr[i...(j-1)])
                    i = j + 1
                } else if parameter.isEmpty {
                    parameter.append(contentsOf: arr[i...(j-1)])
                    i = j + 1
                }
            }
            if j == arr.count - 1 {
                value = String(arr[i...j])
            }
            j += 1
        }
        print(criteria)
        print(parameter)
        print(value)
    }
}
