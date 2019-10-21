//
//  AnalyticsMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class AnalyticsLogger {
    enum AnalyticsDefaults {
        static let allowTracking = "allowTracking"
    }
    static let instance = AnalyticsLogger()
    
    private let mixpanelAnalytics = MixPanelAnalytics()
    private let googleAnalytics = FirebaseAnayltics()
    
    private var isTrackingDisabled = false
    
    
    private init() {
        retreiveSetting()
    }
    
    func retreiveSetting() {
        isTrackingDisabled = UserDefaults.standard.bool(forKey: AnalyticsDefaults.allowTracking)
    }
    
    func getAnalyticsPermission() -> Bool {
        return !isTrackingDisabled
    }
    
    func toggleAnalytics() {
        isTrackingDisabled = !isTrackingDisabled
        UserDefaults.standard.set(isTrackingDisabled, forKey: AnalyticsDefaults.allowTracking)
    }
    
    func reportEvents(event: AnalyticsEventName) {
        if !isTrackingDisabled {
            let analyticsAPIs: [AnalyticsTracker] = [mixpanelAnalytics, googleAnalytics]
            analyticsAPIs.forEach { (analyticsItem) in
//                analytics.log(event: event)
                print("Logged event for:", event, analyticsItem)
            }

        }
        
    }
    
}













