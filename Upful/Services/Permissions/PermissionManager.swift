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
    private let screeningThreshold = 6
    
    var isPremium: Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.isPremium)
    }

    private init() {
        resetSavedDates()
    }
    
    
    // MARK: - Core Data Helper
    
    var getSavedScreenerCount: Int? = {
        let request = SavedScreener.createfetchRequest()
        var savedScreeners: [SavedScreener] = []
        do {
            savedScreeners = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedScreeners.count
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    var getSavedStockCount: Int? = {
        let request = SavedStock.createfetchRequest()
        var savedStocks: [SavedStock] = []
        do {
            savedStocks = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            return savedStocks.count
        } catch let error {
            print("Fetch failed", error.localizedDescription)
            return nil
        }
    }()

    // MARK: - Saved Screener and Stocks
    
    typealias PermissionCompletionHandler = (_ permissionGranted: Bool) -> Void
    
    func getSaveScreenerPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium)
        } else {
            if let savedScreenerCount = getSavedScreenerCount {
                completion(savedScreenerCount < savedScreenerThreshold)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func getSaveStockPermission(completion: @escaping PermissionCompletionHandler) {
        if isPremium {
            completion(isPremium)
        } else {
            if let savedStockCount = getSavedStockCount {
                completion(savedStockCount < savedStockThreshold)
                return
            } else {
                completion(false)
            }
        }
    }
        
    // MARK: - Screener Navigation

    private var currentDateComponents: DateComponents = {
        let date = Date()
        let calendar = Calendar.current
        var components = calendar
            .dateComponents([.year, .month, .day, .minute], from: date)
        components.calendar = Calendar.current
        return components
    }()
        
    private var screeningDateLookup: [String: Int] = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.screeningDateLookup) as? [String: Int] ?? [:] {
        didSet {
            UserDefaults.standard.set(
                screeningDateLookup,
                forKey: Constants.UserDefaults.screeningDateLookup)
        }
    }
        
    private func incrementCurrentDateScreenerSelection() {
        if let val = screeningDateLookup[currentDateComponents.toString()] {
            screeningDateLookup[currentDateComponents.toString()] = val + 1
        } else {
            screeningDateLookup[currentDateComponents.toString()] = 0
        }
    }

    func verifyScreenerNavigationPermission(completion: ((Bool) -> Void)) {
        if isPremium { completion(true) }
        else {
            let isBelowScreeningThreshold = screeningDateLookup[currentDateComponents.toString()] ?? 0 < screeningThreshold
            if isBelowScreeningThreshold {
                incrementCurrentDateScreenerSelection()
                completion(true)
            } else {
//                setupScreeningNotification()
                completion(false)
            }
        }
    }
    
    func setupScreeningNotification() {
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
    
    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    private var getNextDateComponents: DateComponents {
        let nextDate = currentDateComponents.calendar?.date(byAdding: .day, value: 1, to: currentDateComponents.date!)
        return DateComponents(calendar: Calendar.current, year: nextDate?.year, month: nextDate?.month, day: nextDate?.day)
    }
    
    private func scheduleLocalNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Upful"
        notificationContent.subtitle = "Start Screening!"
        notificationContent.body = "Your daily stock screening limit has been reset. Start searching for stocks again."
        
//        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: getNextDateComponents, repeats: false)
        
        let notificationRequest = UNNotificationRequest(
            identifier: "upful_local_notification",
            content: notificationContent,
            trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func resetSavedDates() {
        if screeningDateLookup[currentDateComponents.toString()] == nil {
            screeningDateLookup = [:]
            screeningDateLookup[currentDateComponents.toString()] = 1
        }
    }
}
