//
//  PermissionManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/23/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

extension DateComponents {
    func toString() -> String {
        return "\(self.month!)/\(self.day!)/\(self.year!)"
    }
}

class PermissionManager {
    
    struct Constants {
        struct UserDefaults {
            static let isPremium = "isPremium"
            static let screeningDateLookup = "selectedScreenerDictionary"
        }
    }
    
    static let shared = PermissionManager()
    
    // MARK: - Parameters
    
    private let savedScreenerThreshold = 1
    private let savedStockThreshold = 3
    private let screeningThreshold = 3
    
    var isPremium: Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.isPremium)
    }

    private init() {}
    
    // MARK: - Core Data Helper
    
    private func getSavedScreenerCount() -> Int? {
        let request = SavedScreener.createfetchRequest()
        var savedScreeners: [SavedScreener] = []
        do {
            savedScreeners = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedScreeners.count
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getSavedStockCount() -> Int? {
        let request = SavedStock.createfetchRequest()
        var savedStocks: [SavedStock] = []
        do {
            savedStocks = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedStocks.count
        } catch let error {
            print("Fetch failed", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - API
    
    typealias PermissionCompletionHandler = (_ permissionGranted: Bool, _ error: Error?) -> Void
    
    func getSaveScreenerPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium, nil)
            return
        }
        if let savedScreenerCount = getSavedScreenerCount() {
            completion(savedScreenerCount < savedScreenerThreshold, nil)
            return
        }
        
        if getSavedScreenerCount() == nil {
            completion(false, NSError())
        }
    }
    
    func getSaveStockPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium, nil)
            return
        }
        if let savedStockCount = getSavedStockCount() {
            completion(savedStockCount < savedStockThreshold, nil)
            return
        }
        
        if getSavedStockCount() == nil {
            completion(false, NSError())
        }
    }
    
    // Configures current date
    
    private var dateComponent: DateComponents = {
        let date = Date()
        let calendar = Calendar.current
        var components = calendar
            .dateComponents([.year, .month, .day, .minute], from: date)
        components.calendar = Calendar.current
        return components
    }()
        
    var screeningDateLookup: [String: Int] {
        print(UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.screeningDateLookup) as? [String: Int])
        return UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.screeningDateLookup) as? [String: Int] ?? [:]
    }
        
    func incrementCurrentDateScreenerSelection() {
        var dictionary: [String: Int] = screeningDateLookup
        if let val = dictionary[dateComponent.toString()] {
            dictionary[dateComponent.toString()] = val + 1
        } else {
            dictionary[dateComponent.toString()] = 1
        }
        UserDefaults.standard.set(dictionary, forKey: Constants.UserDefaults.screeningDateLookup)
    }

    func verifyScreenerNavigationPermission(completion: ((Bool) -> Void)) {
        if isPremium { completion(true) }
        else {
            // check if should increment in the first place
            let isBelowScreeningThreshold = screeningDateLookup[dateComponent.toString()] ?? 0 < screeningThreshold
            if isBelowScreeningThreshold {
                incrementCurrentDateScreenerSelection()
                completion(true)
            } else {
                // Set up notification service
                setupScreeningNotification()
                completion(false)
            }
        }
    }
    
    private func setupScreeningNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.requestAuthorization { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification()
                }
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            default:
                break
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    private var getNextDateComponents: DateComponents {
        let nextDate = dateComponent.calendar?.date(byAdding: .day, value: 1, to: dateComponent.date!)
        return DateComponents(calendar: Calendar.current, year: nextDate?.year, month: nextDate?.month, day: nextDate?.day)
    }
    
    private func scheduleLocalNotification() {
        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Upful"
        notificationContent.subtitle = "Start Screening!"
        notificationContent.body = "Your daily stock screening limit has been reset. Start searching for stocks again."
        
//        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: getNextDateComponents, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(
            identifier: "upful_local_notification",
            content: notificationContent,
            trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func resetDateLoopUp() {
        var dictionary: [String: Int] = screeningDateLookup
        if screeningDateLookup.count > 5 { dictionary = [:] }
        dictionary[dateComponent.toString()] = 0
        UserDefaults.standard.set(dictionary, forKey: Constants.UserDefaults.screeningDateLookup)
    }

}
