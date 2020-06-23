//
//  UserProfile.swift
//  Upful
//
//  Created by Yanik Simpson on 5/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import CoreData
import Foundation

class ProfileDataManager {
    
    enum ProfileDataError: Error {
        case noPreviousTransactions
        case userCreation
        
        var localizedDescription: String {
            switch self {
            case .noPreviousTransactions:
                return "No previoous transactions found"
            case .userCreation:
                return "Error creating user"
            }
        }
    }
    
    private enum Constants {
        static let profileID = "profileID"
    }
    
    // MARK: Dependencies
    
    private let ledgerLoader: TransactionLoader
    private let userProfile = UserProfile.instance
    
    private let userDefaults: UserDefaults
    private let managedObjectContext: NSManagedObjectContext
    
    // MARK: Initializer
    
    init(ledgerLoader: TransactionLoader = LocalTransactionLedgerLoader(),
         userDefaults: UserDefaults = UserDefaults.standard,
         managedObjectContext: NSManagedObjectContext) {
        self.userDefaults = userDefaults
        self.ledgerLoader = ledgerLoader
        self.managedObjectContext = managedObjectContext
    }
    
    // MARK: User CRUD
    
    func readUser() -> User? {
        let fetchRequest = User.createFetchRequest()
        guard
            let users = try? managedObjectContext.fetch(fetchRequest),
            let currentUser = users.first
            else { return nil }
        
        return currentUser
    }
    
    func createUser(completion: @escaping ((User) -> Void)) {
        let fetchRequest = User.createFetchRequest()
        let users = try? managedObjectContext.fetch(fetchRequest)
        
        guard users?.isEmpty ?? false else {
            completion((users?.first!)!)
            return
        }
        
        managedObjectContext.perform {
            let user = User.init(context: self.managedObjectContext)
            user.id = self.generateProfileID()
            
            try? self.managedObjectContext.save()
            completion(user)
        }
    }
    
    func createUser(firstTransactionDate: Date, completion: @escaping ((User) -> Void)) {
        let fetchRequest = User.createFetchRequest()
        let users = try? managedObjectContext.fetch(fetchRequest)
        
        guard users?.isEmpty ?? false else {
            completion((users?.first!)!)
            return
        }
        
        managedObjectContext.perform {
            let user = User.init(context: self.managedObjectContext)
            user.id = self.generateProfileID()
            user.firstTransactionDate = firstTransactionDate
            
            try? self.managedObjectContext.save()
            completion(user)
        }
    }
    
    func updateUser(completion: @escaping ((User) -> Void)) {
        let fetchRequest = User.createFetchRequest()
        guard
            let users = try? managedObjectContext.fetch(fetchRequest),
            let currentUser = users.first
            else {
                createUser(completion: { [weak self] _ in
                    self?.updateUser(completion: completion)
                })
                return
        }
        
        fetchFirstTransactionDate { [weak self] result in
            
            self?.managedObjectContext.perform {
                
                switch result {
                case .success(let firstTransactionDate):
                    currentUser.firstTransactionDate = firstTransactionDate
                case .failure(_):
                    assertionFailure("Failed to fetch transaction date")
                    currentUser.firstTransactionDate = nil
                }
                
                try? self?.managedObjectContext.save()
                completion(currentUser)
            }
        }
    }
    
    // MARK: Data Updates
    
    func calculateUserScore(percentPerformance: Double, completion: @escaping (Double?) -> Void) {
        let currentUser = readUser()
        
        if let currentUser = currentUser {
            
            if let firstTransactionDate = currentUser.firstTransactionDate {
                
                self.weeksFromFirstTradeDate(firstTransactionDate) { weeksSinceFirstTrade in
                    
                    if let weeksSinceFirstTrade = weeksSinceFirstTrade {
                        
                        if weeksSinceFirstTrade > 0 {
                            
                            if percentPerformance == 0 {
                                completion(-0.5)
                            } else {
                                let initialValue = (abs(percentPerformance) / weeksSinceFirstTrade) * pow((weeksSinceFirstTrade / 3), 2)
                                let absresult = Double.logC(val: initialValue) + 3
                                
                                if absresult > 0 {
                                    let result = percentPerformance > 0 ? absresult : -absresult
                                    completion(result)
                                } else {
                                    completion(absresult)
                                }
                            }
                        }
                        
                    } else {
                        completion(nil)
                    }
                }
            } else {
                updateUser { user in
                    if let _ = user.firstTransactionDate {
                        self.calculateUserScore(percentPerformance: percentPerformance, completion: completion)
                    } else {
                        completion(nil)
                    }
                }
            }
            
        } else {
            updateUser { user in
                if let _ = user.firstTransactionDate {
                    self.calculateUserScore(percentPerformance: percentPerformance, completion: completion)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func weeksFromFirstTradeDate(_ firstTransactionDate: Date? = nil, completion: @escaping (Double?) -> Void) {
        
        func calculateWeekDifference(from firstTransactionDate: Date) -> Double {
            let range = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute],
                                                        from: firstTransactionDate,
                                                        to: Date())
            let weekDiff = Double(range.weekOfYear ?? 0)
            let dayDiff = Double((range.day ?? 0)) / 5
            let hourDiff = Double((range.hour ?? 0)) / (5 * 24)
            let minDiff = Double((range.minute ?? 0)) / (5 * 24 * 60)
            let totalTimeDifference: Double = weekDiff + dayDiff + hourDiff + minDiff
            return totalTimeDifference
        }
        
        if let firstTransactionDate = firstTransactionDate {
            completion(calculateWeekDifference(from: firstTransactionDate))
        } else {
            fetchFirstTransactionDate { result in
                switch result {
                case .success(let earliestTradeDate):
                    if let earliestTradeDate = earliestTradeDate {
                        completion(calculateWeekDifference(from: earliestTradeDate))
                    } else {
                        completion(0)
                    }
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    func fetchFirstTransactionDate(completion: @escaping (Result<Date?, Error>) -> Void) {
        let fetchRequest = User.createFetchRequest()
        guard
            let users = try? managedObjectContext.fetch(fetchRequest),
            let firstTransactionDate = users.first?.firstTransactionDate else {
                
                ledgerLoader.load { [weak self] (result) in
                    guard let self = self else { return }
                    
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
                
            return
        }
        
        completion(.success(firstTransactionDate))
    }
    
    func generateProfileID() -> String {
        if let savedID = userDefaults.string(forKey: Constants.profileID)  {
            return savedID
        } else {
            let profileID = UUID().uuidString
            userDefaults.set(profileID, forKey: Constants.profileID)
            return profileID
        }
    }
    
    // MARK: - Private Methods
    
    private func convertToDate(from string: String) -> Date {
        let df = DateFormatter()
        if string.contains("+") {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        } else if string.contains(".") {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        }
        
        return df.date(from: string)!
    }
}

extension Double {
    static func logC(val: Double, forBase base: Double = 10) -> Double {
        return log(val)/log(base)
    }
}

class DateTransformer {
    
    static func convertStringToDate(_ string: String) -> Date {
        let df = DateFormatter()
        if string.contains("+") {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        } else if string.contains(".") {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        } else {
            df.dateFormat = "yyyy-MM-dd"
        }
        
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
