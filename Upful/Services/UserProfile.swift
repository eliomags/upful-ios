//
//  UserProfile.swift
//  Upful
//
//  Created by Yanik Simpson on 5/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

class ProfileDataManager {
    
    enum ProfileDataError: Error {
        case noPreviousTransactions
        
        var localizedDescription: String {
            switch self {
            case .noPreviousTransactions:
                return "No previoous transactions found"
            }
        }
    }
    
    let userProfile: UserProfile = UserProfile()
    private let ledgerLoader: TransactionLoader
    
    init(ledgerLoader: TransactionLoader = LocalTransactionLedgerLoader()) {
        self.ledgerLoader = ledgerLoader
    }
    
    func weeksFromFirstTradeDate(completion: @escaping (Double?) -> Void) {
        fetchFirstTransactionDate { result in
            switch result {
            case .success(let earliestDate):
                if let earliestDate = earliestDate {
                    let range = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute],
                                                                                from: earliestDate,
                                                                                to: Date())
                    
                    let weekDiff = Double(range.weekOfYear ?? 0)
                    let dayDiff = Double((range.day ?? 0)) / 5
                    let hourDiff = Double((range.hour ?? 0)) / (5 * 24)
                    let minDiff = Double((range.minute ?? 0)) / (5 * 24 * 60)
                    let totalTimeDifference: Double = weekDiff + dayDiff + hourDiff + minDiff
                    
                    completion(totalTimeDifference)
                } else {
                    completion(0)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func fetchFirstTransactionDate(completion: @escaping (Result<Date?, Error>) -> Swift.Void) {
        if let userFirstTransactionDate = userProfile.firstTransactionDate {
            completion(.success(userFirstTransactionDate))
        }
        ledgerLoader.load { (result) in
            switch result {
            case .success(let transactions):
                
                if let firstTransactionDate = transactions.sorted(by: { self.convertToDate(from: $0.transactionDate!) <
                    self.convertToDate(from: $1.transactionDate!) }).first?.transactionDate {
                    completion(.success(self.convertToDate(from: firstTransactionDate)))
                } else {
                    completion(.success(nil))
                }
            case .failure(_):
                completion(.failure(ProfileDataError.noPreviousTransactions))
            }
        }
    }
    
    func convertToDate(from string: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return df.date(from: string)!
    }
}

// need to be initialized with UserDefaults instance

class UserProfile {
    
    private enum Constants {
        static let isNewUser = "isNewUser"
        static let profileID = "profileID"
    }
        
    // MARK: Properties
    
    var firstTransactionDate: Date?
    
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
    
    private var isNewUser: Bool {
        return !UserDefaults.standard.bool(forKey: Constants.isNewUser)
    }
    
    // MARK: Singleton Instantiation
    
    static let instance = UserProfile()
    
    init() {}
}

extension UserProfile {
    
    private static func generateUserID() -> String {
        return UUID().uuidString
    }
}
