//
//  ProfileConfigurator.swift
//  Upful
//
//  Created by Yanik Simpson on 5/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class UserProfile {
    
    private enum Constants {
        static let isNewUser = "isNewUser"
        static let profileID = "profileID"
    }
    
    private init() {}
    static let instance = UserProfile()
    
    private var isNewUser: Bool {
        return !UserDefaults.standard.bool(forKey: Constants.isNewUser)
    }
    
    lazy var profileID: String = {
        if isNewUser {
            let profileID = UserProfile.generateUserID()
            UserDefaults.standard.set(true, forKey: Constants.isNewUser)
            UserDefaults.standard.set(profileID, forKey: Constants.profileID)
            return profileID
        } else {
            guard let savedID = UserDefaults.standard.string(forKey: Constants.profileID) else {
                assertionFailure("No ID found.")
                return "Unrecognized User"
            }
            return savedID
        }
    }()
    
    private static func generateUserID() -> String {
        return UUID().uuidString
    }
}
