//
//  UserDefaults+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 4/28/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Consts: String {
        case firstAppOpen = "firstAppOpen"
    }
    
    var firstAppOpen: Bool {
        let firstOpenString = Consts.firstAppOpen.rawValue
        return !self.bool(forKey: firstOpenString)
    }
    
}

extension UserDefaults {
    
    func toggleBool(_ named: Consts) {
        let currentBool = bool(forKey: named.rawValue)
        
        set(!currentBool, forKey: named.rawValue)
    }
}
